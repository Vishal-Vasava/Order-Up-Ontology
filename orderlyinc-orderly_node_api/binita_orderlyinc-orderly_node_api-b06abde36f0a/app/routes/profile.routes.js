const auth = require('../middleware/auth.js');

module.exports = (app,check) => {
    const profile = require("../controllers/ProfileController.js");
  
    

    // update store manager (producer) profile details
    app.post("/update_producer_profile", profile.update_producer_profile);

    //Update profile pic
    app.post("/update_profile_image", profile.update_profile_image);

    // fetch faq list
    app.get("/faq_list", profile.faq_list);

    // app.use(auth);

    // User's notifications list
    app.get("/notifications",auth, profile.notifications);

    // Delete notification once read

    app.post("/notification/destroy",auth, profile.notification_destroy);

    // Remove account reasons
    app.get("/remove_account_reasons",auth, profile.remove_account_reasons);


    // Remove account reasons
    app.post("/remove_account",
        check('reason').notEmpty(), 
    profile.remove_account);


};