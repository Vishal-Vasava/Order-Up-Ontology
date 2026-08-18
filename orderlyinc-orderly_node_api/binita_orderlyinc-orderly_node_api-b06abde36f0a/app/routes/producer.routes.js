module.exports = (app,check) => {
    const producer = require("../controllers/ProducerController.js");

    app.get("/store/context", producer.store_context);

    // Customer-app compatibility route for store/category discovery.
    app.post("/stores", producer.list_modern);
  
    // fetch producer list
    app.post("/producer", 
        check('cust_lat').notEmpty(),
        check('cust_long').notEmpty(),
        producer.list
    );
    
};
  
