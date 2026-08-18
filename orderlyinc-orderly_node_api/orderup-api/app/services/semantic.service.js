const sql = require('../utils/dbConnection');
const { iri, ONTOLOGY_VERSION } = require('../ontology/mappings');
const { projectOrderContext } = require('../ontology/semanticProjector');
const { asRole, canReadOrder, visibleOrderLines } = require('../ontology/accessPolicy');

function query(statement, params = []) {
  return new Promise((resolve, reject) => {
    sql.query(statement, params, (error, rows) => error ? reject(error) : resolve(rows));
  });
}

function httpError(status, message, code) {
  const error = new Error(message);
  error.status = status;
  error.code = code;
  return error;
}

async function getOrderContext(orderId, actor) {
  const orders = await query('SELECT * FROM order_tb WHERE order_id = ? LIMIT 1', [orderId]);
  if (!orders.length) throw httpError(404, 'Order not found', 'ORDER_NOT_FOUND');
  const order = orders[0];
  const lines = await query(
    `SELECT odi.*, pl.product_name AS catalog_product_name,
            pl.product_desc AS catalog_product_desc, pl.product_qty, pl.display_status,
            pr.producer_name, da.first_name AS agent_first_name, da.last_name AS agent_last_name
       FROM order_details_id odi
       LEFT JOIN product_list pl ON pl.product_id = odi.product_id
       LEFT JOIN producer_list pr ON pr.producer_id = odi.producer_id
       LEFT JOIN users_tb da ON da.user_id = odi.delivery_agent
      WHERE odi.order_id = ?
      ORDER BY odi.order_details_id`, [orderId]);
  if (!canReadOrder(actor, order, lines)) throw httpError(403, 'Not allowed to read this order context', 'SEMANTIC_ACCESS_DENIED');
  const scopedLines = visibleOrderLines(actor, lines);

  const customerRows = await query(
    'SELECT user_id, first_name, last_name, email_id, mobile FROM users_tb WHERE user_id = ? LIMIT 1',
    [order.user_id]);
  const destinationRows = order.dest_address
    ? await query('SELECT * FROM user_address WHERE ua_id = ? LIMIT 1', [order.dest_address])
    : [];
  const lineIds = scopedLines.map(line => line.order_details_id);
  let history = [];
  let returns = [];
  let temperatures = [];
  if (lineIds.length) {
    history = await query('SELECT * FROM order_history WHERE order_detail_id IN (?) ORDER BY oh_date_time', [lineIds]);
    returns = await query('SELECT * FROM product_return WHERE order_details_id IN (?) ORDER BY created_at', [lineIds]);
    temperatures = await query('SELECT * FROM temp_location_history WHERE orders_detail_id IN (?) ORDER BY created_at DESC LIMIT 200', [lineIds]);
  }
  const context = projectOrderContext({ order, lines: scopedLines, customer: customerRows[0], destination: destinationRows[0], history, returns, temperatures });
  context.accessScope = asRole(actor.userType) === 1 ? 'producer-lines' : asRole(actor.userType) === 2 ? 'assigned-deliveries' : 'complete-order';
  return context;
}

async function getDeliveryContext(orderDetailId, actor) {
  const rows = await query('SELECT order_id FROM order_details_id WHERE order_details_id = ? LIMIT 1', [orderDetailId]);
  if (!rows.length) throw httpError(404, 'Delivery/order line not found', 'DELIVERY_NOT_FOUND');
  const context = await getOrderContext(rows[0].order_id, actor);
  const line = context.lines.find(item => item.provenance.source.recordId === Number(orderDetailId));
  if (!line) throw httpError(404, 'Delivery/order line not found', 'DELIVERY_NOT_FOUND');
  return {
    '@context': context['@context'],
    ontologyVersion: context.ontologyVersion,
    generatedAt: context.generatedAt,
    order: context.order,
    destination: context.destination,
    delivery: line,
    validation: context.validation
  };
}

async function getProductAvailability(productId, actor) {
  const rows = await query(
    `SELECT pl.*, pr.producer_name
       FROM product_list pl
       LEFT JOIN producer_list pr ON pr.producer_id = pl.producerid
      WHERE pl.product_id = ? LIMIT 1`, [productId]);
  if (!rows.length) throw httpError(404, 'Product not found', 'PRODUCT_NOT_FOUND');
  const row = rows[0];
  const role = asRole(actor.userType);
  if (Number(row.display_status) !== 0 && role !== 3 && !(role === 1 && Number(actor.producerId) === Number(row.producerid))) {
    throw httpError(404, 'Product not found', 'PRODUCT_NOT_FOUND');
  }
  const generatedAt = new Date().toISOString();
  return {
    '@context': { orderup: 'https://orderlyinc.com/ontology/orderup#' },
    ontologyVersion: ONTOLOGY_VERSION,
    generatedAt,
    product: {
      '@id': iri('Product', row.product_id), '@type': 'orderup:Product', name: row.product_name,
      description: row.product_desc, active: Number(row.display_status) === 0,
      suppliedBy: iri('Producer', row.producerid),
      provenance: { source: { table: 'product_list', recordId: row.product_id }, ontologyVersion: ONTOLOGY_VERSION, projectedAt: generatedAt }
    },
    producer: { '@id': iri('Producer', row.producerid), '@type': 'orderup:Producer', name: row.producer_name },
    inventory: {
      '@id': iri('InventoryItem', row.product_id), '@type': 'orderup:InventoryItem',
      product: iri('Product', row.product_id), availableQuantity: row.product_qty,
      available: Number(row.display_status) === 0 && Number(row.product_qty) > 0
    }
  };
}

module.exports = { getOrderContext, getDeliveryContext, getProductAvailability };
