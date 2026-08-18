const { ONTOLOGY_VERSION, iri } = require('./mappings');

const STATUS_LABELS = Object.freeze({
  0: 'Placed', 1: 'Ready', 2: 'Shipped', 3: 'Delivered', 4: 'Return requested',
  5: 'Replacement requested', 6: 'Canceled', 7: 'Return confirmed',
  8: 'Return rejected', 9: 'Return shipped', 10: 'Return delivered',
  11: 'Replacement confirmed', 12: 'Replacement rejected',
  13: 'Replacement shipped', 14: 'Replacement delivered'
});

function provenance(table, id, projectedAt) {
  return { source: { table, recordId: id }, ontologyVersion: ONTOLOGY_VERSION, projectedAt };
}

function entity(type, id, attributes, sourceTable, projectedAt) {
  return {
    '@id': iri(type, id),
    '@type': `orderup:${type}`,
    ...attributes,
    provenance: provenance(sourceTable, id, projectedAt)
  };
}

function compact(values) {
  return Object.fromEntries(Object.entries(values).filter(([, value]) => value !== null && value !== undefined));
}

function projectOrderContext(data, now = new Date()) {
  if (!data || !data.order) throw new Error('Order source record is required');
  const projectedAt = now.toISOString();
  const order = data.order;
  const customer = data.customer ? entity('Customer', data.customer.user_id, compact({
    name: [data.customer.first_name, data.customer.last_name].filter(Boolean).join(' '),
    email: data.customer.email_id,
    mobile: data.customer.mobile
  }), 'users_tb', projectedAt) : null;
  const destination = data.destination ? entity('Address', data.destination.ua_id, compact({
    address: data.destination.address,
    city: data.destination.city,
    state: data.destination.state,
    country: data.destination.country,
    postalCode: data.destination.zipcode,
    latitude: data.destination.add_latitude,
    longitude: data.destination.add_longitude
  }), 'user_address', projectedAt) : null;

  const lines = (data.lines || []).map((row) => {
    const line = entity('OrderLine', row.order_details_id, compact({
      orderNumber: row.order_number,
      quantity: row.qty,
      unitPrice: row.rate_per_hour,
      total: row.total,
      statusCode: row.current_status,
      statusLabel: STATUS_LABELS[row.current_status] || 'Unknown',
      referencesProduct: iri('Product', row.product_id),
      suppliedBy: iri('Producer', row.producer_id),
      deliveredBy: row.delivery_agent ? iri('DeliveryAgent', row.delivery_agent) : undefined
    }), 'order_details_id', projectedAt);
    line.product = entity('Product', row.product_id, compact({
      name: row.catalog_product_name || row.product_name,
      description: row.catalog_product_desc || row.product_desc,
      availableQuantity: row.product_qty,
      active: Number(row.display_status) === 0,
      suppliedBy: iri('Producer', row.producer_id)
    }), 'product_list', projectedAt);
    line.producer = entity('Producer', row.producer_id, { name: row.producer_name }, 'producer_list', projectedAt);
    if (row.delivery_agent) {
      line.deliveryAgent = entity('DeliveryAgent', row.delivery_agent, {
        name: [row.agent_first_name, row.agent_last_name].filter(Boolean).join(' ')
      }, 'users_tb', projectedAt);
    }
    line.statusHistory = (data.history || []).filter(x => x.order_detail_id === row.order_details_id).map(x =>
      entity('OrderStatusEvent', x.order_history_id, {
        statusCode: x.oh_status,
        statusLabel: STATUS_LABELS[x.oh_status] || 'Unknown',
        occurredAt: x.oh_date_time
      }, 'order_history', projectedAt));
    line.returnRequests = (data.returns || []).filter(x => x.order_details_id === row.order_details_id).map(x =>
      entity('ReturnRequest', x.return_id, compact({ type: x.return_type, title: x.return_title, review: x.review, status: x.prod_status }), 'product_return', projectedAt));
    line.temperatureObservations = (data.temperatures || []).filter(x => x.orders_detail_id === row.order_details_id).map(x =>
      entity('TemperatureObservation', x.temp_his_id, compact({ deviceId: x.device_id, latitude: x.latitude, longitude: x.longitude, temperature: x.temperature, observedAt: x.created_at }), 'temp_location_history', projectedAt));
    return line;
  });

  const graphOrder = entity('Order', order.order_id, compact({
    orderNumber: `OD${String(order.order_id).padStart(6, '0')}`,
    placedBy: customer && customer['@id'],
    hasDestination: destination && destination['@id'],
    placedAt: order.order_date,
    deliveryDate: order.delivery_date,
    deliverySlot: order.delivery_slot,
    subtotal: order.sub_total,
    deliveryCharge: order.delivery_charge,
    total: order.grant_total,
    contains: lines.map(line => line['@id'])
  }), 'order_tb', projectedAt);

  return {
    '@context': { orderup: 'https://orderlyinc.com/ontology/orderup#', resource: 'https://orderlyinc.com/resource/' },
    ontologyVersion: ONTOLOGY_VERSION,
    generatedAt: projectedAt,
    order: graphOrder,
    customer,
    destination,
    lines,
    validation: validateOrderContext({ order: graphOrder, customer, destination, lines })
  };
}

function validateOrderContext(context) {
  const issues = [];
  if (!context.customer) issues.push({ code: 'MISSING_CUSTOMER', severity: 'error' });
  if (!context.lines.length) issues.push({ code: 'ORDER_WITHOUT_LINES', severity: 'error' });
  if (!context.destination) issues.push({ code: 'MISSING_DESTINATION', severity: 'warning' });
  context.lines.forEach(line => {
    if (!line.product) issues.push({ code: 'MISSING_PRODUCT', severity: 'error', entity: line['@id'] });
    if (!line.producer) issues.push({ code: 'MISSING_PRODUCER', severity: 'error', entity: line['@id'] });
  });
  return { valid: !issues.some(issue => issue.severity === 'error'), issues };
}

module.exports = { STATUS_LABELS, projectOrderContext, validateOrderContext };

