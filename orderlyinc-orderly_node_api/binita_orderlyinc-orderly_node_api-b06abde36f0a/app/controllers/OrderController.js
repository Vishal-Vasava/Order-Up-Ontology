const Order = require('../models/order.model.js');
const { validationResult } = require('express-validator');
const sql = require('../utils/dbConnection.js');

// add address
exports.add_address = (req, res) => {

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

  var address_type = req.body.address_type ? req.body.address_type.trim().toLowerCase() : 'Home';
 
 // address
 var order = {
    userid : req.user_id,
    user_name : req.body.user_name,
    mobile : req.body.mobile,
    email_id : req.body.email_id,
    street_no : req.body.street_no?req.body.street_no:'',
    flat_no : req.body.flat_no?req.body.flat_no:'',
    address : req.body.address,
    zipcode : req.body.zipcode,
    city : req.body.city,
    state : req.body.state,
    country : req.body.country,
    add_latitude : req.body.add_latitude,
    add_longitude : req.body.add_longitude,
    address_type : (address_type == 'home' ||  address_type == 'office')?address_type:'Home',
    is_default : (req.body.is_default && req.body.is_default == 1)  ? 1 : 0
 };

 Order.add_address(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 });

};  

// fetch user details
exports.view_address = (req, res) => {

    // Validate request
    if (!req.body) {
     res.status(400).send({
       message: "Content can not be empty!"
     });
   }
   
   // fetch from cart
   var order = {
       userid : req.user_id
   };

   Order.view_address(order, (err, data) => {
     if (err)
       res.status(500).send({
         message:
           err.message || "Some error occurred while fetching address"
       });
     else res.send(data);
   });
};  

// update address
exports.update_address = (req, res) => {

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
 
 var address_type = req.body.address_type ? req.body.address_type.trim().toLowerCase() : 'Home';
 // address
 var order = {
    userid : req.user_id,
    addressid : req.body.addressid,
    user_name : req.body.user_name,
    mobile : req.body.mobile,
    email_id : req.body.email_id,
    street_no : req.body.street_no?req.body.street_no:'',
    flat_no : req.body.flat_no?req.body.flat_no:'',
    address : req.body.address,
    zipcode : req.body.zipcode,
    city : req.body.city,
    state : req.body.state,
    country : req.body.country,
    add_latitude : req.body.add_latitude,
    add_longitude : req.body.add_longitude,
    address_type : (address_type == 'home' ||  address_type == 'office')?address_type:'Home',
    is_default : (req.body.is_default && req.body.is_default == 1)  ? 1 : 0
 };

 Order.update_address(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 });

}; 

// delete address
exports.delete_address = (req, res) => {

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
 
 // address
 var order = {
  address_id : req.body.address_id,
  user_id : req.user_id
 };

 Order.delete_address(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 });

}; 

exports.urgent_charges = (req, res) => {
    
    // fetch urgent delivery charges
    Order.urgent_charges(req, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while fetching urgent charges."
        });
      else res.send(data);
    });
};

// place order
exports.place_order = (req, res) => {

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
 
 // address
 var orders = {
    user_id : req.user_id,
    // cart_array : req.body.cart_array,
    delivery_option : req.body.delivery_type,
    delivery_date : req.body.delivery_date,
    delivery_slot : req.body.delivery_slot,
    order_status_id : 0,
    // src_address_id : req.body.src_address_id,
    dest_address_id : req.body.dest_address_id,
    payment_transaction_id : req.body.payment_transaction_id,
    payment_mode : req.body.payment_mode,
    discount : req.body.discount,
    // delivery_charge : req.body.urgent_amount,
    // sub_total : req.body.sub_total,
    // convinience_fee : req.body.convinience_fee,
    // grant_total : req.body.grant_total,
 };

 Order.place_order(orders, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 }); 
 
};  



// fetch my order details
exports.my_order = (req, res) => {

 
 // fetch from cart
 var order = {
     userid : req.user_id,
     filter : req.body.filter
 };

Order.my_order(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
};  

exports.my_orders_modern = (req, res) => {
  const order = {
    userid: req.user_id,
    filter: req.body && req.body.filter ? req.body.filter : {}
  };

  Order.my_order(order, (err, data) => {
    if (err) {
      return res.status(500).send({
        statusCode: 500,
        message: err.message || 'Could not fetch customer orders'
      });
    }

    const orders = data && Array.isArray(data.orders) ? data.orders : [];
    return res.send({ statusCode: 200, data: { orders } });
  });
};


// fetch orders for a store manager (producer) against status
exports.producer_orders = (req, res) => {

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
 var order = {
    producerid : req.producer_id,
    status : req.body.status
 };

 Order.producer_orders(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address" 
     });
   else res.send(data);
 });
};  

const modernCurrency = (currency, name) => ({
  _id: '',
  name: name || 'US Dollar',
  locale: 'en_US',
  code: currency || 'USD'
});

