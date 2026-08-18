const Producer = require('../models/producer.model.js');
const sql = require('../utils/dbConnection.js');
const { validationResult } = require('express-validator');

exports.store_context = (req, res) => {
  sql.query(
    'SELECT producer_id, producer_name FROM producer_list WHERE producer_id = ? LIMIT 1',
    [req.producer_id],
    (err, rows) => {
      if (err) {
        return res.status(500).send({
          statusCode: 500,
          message: err.message || 'Could not fetch store context'
        });
      }

      const store = rows && rows.length ? rows[0] : null;
      return res.send({
        statusCode: 200,
        data: {
          id: store ? String(store.producer_id) : '',
          name: store ? store.producer_name : ''
        }
      });
    }
  );
};

exports.list_modern = (req, res) => {
  sql.query(
    'SELECT producer_id, producer_name, producer_image_url, producer_icon_url FROM producer_list ORDER BY producer_name',
    (err, rows) => {
      if (err) {
        return res.status(500).send({
          statusCode: 500,
          message: err.message || 'Could not fetch stores'
        });
      }

      const stores = (rows || []).map((store) => ({
        store_id: String(store.producer_id),
        name: store.producer_name || '',
        banner: store.producer_image_url || '',
        icon: store.producer_icon_url || '',
        banner_url: store.producer_image_url || '',
        icon_url: store.producer_icon_url || '',
        distance: 0
      }));

      return res.send({ statusCode: 200, data: stores });
    }
  );
};

// Create and Save a new Customer
exports.list = (req, res) => {
    
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
  
  // get customer lat long 
  var producer = {
      cust_lat : req.body.cust_lat,
      cust_long : req.body.cust_long
  };

    // Save Customer in the database
    Producer.list(producer, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while fetching producer list."
        });
      else res.send(data);
    });
};
