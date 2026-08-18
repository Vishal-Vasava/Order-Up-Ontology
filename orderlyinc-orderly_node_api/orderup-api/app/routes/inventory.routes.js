module.exports = (app,check) => {
    const inventory = require("../controllers/InventoryController.js");
  
    // fetch inventory details
    app.get("/view_inventory", inventory.view_inventory);

    // New Flutter client compatibility route.
    app.post("/store/inventory/view", inventory.view_inventory_modern);
    app.post("/store/inventory/generate-image", inventory.generate_product_image);

    // remove inventory details
    app.post("/remove_inventory", inventory.remove_inventory);

    // save inventory details
    app.post("/add_inventory", inventory.add_inventory);

    // update inventory details
    app.post("/update_inventory", inventory.update_inventory);

    // save inventory details
    app.post("/add_inventory_new", inventory.add_inventory_new);

    app.post("/sku_gallery", 

    check('search').notEmpty(),
    
    inventory.sku_gallery
    );
};
