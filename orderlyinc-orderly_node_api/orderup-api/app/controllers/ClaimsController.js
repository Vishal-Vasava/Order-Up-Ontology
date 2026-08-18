const Claims = require('../models/claims.model.js');

// fetch claims details
exports.fetch_claims_details = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // claims
 var claim = {
    producer_id : req.producer_id,
    claim_type : req.body.claim_type
 };

 Claims.fetch_claims_details(claim, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 });

};  

exports.claims_details = (req, res) => {

 // claims
 var claim = {
    producer_id : req.producer_id
 };

 Claims.claims_details(claim, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 });

};
