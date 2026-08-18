module.exports = (app,check) => {
    const cart = require("../controllers/CartController.js");
  
    // add to cart
    app.post("/add_to_cart",
        
        check('product_id').notEmpty(),
        check('qty').notEmpty(),

        cart.add_to_cart
    );

    app.post("/shopping/cart/add",
        check('product_id').notEmpty(),
        check('qty').notEmpty(),
        cart.add_to_cart_modern
    );

    app.post("/shopping/cart", cart.view_cart_modern);

    // add to cart
    app.post("/update_cart",
        
        check('cart_id').notEmpty(),
        check('qty').notEmpty(),

        cart.update_cart
    );
    
    // fetch cart details
    app.get("/view_cart", 
        cart.view_cart
    );

    // fetch cart details
    app.post("/view_cart", 
        check('cust_lat').notEmpty(),
        check('cust_long').notEmpty(),
        
        cart.view_cart
    );

    // delete cart details
    app.post("/delete_cart", 

        check('cart_id').notEmpty(),

        cart.delete_cart
    );
};
