module.exports = (app,check) => {
    const users = require("../controllers/LoginController.js");
    const auth = require('../middleware/auth.js');
    
    // Customer Login
    app.post("/login" , 
        check('fb_id').notEmpty(),
        // check('device_id').notEmpty(),
        check('fcm_id').notEmpty(),
        users.create
    );
    // New Flutter client compatibility alias for the legacy customer login.
    app.post("/customer/login",
        check('fb_id').notEmpty(),
        check('fcm_id').notEmpty(),
        users.create
    );
    app.get("/check-user", users.check_user);
    app.get("/refresh_token",
        users.refresh_token
    );
    // Flutter persona-specific compatibility aliases.
    app.get("/customer/refresh-token", users.refresh_token);
    app.get("/store/refresh-token", users.refresh_token);
    app.get("/agent/refresh-token", users.refresh_token);

     // Store Manager (Producer) Login
     app.post("/producer_login",
        check('fb_id').notEmpty(),
        check('mobile').notEmpty(),
        // check('device_id').notEmpty(),
        check('fcm_id').notEmpty(),
        users.producer_login
     );

     // Delivery Agent Login
    app.post("/delivery_login" ,
        check('fb_id').notEmpty(),
        check('mobile').notEmpty(),
        // check('device_id').notEmpty(),
        check('fcm_id').notEmpty(),
        users.delivery_login
    );

    // Platform Manager Login (admin portal)
    app.post("/admin/login",
        check('email').isEmail(),
        check('password').notEmpty(),
        users.admin_login
    );

    // fetch privacy policy details
    app.get('/privacy_policy',function(req,res) {
        // res.sendFile('privacy_policy.html', { root: __dirname });
        res.send({status:200,'url':'https://order-up.in/privacy.html'});
    });

   // fetch privacy policy details
    app.get('/terms_condition',function(req,res) {
        // res.sendFile('terms_condition.html', { root: __dirname });
        res.send({status:200,'url':'https://order-up.in/terms.html'});
    });

     // Customer Logout
    app.post("/logout", users.logout_post);
    app.get("/logout", auth,users.logout);

    
    
};
  
