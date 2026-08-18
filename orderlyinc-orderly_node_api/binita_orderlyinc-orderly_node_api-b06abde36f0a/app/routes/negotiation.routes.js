module.exports = (app) => {
  const negotiation = require('../controllers/NegotiationController');
  app.post('/negotiation/cart/offer', negotiation.createOffer);
  app.post('/negotiation/cart/offer/accept', negotiation.acceptOffer);
};
