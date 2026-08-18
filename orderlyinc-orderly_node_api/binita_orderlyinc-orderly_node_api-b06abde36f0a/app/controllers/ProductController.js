const Product = require('../models/product.model.js');
const { validationResult } = require('express-validator');

// Create and Save a new Customer
exports.product_list = (req, res) => {
    // Validate request
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    
    // Create a User
    var product = {
        producer_id : req.body.producer_id,
        // type : req.body.type,
        offset : req.body.offset
    };
    //res.send(user);
  
    // Save Customer in the database
    Product.product_list(product, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while fetching product list"
        });
      else res.send(data);
    });
};

