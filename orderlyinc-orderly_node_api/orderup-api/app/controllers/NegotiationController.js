const negotiationService = require('../services/negotiation.service');

function sendError(res, error) {
  const status = error.status || 500;
  return res.status(status).send({
    statusCode: status,
    code: error.code || 'NEGOTIATION_FAILED',
    message: status === 500 ? 'Could not negotiate this basket' : error.message,
  });
}

exports.createOffer = async (req, res) => {
  if (Number(req.user_type) !== 0) {
    return res.status(403).send({ statusCode: 403, message: 'Only customers can negotiate a basket' });
  }
  try {
    const offer = await negotiationService.negotiate(Number(req.user_id), req.body?.message);
    return res.send({ statusCode: 200, data: offer });
  } catch (error) {
    return sendError(res, error);
  }
};

exports.acceptOffer = (req, res) => {
  try {
    const offer = negotiationService.accept(Number(req.user_id), req.body?.offer_id);
    return res.send({
      statusCode: 200,
      data: offer,
      message: 'Offer reserved as a preview. Checkout pricing is unchanged in this milestone.',
    });
  } catch (error) {
    return sendError(res, error);
  }
};
