var {initializeApp,cert } = require("firebase-admin/app");
var { getMessaging } = require('firebase-admin/messaging');
var serviceAccount = require("../../orderlyproject-firebase-adminsdk-qoedt-b7531d21c2.json");

const sql = require("../utils/dbConnection.js");

// cert(serviceAccount);
const firebase_admin = initializeApp({
//   credential: firebase_admin.credential.cert(serviceAccount),
  credential: cert(serviceAccount),
//   databaseURL: "https://sample-project-e1a84.firebaseio.com"
})

senPushNotification = (notification_data) => {
    var registrationToken =  notification_data.user_token;
    var message_notification = {
            notification: {
                title: notification_data.title ? notification_data.title : 'Orderly',
                body: notification_data.body ? notification_data.body : 'New Notification',
            },
            data: {
              api_url: notification_data.api_url ? notification_data.api_url : '/',
              api_data: notification_data.api_data ? JSON.stringify(notification_data.api_data) : '{}',
            }
        };

        var notification_options = {
          priority: "high",
          timeToLive: 60 * 60 * 24
        };
    // Add in DB
    if(notification_data.user_id) {
        var notifications_record = {
            title : notification_data.title ? notification_data.title : 'Orderly',
            description : notification_data.body ? notification_data.body : 'New Notification',
            send_to_all : 0,
            api_url: notification_data.api_url ? notification_data.api_url : '/',
            api_data: notification_data.api_data ? JSON.stringify(notification_data.api_data) : '{}',
            // created_at : Date.now()
        }
    
        sql.query('INSERT INTO notifications SET ?', notifications_record, (err, res) => {
            if(err) {console.log(err)}
            var last_insert_id = res.insertId;
            if(last_insert_id) {
                var notifications_record_user = {
                    notification_id : last_insert_id,
                    user_id : notification_data.user_id,
                    // created_at : Date.now()
                }
                sql.query('INSERT INTO notifications_users SET ?', notifications_record_user, (err, res) => {
                    if(err) {console.log(err)}
                });
            }
    
        });
    }

    getMessaging().sendToDevice(registrationToken, message_notification, notification_options)
      .then( response => {
            return 1;
        //   result(null,{ status:200,  msg:'Successed'});   
      })
      .catch( error => {
        console.log(error);
        return 0;
        //   result(null,{ status:500,  msg:'Fail'});   
      });
};

// module.exports.firebase_admin = firebase_admin
module.exports.getMessaging = getMessaging;
module.exports.senPushNotification = senPushNotification;