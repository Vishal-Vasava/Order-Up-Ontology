const Cart = require('../models/cart.model.js');
const { validationResult } = require('express-validator');
const sql = require('../utils/dbConnection.js');

// add product in cart
exports.add_to_cart = (req, res) => {
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
    
    // add to cart
    var cart = {
        user_id : req.user_id,
        product_id : req.body.product_id,
        qty : req.body.qty
    };
    //res.send(user);
  
    // Save data in cart
    Cart.add_to_cart(cart, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while add data in cart"
        });
      else res.send(data);
    });

    
};

// Compatibility endpoint for the newer Flutter customer app.
exports.add_to_cart_modern = (req, res) => {
  const productId = Number(req.body.product_id);
  const requestedQty = Number(req.body.qty);
  if (!Number.isInteger(productId) || productId <= 0 || !Number.isInteger(requestedQty) || requestedQty <= 0) {
    return res.status(400).send({ statusCode: 400, message: 'A valid product and quantity are required' });
  }

  sql.query(
    'SELECT product_id, producerid, rate_per_hour, product_qty FROM product_list WHERE product_id = ? AND display_status = 0 LIMIT 1',
    [productId],
    (productErr, products) => {
      if (productErr) {
        return res.status(500).send({ statusCode: 500, message: 'Could not check product availability' });
      }
      if (!products.length) {
        return res.send({ statusCode: 201, data: { cart: [] }, message: 'Product is not available' });
      }

      const product = products[0];
      sql.query(
        'SELECT cart_id, qty FROM cart_tb WHERE user_id = ? AND product_id = ? LIMIT 1',
        [req.user_id, productId],
        (cartErr, rows) => {
          if (cartErr) {
            return res.status(500).send({ statusCode: 500, message: 'Could not check the cart' });
          }

          const nextQty = Number(rows[0] && rows[0].qty || 0) + requestedQty;
          if (nextQty > Number(product.product_qty || 0)) {
            return res.send({ statusCode: 201, data: { cart: [] }, message: 'Required quantity is not available' });
          }

          const statement = rows.length
            ? ['UPDATE cart_tb SET qty = ?, producer_id = ?, rate_per_hour = ? WHERE cart_id = ? AND user_id = ?',
              [nextQty, product.producerid, product.rate_per_hour, rows[0].cart_id, req.user_id]]
            : ['INSERT INTO cart_tb (user_id, producer_id, product_id, rate_per_hour, qty) VALUES (?, ?, ?, ?, ?)',
              [req.user_id, product.producerid, productId, product.rate_per_hour, requestedQty]];

          sql.query(statement[0], statement[1], (writeErr, result) => {
            if (writeErr) {
              return res.status(500).send({ statusCode: 500, message: 'Could not add item to cart' });
            }
            return res.send({
              statusCode: 200,
              data: { cart_id: String(rows.length ? rows[0].cart_id : result.insertId), qty: nextQty },
              message: 'Item added'
            });
          });
        }
      );
    }
  );
};

const modernCurrency = (code) => ({
  _id: '',
  name: code || 'USD',
  locale: 'en_US',
  createdAt: new Date(0).toISOString(),
  updatedAt: new Date(0).toISOString(),
  code: code || 'USD'
});

const modernProducer = (row) => ({
  _schedule: { days: '', frequency: '' },
  urgent_delivery: false,
  _id: String(row.producerid || ''),
  id: String(row.producerid || ''),
  name: row.producer_name || '',
  desc: '',
  banner: '',
  icon: '',
  status: true,
  createdAt: new Date(0).toISOString(),
  updatedAt: new Date(0).toISOString(),
  _currency: modernCurrency(row.currency),
  urgent_delivery_charge: 0,
  banner_url: '',
  icon_url: ''
});

// Adapt the legacy flat cart rows into the grouped structure used by Flutter.
exports.view_cart_modern = (req, res) => {
  const query = `SELECT ct.cart_id, pl.producerid, ct.product_id, pl.rate_per_hour,
    ct.qty, pl.product_name, pl.product_desc, pl.product_qty AS available_qty,
    ctb.currency, utb.unit, prodtb.producer_name,
    COALESCE(MIN(pit.img_path), '') AS img_paths
    FROM cart_tb ct
    JOIN product_list pl ON ct.product_id = pl.product_id
    LEFT JOIN product_img_tb pit ON pl.product_id = pit.product_id
    LEFT JOIN currency_tb ctb ON pl.currency_id = ctb.cur_id
    LEFT JOIN unit_tb utb ON pl.unit_id = utb.unit_tb
    LEFT JOIN producer_list prodtb ON pl.producerid = prodtb.producer_id
    WHERE ct.user_id = ?
    GROUP BY ct.cart_id, pl.producerid, ct.product_id, pl.rate_per_hour, ct.qty,
      pl.product_name, pl.product_desc, pl.product_qty, ctb.currency, utb.unit,
      prodtb.producer_name`;

  sql.query(query, [req.user_id], (err, rows) => {
    if (err) {
      return res.status(500).send({
        statusCode: 500,
        message: err.message || 'Could not fetch cart'
      });
    }

    rows = Array.isArray(rows) ? rows : [];
    const groups = new Map();
    const now = new Date(0).toISOString();

    rows.forEach((row) => {
      const producerId = String(row.producerid || '');
      if (!groups.has(producerId)) {
        groups.set(producerId, {
          producer: modernProducer(row),
          items: [],
          slots: []
        });
      }

      const imageUrl = row.img_paths || '';
      const price = Number(row.rate_per_hour || 0);
      const qty = Number(row.qty || 0);
      groups.get(producerId).items.push({
        _id: String(row.cart_id),
        qty,
        isAvailable: Number(row.available_qty || qty) >= qty,
        cart_item_price: Math.round(price * qty),
        product: {
          _filters: [],
          images: [],
          _id: String(row.product_id),
          id: String(row.product_id),
          name: row.product_name || '',
          desc: row.product_desc || '',
          image: imageUrl,
          image_url: imageUrl,
          images_url: imageUrl ? [{ url: imageUrl, is_default: true, name: row.product_name || '' }] : [],
          price: Math.round(price),
          qty: Number(row.available_qty || 0),
          visible: true,
          deleted: false,
          _currency: modernCurrency(row.currency),
          _producer: modernProducer(row),
          _creator: '',
          _returnPolicy: null,
          _estimatedPickup: null,
          createdAt: now,
          updatedAt: now,
          unit: row.unit || ''
        }
      });
    });

    return res.send({
      statusCode: 200,
      data: { cart: Array.from(groups.values()), charges: [] },
      message: 'Success'
    });
  });
};

// add product in cart
exports.update_cart = (req, res) => {
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
  
  // add to cart
  var cart = {
      user_id : req.user_id,
      cart_id : req.body.cart_id,
      qty : req.body.qty
  };
  //res.send(user);

  // Save data in cart
  Cart.update_cart(cart, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while updating cart"
      });
    else res.send(data);
  });

  
};


 // fetch cart details
 exports.view_cart = (req, res) => {

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
    
    // fetch from cart
    var cart = {
        user_id : req.user_id,
        cust_lat : req.body.cust_lat,
        cust_long : req.body.cust_long
    };

    Cart.view_cart(cart, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while fetching product from cart"
        });
      else res.send(data);
    });
};  

// delete cart details
exports.delete_cart = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // delete from cart
 var cart = {
    cart_id : req.body.cart_id,
    user_id : req.user_id
 };

 Cart.delete_cart(cart, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while remove product from cart"
     });
   else res.send(data);
 });
};  