const legacyOrderStatus = {
  pending: 0,
  confirmed: 1,
  ready: 1,
  shipped: 2,
  delivered: 3,
  rejected: 6,
  cancelled: 6,
  returned: 4,
  replaced: 5,
  refundProcess: 4,
  refunded: 5
};

// Translate the legacy store-order response into the newer Flutter contract.
exports.store_orders_modern = (req, res) => {
  const requestedStatus = req.body && req.body.status ? req.body.status : 'pending';
  const status = Object.prototype.hasOwnProperty.call(legacyOrderStatus, requestedStatus)
    ? legacyOrderStatus[requestedStatus]
    : 0;

  Order.producer_orders({ producerid: req.producer_id, status }, (err, data) => {
    if (err) {
      return res.status(500).send({ statusCode: 500, message: err.message || 'Could not fetch orders' });
    }

    const rows = Array.isArray(data.orders) ? data.orders : [];
    const orders = rows.map((row) => ({
      _id: String(row.order_id),
      delivery_type: 'standard',
      delivery_date: new Date(row.order_date || Date.now()).toISOString(),
      delivery_slot: '',
      _currency: modernCurrency(row.currency, row.currency_type),
      createdAt: new Date(row.order_date || Date.now()).toISOString(),
      status: requestedStatus,
      order_number: row.order_number || String(row.order_id),
      order_items_amount: Number(row.total_amount || 0),
      producer: {
        _id: String(row.producer_id || req.producer_id || ''),
        name: '',
        desc: '',
        icon_url: row.producer_icon_url || '',
        banner_url: row.producer_image_url || ''
      },
      order_items_count: Number(row.cnt || 0)
    }));

    return res.send({ statusCode: 200, data: { orders }, msg: 'Success' });
  });
};

// Claims use the legacy return-order list. Empty stores receive a valid empty state.
exports.store_claims_modern = (req, res) => {
  Order.producer_order_return({ producerid: req.producer_id }, (err, data) => {
    if (err) {
      return res.status(500).send({ statusCode: 500, message: err.message || 'Could not fetch claims' });
    }

    const rows = Array.isArray(data.orders) ? data.orders : [];
    const orderDetails = rows.map((row) => ({
      _id: String(row.order_details_id),
      price: Number(row.rate_per_hour || 0),
      qty: Number(row.qty || 0),
      createdAt: new Date(row.order_date || Date.now()).toISOString(),
      _customer: { email: '', phone: '', first_name: '', last_name: '' },
      order_number: row.order_number || '',
      _currency: modernCurrency(),
      paid_status: false,
      order_sum: Number(row.total_amount || 0)
    }));
    const total = orderDetails.reduce((sum, row) => sum + row.order_sum, 0);

    return res.send({
      statusCode: 200,
      data: { order_details: orderDetails, paid_amount: 0, pending_amount: total, total_amount: total },
      msg: 'Success'
    });
  });
};

exports.store_customers_modern = (req, res) => {
  const query = `
    SELECT ct.user_id, ct.first_name, ct.last_name, ct.email_id AS email,
           ct.mobile, SUM(odi.total) AS total_amount_spend,
           ctb.currency_type, ctb.currency
      FROM order_details_id odi
      JOIN order_tb ot ON ot.order_id = odi.order_id
      JOIN users_tb ct ON ct.user_id = ot.user_id
      LEFT JOIN currency_tb ctb ON ot.currency_id = ctb.cur_id
     WHERE odi.producer_id = ? AND odi.current_status = 3
     GROUP BY ct.user_id, ct.first_name, ct.last_name, ct.email_id,
              ct.mobile, ctb.currency_type, ctb.currency
     ORDER BY total_amount_spend DESC
     LIMIT 10`;

  sql.query(query, [req.producer_id], (err, rows) => {
    if (err) {
      return res.status(500).send({ statusCode: 500, message: err.message || 'Could not fetch customers' });
    }

    const customerRows = Array.isArray(rows) ? rows : [];
    const customers = customerRows.map((row, index) => ({
      _id: String(row.user_id || row.user_ids || index),
      email: row.email || '',
      phone: row.mobile || '',
      first_name: row.first_name || '',
      last_name: row.last_name || '',
      _currency: [modernCurrency(row.currency, row.currency_type)],
      order_sum: Number(row.total_amount_spend || 0)
    }));

    return res.send({
      statusCode: 200,
      data: { customer_details: customers, total_pages: customers.length ? 1 : 0 },
      msg: 'Success'
    });
  });
};


// fetch order details for a store manager (producer) against status
exports.producer_orders_details = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // fetch from cart
 var order = {
  order_id : req.body.order_id,
    producerid:req.producer_id,
    status:req.body.status
 };

 Order.producer_orders_details(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
}; 

// update order status
exports.update_order_status = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // fetch from cart
 var order = {
    user_id : req.user_id,
    producer_id : req.producer_id,
    user_type : req.user_type,
    order_detail_id : req.body.order_detail_id,
    status : req.body.status,
    reject_reason: req.body.reject_reason
    // flag: req.body.flag,
    // device_id : req.body.device_id,
    // truck_id: req.body.truck_id
 };

 Order.update_order_status(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address" 
     });
   else res.send(data);
 });
};

