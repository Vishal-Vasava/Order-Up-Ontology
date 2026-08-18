module.exports = (app) => {
  const semantic = require('../controllers/SemanticController');
  app.get('/semantic/orders/:id/context', semantic.orderContext);
  app.get('/semantic/products/:id/availability', semantic.productAvailability);
  app.get('/semantic/deliveries/:id/context', semantic.deliveryContext);
};

