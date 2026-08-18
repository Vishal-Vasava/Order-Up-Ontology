const Profile = require('../models/profile.model.js');
const { validationResult } = require('express-validator');
const upload = require("../services/ImageUpload");
const singleUpload = upload.single("image");
// const jwt = require('jsonwebtoken');
// const consts = require("../utils/constants.js");

// update store manager (producer) profile
exports.update_producer_profile = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
  
 // fetch from products
 var profile = {
    fb_id : req.body.fb_id,
    first_name : req.body.first_name,
    last_name : req.body.last_name,
    email_id : req.body.email_id,
    mobile : req.body.mobile,
    zip_code : req.body.zip_code,
    address : req.body.address
 };
 
 Profile.update_producer_profile(profile, (err, data) => {
   
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching products"
     });
   else res.send(data);
 });
};  

// update inventory details
exports.update_profile_image = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }

 //Upload s3
try{
  
 req.upload_type = 'profile';
  singleUpload(req, res, function (err) {
 //   console.log(res);
   if (err) {
     return res.status(400).json({
       success: false,
       errors: {
         title: "Image Upload Error",
         detail: err.message,
         error: err,
       },
     });
   }
   else {
     if(req.file) {
       var file_path = req.file.key;
       file_path = file_path.replace('profile/', '')
        var profile = {
          user_id : req.user_id,
          profile_pic : file_path,
       };
       
       Profile.update_profile_image(profile, (err, data) => {
         
         if (err)
           res.status(500).send({
             message:
               err.message || "Some error occurred while fetching products"
           });
         else res.send(data);
       });
 

     }
     else {
       return res.status(400).json({
         success: false,
         errors: {
           title: "Image Upload Error",
           detail: 'Please provide image',
           // error: err,
         },
       });
     }

   }
 });
} catch(ex) {
 return res.status(400).json({
   success: false,
   errors: {
     title: "Image Upload Error",
     detail: "File not uplaoded",
     error: ex,
   },
 });
}

};

exports.faq_list = (req, res) => {
    
  // Save Customer in the database
  Profile.faq_list(req, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching faq list"
      });
    else res.send(data);
  });
};

exports.notifications = (req, res) => {
    try {
     
      Profile.notifications(req.user_id, (err, data) => {
        if (err) {
          res.status(500).send({
            message:
              err.message || "Some error occurred while fetching faq list"
          });
        }
        else res.send(data);
      });
    } catch (error) {
      return res.status(422).json({
        message: error.message,
      });
    }
};

exports.notification_destroy = (req, res) => {
  try {
    if (!req.body.notification_id) {
      res.status(400).send({
        message: "Please provide Notification Id : notification_id"
      });
    }
    Profile.notification_destroy(req, (err, data) => {
      if (err) {
        res.status(500).send({
          message:
            err.message || "Please try again"
        });
      }
      else res.send(data);
    });
  } catch (error) {
    return res.status(422).json({
      message: error.message,
    });
  }
};

exports.remove_account_reasons = (req, res) => {
    
  // Save Customer in the database
  Profile.remove_account_reasons(req, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching faq list"
      });
    else res.send(data);
  });
};

exports.remove_account = (req, res) => {

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
      user_id : req.user_id,
      fcm_id : req.fcm_id,
      reason : req.body.reason
    };
    
    
  // Save Customer in the database
  Profile.remove_account(user, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while fetching faq list"
      });
    else res.send(data);
  });
};