const User = require('../models/login.model.js');
const { validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
// const { response } = require('express');
const consts = require("../utils/constants.js");

// Create and Save a new Customer
exports.create = (req, res) => {
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
    var user = {
        fb_id : req.body.fb_id,
        device_id : req.body.device_id ? req.body.device_id : '',
        fcm_id : req.body.fcm_id,
        is_guest : req.body.is_guest ? true : false,
        version : req.body.version ? req.body.version : '',
        device : req.body.device ? req.body.device : '',
        latitude : req.body.latitude ? req.body.latitude : '',
        longitude : req.body.longitude ? req.body.longitude : '',
        old_token : req.body.old_token ? req.body.old_token : '',
    };
    //res.send(user);
  
    // Save Customer in the database
    User.create(user, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while Login."
        });
      else res.send(data);
    });
};


// Log in a store manager (producer) account
exports.producer_login = (req, res) => {
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
  var user = {
      fb_id : req.body.fb_id,
      mobile : req.body.mobile,
      device_id : req.body.device_id,
      fcm_id : req.body.fcm_id
  };
  //res.send(user);

  // Save Customer in the database
  User.producer_login(user, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while Login"
      });
    else res.send(data);
  });
};


// Create and Save a new Customer
exports.delivery_login = (req, res) => {
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
  
  // Login Delivery Manager
  var user = {
      fb_id : req.body.fb_id,
      mobile : req.body.mobile,
      device_id : req.body.device_id ? req.body.device_id : '',
      fcm_id : req.body.fcm_id
  };
  User.delivery_login(user, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while Login."
      });
    else res.send(data);
  });
};

// Log in a platform manager (admin portal) account
exports.admin_login = (req, res) => {
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

  var user = {
      email_id : req.body.email,
      password : req.body.password
  };

  User.admin_login(user, (err, data) => {
    if (err) {
      res.status(401).send({
        message:
          err.message || "Invalid email or password"
      });
    } else {
      res.send(data);
    }
  });
};

// logout customer
exports.logout = (req, res) => {
  
 
  var user = {
    user_id : req.user_id,
    fcm_id : req.fcm_id,
  };
  //res.send(user);

  
  User.logout(user, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching the Customer."
      });
    else res.send(data);
  });
};
// logout customer
exports.logout_post = (req, res) => {
  // Validate request
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  
 
  var user = {
      fb_id : req.body.fb_id
  };
  //res.send(user);

  
  User.logout_post(user, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching the Customer."
      });
    else res.send(data);
  });
};
exports.check_user = (req,res) => {
  // var user = {};
  if(!req.headers.authorization ||
    !req.headers.authorization.startsWith('Bearer') ||
    !req.headers.authorization.split(' ')[1]
    )
    {
      return res.status(422).json({
      message: "Please provide the token",
    });
    }
    try {
      const theToken = req.headers.authorization.split(' ')[1];
      
      const decoded = jwt.verify(theToken, consts.ACCESS_TOKEN.secret);
      var user = {
          user_id : decoded.id
      };
      User.check_user(user, (err, data) => {
        if (err)
          res.status(500).send({
            message:
              err.message || "Some error occurred while fetching the Customer."
          });
        else res.send(data);
      });
    } catch (error) {
      return res.status(422).json({
        message: error.message,
      });
    }

};

exports.refresh_token =  (req,res) => {
  if(!req.headers.authorization || !req.headers.authorization.startsWith('Bearer') || !req.headers.authorization.split(' ')[1])
  {
      return res.status(422).json({
      message: "Please provide the token",
    });
  }
  try {
    const theToken = req.headers.authorization.split(' ')[1];
    const decoded_token = jwt.verify(theToken, consts.REFRESH_TOKEN.secret);
    var user_id = decoded_token.id;
    var token_data = {
      id:user_id
    }

    if(decoded_token.fcm_id) {
      token_data.fcm_id = decoded_token.fcm_id;
    }

    if(decoded_token.type && decoded_token.type == '1' && decoded_token.producer_id && decoded_token.producer_id > 0) {
      token_data.type = '1';
      token_data.producer_id = decoded_token.producer_id;

      // var access_token = jwt.sign({id:user_id,type:'1',producer_id:decoded_token.producer_id},consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
      // var refresh_token = jwt.sign({id:user_id,type:'1',producer_id:decoded_token.producer_id},consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });
    }
    else if(decoded_token.type) {
      token_data.type = decoded_token.type;
    }
    var access_token = jwt.sign(token_data,consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
    var refresh_token = jwt.sign(token_data,consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });
    
    return res.status(200).json({msg:'Success',access_token: access_token,refresh_token:refresh_token});
  } catch (error) {
    return res.status(419).json({
      message: error.message,
    });
  }
  
  
};