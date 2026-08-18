// Platform manager (admin portal) endpoints. Mounted after the global `auth` middleware
// in index.js, with requireAdmin gating every route here to user_type = 3.
// The public /admin/login route lives in login.routes.js since it must run before `auth`.
module.exports = (app, check) => {
    const admin = require("../controllers/AdminController.js");
    const requireAdmin = require('../middleware/requireAdmin.js');

    // platform-wide dashboard counts
    app.get("/admin/dashboard", requireAdmin, admin.dashboard_stats);

    // stores (producers)
    app.get("/admin/producers", requireAdmin, admin.list_producers);

    app.post("/admin/create_producer", requireAdmin,
        check('producer_name').notEmpty(),
        check('manager_first_name').notEmpty(),
        check('manager_mobile').notEmpty(),
        admin.create_producer
    );

    app.post("/admin/update_producer", requireAdmin,
        check('producer_id').notEmpty(),
        check('producer_name').notEmpty(),
        admin.update_producer
    );

    app.post("/admin/update_producer_status", requireAdmin,
        check('producer_id').notEmpty(),
        check('status').isIn(['0', '1', 0, 1]),
        admin.update_producer_status
    );

    // delivery agents
    app.get("/admin/delivery_agents", requireAdmin, admin.list_delivery_agents);

    app.post("/admin/create_delivery_agent", requireAdmin,
        check('first_name').notEmpty(),
        check('mobile').notEmpty(),
        admin.create_delivery_agent
    );

    app.post("/admin/update_delivery_agent", requireAdmin,
        check('user_id').notEmpty(),
        check('first_name').notEmpty(),
        admin.update_delivery_agent
    );

    app.post("/admin/update_delivery_agent_status", requireAdmin,
        check('user_id').notEmpty(),
        check('status').isIn(['0', '1', 0, 1]),
        admin.update_delivery_agent_status
    );

    // products and inventory
    app.get("/admin/products", requireAdmin, admin.list_products);

    app.post("/admin/create_product", requireAdmin,
        check('producer_id').notEmpty(),
        check('product_name').notEmpty(),
        check('rate_per_hour').isNumeric(),
        check('product_qty').isInt({ min: 0 }),
        admin.create_product
    );

    app.post("/admin/update_product", requireAdmin,
        check('product_id').notEmpty(),
        check('product_name').notEmpty(),
        check('rate_per_hour').isNumeric(),
        check('product_qty').isInt({ min: 0 }),
        admin.update_product
    );

    app.post("/admin/update_product_status", requireAdmin,
        check('product_id').notEmpty(),
        check('display_status').isIn(['0', '1', 0, 1]),
        admin.update_product_status
    );

    // customers
    app.get("/admin/customers", requireAdmin, admin.list_customers);

    // orders across every store, optionally ?status=
    app.get("/admin/orders", requireAdmin, admin.list_orders);
};
