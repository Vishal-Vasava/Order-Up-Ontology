const Admin = require('../models/admin.model.js');
const { validationResult } = require('express-validator');

// list every store (producer) on the platform
exports.list_producers = (req, res) => {
  Admin.list_producers((err, data) => {
    if (err)
      res.status(500).send({
        message: err.message || "Some error occurred while fetching producers"
      });
    else res.send(data);
  });
};

// list every delivery agent on the platform
exports.list_delivery_agents = (req, res) => {
  Admin.list_delivery_agents((err, data) => {
    if (err)
      res.status(500).send({
        message: err.message || "Some error occurred while fetching delivery agents"
      });
    else res.send(data);
  });
};

// list every customer on the platform
exports.list_customers = (req, res) => {
  Admin.list_customers((err, data) => {
    if (err)
      res.status(500).send({
        message: err.message || "Some error occurred while fetching customers"
      });
    else res.send(data);
  });
};

// list orders across every store, optionally filtered by ?status=
exports.list_orders = (req, res) => {
  var filters = {
    status: req.query.status
  };
  Admin.list_orders(filters, (err, data) => {
    if (err)
      res.status(500).send({
        message: err.message || "Some error occurred while fetching orders"
      });
    else res.send(data);
  });
};

// platform-wide dashboard counts
exports.dashboard_stats = (req, res) => {
  Admin.dashboard_stats((err, data) => {
    if (err)
      res.status(500).send({
        message: err.message || "Some error occurred while fetching stats"
      });
    else res.send(data);
  });
};

// create a new store (producer_list row + its manager account)
exports.create_producer = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  Admin.create_producer(req.body, (err, data) => {
    if (err)
      res.status(err instanceof Error ? 500 : 409).send({
        message: err.message || "Some error occurred while creating the producer"
      });
    else res.send(data);
  });
};

// update a store's catalog-facing details
exports.update_producer = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  Admin.update_producer(req.body, (err, data) => {
    if (err)
      res.status(err instanceof Error ? 500 : 404).send({
        message: err.message || "Some error occurred while updating the producer"
      });
    else res.send(data);
  });
};

// activate/deactivate a store
exports.update_producer_status = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  Admin.update_producer_status(req.body, (err, data) => {
    if (err)
      res.status(err instanceof Error ? 500 : 404).send({
        message: err.message || "Some error occurred while updating the producer status"
      });
    else res.send(data);
  });
};

// create a new delivery agent account
exports.create_delivery_agent = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  Admin.create_delivery_agent(req.body, (err, data) => {
    if (err)
      res.status(err instanceof Error ? 500 : 409).send({
        message: err.message || "Some error occurred while creating the delivery agent"
      });
    else res.send(data);
  });
};

// update a delivery agent's profile details
exports.update_delivery_agent = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  Admin.update_delivery_agent(req.body, (err, data) => {
    if (err)
      res.status(err instanceof Error ? 500 : 404).send({
        message: err.message || "Some error occurred while updating the delivery agent"
      });
    else res.send(data);
  });
};

// activate/deactivate a delivery agent
exports.update_delivery_agent_status = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  Admin.update_delivery_agent_status(req.body, (err, data) => {
    if (err)
      res.status(err instanceof Error ? 500 : 404).send({
        message: err.message || "Some error occurred while updating the delivery agent status"
      });
    else res.send(data);
  });
};

exports.list_products = (req, res) => {
  Admin.list_products((err, data) => {
    if (err) res.status(500).send({ message: err.message || "Some error occurred while fetching products" });
    else res.send(data);
  });
};

exports.create_product = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  Admin.create_product(req.body, (err, data) => {
    if (err) res.status(500).send({ message: err.message || "Some error occurred while creating the product" });
    else res.send(data);
  });
};

exports.update_product = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  Admin.update_product(req.body, (err, data) => {
    if (err) res.status(500).send({ message: err.message || "Some error occurred while updating the product" });
    else res.send(data);
  });
};

exports.update_product_status = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  Admin.update_product_status(req.body, (err, data) => {
    if (err) res.status(500).send({ message: err.message || "Some error occurred while updating product status" });
    else res.send(data);
  });
};
