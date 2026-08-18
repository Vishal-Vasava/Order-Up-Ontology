const Temperature = require('../models/temperature.model.js');
const { validationResult } = require('express-validator');
 // save inventory details
 exports.add_temperature = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
    status:400,
    msg: "Content can not be empty!"
   });
 }
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({status:400, errors: errors.array() });
    }
 
  
 // fetch from products
 var temperature = {
    device_id : req.query.dvid,
    latitude : req.query.lat,
    longitude : req.query.lng,
    temperature : req.query.temp,
 };

 Temperature.add_temperature(temperature, (err, data) => {
   
   if (err)
     res.status(500).send({
        status:500,
       msg:
         err.message || "Some error occurred while fetching products"
     });
   else res.send(data);
 });
};  