// product review
exports.product_review = (req, res) => {

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
 
 // address
 var order = {
    order_number : req.body.order_details_id,
    product_id : req.body.product_id,
    app_exp : req.body.app_exp,
    vehicle_qty : req.body.vehicle_qty,
    drive_exp : req.body.drive_exp,
    payment_exp : req.body.payment_exp,
    overall : req.body.overall,
    user_id : req.user_id,
    comment : req.body.comment,
    
 };

 Order.product_review(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while adding product review"
     });
   else res.send(data);
 });

}; 

// product return 
exports.product_return = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // address
 var order = {
    return_type : req.body.return_type,
    return_title : req.body.return_title,
    review : req.body.review,
    order_number : "",
    order_details_id : req.body.order_details_id,
    product_id : req.body.product_id,
    user_id : req.user_id,
    prod_status : req.body.status
 };

 Order.product_return(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while return order"
     });
   else res.send(data);
 });

};  

// fetch return-order listing for a store manager (producer)
exports.producer_order_return = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // fetch from cart
 var order = {
    producerid : req.producer_id
 };

 Order.producer_order_return(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching return orders" 
     });
   else res.send(data);
 });
};

exports.return_order_reasons = (req, res) => {
    
  // fetch urgent delivery charges
  Order.return_order_reasons(req, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching return order reasons."
      });
    else res.send(data);
  });
};

//track order
exports.track_order = (req, res) => {

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
   
   // address
   var order = {
      order_details_id : req.body.order_details_id
   };
  
   Order.track_order(order, (err, data) => {
     if (err)
       res.status(500).send({
         message:
           err.message || "Some error occurred while return order"
       });
     else res.send(data);
   });
  
  };  

  
//update temp and location
exports.update_temp_loacation = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // temp and location
 var order = {
  device_id : req.body.device_id,
  latitude : req.body.latitude,
  longitude : req.body.longitude,
  temperature : req.body.temperature
 };

 Order.update_temp_loacation(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while updating temrature and location"
     });
   else res.send(data);
 });

};  


//send notification
exports.send_notification = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // temp and location
 var order = {
    
 };

 Order.send_notification(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while updating temrature and location"
     });
   else res.send(data);
 });

};  

//download invoice
exports.download_invoice = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // fetch from cart
 var order = {
  order_id : req.body.order_id
 };
 const errors = validationResult(req);
 if (!errors.isEmpty()) {
   return res.status(400).json({ errors: errors.array() });
 }
 Order.download_invoice(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching invoice" 
     });
   else res.send(data);
 });
};


// fetch temprature , lat, long
exports.fetch_temprature = (req, res) => {

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
 var order = {
  order_details_id : req.body.order_details_id
 };

 Order.fetch_temprature(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching temprature"
     });
   else res.send(data);
 });
};

// fetch available truck listing
exports.fetch_truck_listing = (req, res) => {

  // Validate request
//   if (!req.body) {
//    res.status(400).send({
//      message: "Content can not be empty!"
//    });
//  }
 
 // fetch from cart
 var order = {
  producerid : req.producer_id
 };

 Order.fetch_truck_listing(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching truck listing"
     });
   else res.send(data);
 });
};


// fetch order for deliver agent
exports.delivery_agent_orders = (req, res) => {
 
 // fetch from cart
 var order = {
    user_id : req.user_id
 };

 Order.delivery_agent_orders(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address" 
     });
   else res.send(data);
 });
};  

// fetch order details for Delivery Agent
exports.delivery_agent_orders_details = (req, res) => {

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
 

 var order = {
  order_details_id : req.body.order_details_id,
  user_id:req.user_id
 };

 Order.delivery_agent_orders_details(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
}; 

// fetch my customers
exports.my_customers = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 

 var customer = {
  user_id : req.user_id,
  page : (req.body.page && req.body.page > 0) ? req.body.page : 1,
  limit : 10
 };

 Order.my_customers(customer, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
}; 

exports.update_order_addresses = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 var customer = {};
 Order.update_order_addresses(customer, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
};

exports.cancellation_reasons = (req, res) => {
 
 var customer = {};
 Order.cancellation_reasons(customer, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
};

// Check product availbility on Order address update
exports.order_address_update = (req, res) => {

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
 

 var order = {
  address_id : req.body.address_id,
  user_id:req.user_id
 };

 Order.order_address_update(order, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching address"
     });
   else res.send(data);
 });
};

// fetch my order details
exports.my_order_collapse = (req, res) => {

 
  // fetch from cart
  var order = {
      userid : req.user_id,
      filter : req.body.filter,
      page : (req.body.page && req.body.page > 0) ? req.body.page : 1,
      limit : 10
  };
 
 Order.my_order_collapse(order, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching address"
      });
    else res.send(data);
  });
 };  
 
