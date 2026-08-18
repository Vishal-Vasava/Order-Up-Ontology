module.exports = (app,check) => {
    const product = require("../controllers/ProductController.js");
    const inventory = require("../controllers/InventoryController.js");

    // The legacy database has no product-filter or banner entities yet.
    // Return the modern client's expected JSON envelope so an empty state is
    // rendered instead of an Express HTML 404 page.
    app.get("/store/filter/list", (req, res) => {
        res.send({ statusCode: 200, data: [] });
    });

    app.get("/customer/banners", (req, res) => {
        res.send({ statusCode: 200, data: [] });
    });

    app.post("/store/products", inventory.customer_products_modern);
  
    // Create a new user
    app.post("/product_list", 
        check('producer_id').notEmpty(),
        check('offset').notEmpty(),
        product.product_list,
    );
    
};
