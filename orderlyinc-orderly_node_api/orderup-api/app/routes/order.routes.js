module.exports = (app,check) => {
    const order = require("../controllers/OrderController.js");
  
    // add address
    app.post("/add_address", 
    
        check('user_name').notEmpty(),
        check('mobile').notEmpty(),
        check('email_id').notEmpty(),
        check('address').notEmpty(),
        check('zipcode').notEmpty(),
        check('city').notEmpty(),
        check('state').notEmpty(),
        check('country').notEmpty(),
        check('add_latitude').notEmpty(),
        check('add_longitude').notEmpty(),

        order.add_address
    );
    
    // fetch user address
    app.get("/view_address", order.view_address);

    // update address
    app.post("/update_address", 

        check('addressid').notEmpty(),
        check('user_name').notEmpty(),
        check('mobile').notEmpty(),
        check('email_id').notEmpty(),
        check('address').notEmpty(),
        check('zipcode').notEmpty(),
        check('city').notEmpty(),
        check('state').notEmpty(),
        check('country').notEmpty(),
        check('add_latitude').notEmpty(),
        check('add_longitude').notEmpty(),

        order.update_address
    );

    // delete address
    app.post("/delete_address", 

        check('address_id').notEmpty(),

        order.delete_address
    );

    // fetch urgent changes
    app.get("/urgent_charges", order.urgent_charges);

    // place order
    app.post("/place_order", 

        check("delivery_type").notEmpty(),
        check("delivery_date").notEmpty(),
        check("delivery_slot").notEmpty(),
        check("discount").notEmpty(),
        // check("src_address_id").notEmpty(),
        check("dest_address_id").notEmpty(),
        check("payment_mode").notEmpty(),
        // check("cart_array").notEmpty(),
        // check("payment_transaction_id").notEmpty(),
        // check("urgent_amount").notEmpty(),
        // check("sub_total").notEmpty(),
        // check("convinience_fee").notEmpty(),
        // check("grand_total").notEmpty(),

        order.place_order
    );

    // my order
    app.post("/my_order", order.my_order);

    // Customer-app compatibility route.
    app.post("/shopping/orders", order.my_orders_modern);
    
    // track order
    app.post("/track_order", 

        check('order_details_id').notEmpty(),
    
        order.track_order
    );

    // product review
    app.post("/product_review", 

        check('order_details_id').notEmpty(),
        check('product_id').notEmpty(),
        check('app_exp').notEmpty(),
        check('vehicle_qty').notEmpty(),
        check('drive_exp').notEmpty(),
        check('payment_exp').notEmpty(),
        check('overall').notEmpty(),
        check('comment').notEmpty(),
    
        order.product_review
    );
 
    // product return
    app.post("/product_return", 

        check('return_type').notEmpty(),
        check('return_title').notEmpty(),
        check('review').notEmpty(),
        check('order_details_id').notEmpty(),
        check('product_id').notEmpty(),
        check('status').notEmpty(),

        order.product_return
    );

   // order listing for store manager (producer)
   app.post("/producer_orders",

    check('status').notEmpty(),

    order.producer_orders
   );

   // Compatibility routes used by the newer Flutter store-manager client.
   app.post("/store/orders", order.store_orders_modern);
   app.get("/store/claims", order.store_claims_modern);
   app.post("/store/customers", order.store_customers_modern);

   // order details listing for store manager (producer)
   app.post("/producer_orders_details",

        check('order_id').notEmpty(),
        // check('status').notEmpty(),

        order.producer_orders_details

   );


   // store manager (producer) product return order list
   app.get("/producer_order_return", order.producer_order_return);
   
   // return order reasons
   app.get("/return_order_reasons", order.return_order_reasons);
    
    // update temprature and location
     app.post("/send_notification", order.send_notification);

     // download invoice
     app.post("/download_invoice", 

        check('order_id').notEmpty(),

        order.download_invoice);
        
    // fetch temprature, lat, long
    app.post("/fetch_temprature", 
        check('order_details_id').notEmpty(),
        order.fetch_temprature
    );
    
    // fetch truck listing
    app.get("/fetch_truck_listing", order.fetch_truck_listing);
    
    // update order status (no role check in the handler today - callable by any authenticated user)
    app.post("/update_order_status", order.update_order_status);
    // update temprature and location
    app.post("/update_temp_loacation", order.update_temp_loacation);

    // order listing for delivery agent
   app.get("/delivery_agent_orders", order.delivery_agent_orders);

    // order details listing for delivery agent
    app.post("/delivery_agent_orders_details",

    check('order_details_id').notEmpty(),

    order.delivery_agent_orders_details

    );

    // fetch my customers
    app.post("/my_customers", order.my_customers);

    app.get("/update_order_addresses", order.update_order_addresses);

    //List of cancellation reasons
    app.get("/cancellation_reasons", order.cancellation_reasons);


    // update the delivery address on an order
    app.post("/order_address_update",

    check('address_id').notEmpty(),

    order.order_address_update

    );

    //Customer order List with collapse
    app.post("/my_order_collapse", order.my_order_collapse);

};
