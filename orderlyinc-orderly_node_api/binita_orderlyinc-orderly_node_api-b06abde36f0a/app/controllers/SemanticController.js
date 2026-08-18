const semanticService = require('../services/semantic.service');

function actor(req) {
  return { userId: req.user_id, userType: req.user_type, producerId: req.producer_id };
}

function numericId(value) {
  return /^\d+$/.test(String(value)) && Number(value) > 0 ? Number(value) : null;
}

function sendError(res, error) {
  const status = error.status || 500;
  res.status(status).json({ status, code: error.code || 'SEMANTIC_QUERY_FAILED', message: status === 500 ? 'Semantic query failed' : error.message });
}

exports.orderContext = async (req, res) => {
  const id = numericId(req.params.id);
  if (!id) return res.status(400).json({ status: 400, code: 'INVALID_ORDER_ID', message: 'A positive numeric order id is required' });
  try { res.status(200).json(await semanticService.getOrderContext(id, actor(req))); }
  catch (error) { sendError(res, error); }
};

exports.deliveryContext = async (req, res) => {
  const id = numericId(req.params.id);
  if (!id) return res.status(400).json({ status: 400, code: 'INVALID_DELIVERY_ID', message: 'A positive numeric order-detail id is required' });
  try { res.status(200).json(await semanticService.getDeliveryContext(id, actor(req))); }
  catch (error) { sendError(res, error); }
};

exports.productAvailability = async (req, res) => {
  const id = numericId(req.params.id);
  if (!id) return res.status(400).json({ status: 400, code: 'INVALID_PRODUCT_ID', message: 'A positive numeric product id is required' });
  try { res.status(200).json(await semanticService.getProductAvailability(id, actor(req))); }
  catch (error) { sendError(res, error); }
};

