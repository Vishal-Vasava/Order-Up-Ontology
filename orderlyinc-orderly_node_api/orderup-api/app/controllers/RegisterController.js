const User = require('../models/register.model.js');
const { validationResult } = require('express-validator');

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
        first_name : req.body.first_name,
        last_name : req.body.last_name,
        email_id : req.body.user_email,
        gender : req.body.gender,
        version : req.body.version,
        signup_type : req.body.signup_type,
        device_id : req.body.device_id,
        fcm_id : req.body.fcm_id,
        mobile : req.body.mobile,
        device : req.body.device,
        latitude : req.body.latitude,
        longitude : req.body.longitude,
        user_type : req.body.user_type,
        address : req.body.address,
        zip_code : req.body.zip_code
    };
    //res.send(user);
  
    // Save Customer in the database
    User.create(user, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the Customer."
        });
      else res.send(data);
    });
};

