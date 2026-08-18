module.exports = (app,check) => {
    const temperature = require("../controllers/TemperatureController.js");
  
    // save temperature details
    app.get("/add_temperature", 
    check('dvid').notEmpty(),
    check('lat').notEmpty(),
    check('lng').notEmpty(),
    check('temp').notEmpty(),
    temperature.add_temperature);

   
};