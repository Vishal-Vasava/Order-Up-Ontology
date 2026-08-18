module.exports = app => {
    const claims = require("../controllers/ClaimsController.js");
  
    //fetch claims
    app.post("/fetch_claims_details", claims.fetch_claims_details);
    app.get("/claims_details", claims.claims_details);
    
};