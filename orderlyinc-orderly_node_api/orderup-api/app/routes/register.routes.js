module.exports = (app,check) => {
    const users = require("../controllers/RegisterController.js");

    const normalizeCustomerRegistration = (req, res, next) => {
        req.body.user_email = req.body.user_email || req.body.email;
        req.body.mobile = req.body.mobile || req.body.phone;
        req.body.gender = req.body.gender || 'unspecified';
        req.body.user_type = 0;
        req.body.device = req.body.device || req.body.device_id || 'web';
        next();
    };
  
    // Create a new user
    app.post("/register", 
        check('fb_id').notEmpty(),
        check('first_name').notEmpty(),
        check('last_name').notEmpty(),
        check('user_email').isEmail(),
        check('gender').notEmpty(),
        check('version').notEmpty(),
        check('signup_type').notEmpty(),
        // check('device_id').notEmpty(),
        check('fcm_id').notEmpty(),
        check('mobile').notEmpty(),
        check('device').notEmpty(),
        check('latitude').notEmpty(),
        check('longitude').notEmpty(),
        check('user_type').notEmpty(),
        check('address').notEmpty(),
        check('zip_code').notEmpty(),
        users.create
    );

    // Flutter customer app compatibility route. The current client uses
    // email/phone and does not expose legacy gender/user_type fields.
    app.post("/customer/register",
        normalizeCustomerRegistration,
        check('fb_id').notEmpty(),
        check('first_name').notEmpty(),
        check('last_name').notEmpty(),
        check('user_email').isEmail(),
        check('version').notEmpty(),
        check('signup_type').notEmpty(),
        check('fcm_id').notEmpty(),
        check('mobile').notEmpty(),
        check('device').notEmpty(),
        check('latitude').notEmpty(),
        check('longitude').notEmpty(),
        check('address').notEmpty(),
        check('zip_code').notEmpty(),
        users.create
    );
    
};
  
