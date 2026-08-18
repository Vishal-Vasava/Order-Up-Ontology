const sql = require("../utils/dbConnection.js");
const consts = require("../utils/constants.js");

// constructor
const Profile = function(profile) {
    this.fb_id = profile.fb_id;
  };

Profile.update_producer_profile = (profile, result) => {
    var fb_id = profile.fb_id;
    var first_name = profile.first_name;
    var last_name = profile.last_name;
    var email_id = profile.email_id;
    var mobile = profile.mobile;
    var zip_code = profile.zip_code;
    var address = profile.address;

    sql.query("Update users_tb SET first_name = '"+first_name+"', last_name = '"+last_name+"', email_id = '"+email_id+"', zip_code = '"+zip_code+"', address = '"+address+"', mobile = '"+mobile+"' Where fb_id = '"+fb_id+"'", (err, res) => {
        if (err) throw err;
        
    });

    sql.query('select * from users_tb where fb_id = ?',[fb_id],(err,rows,fields)=>{
      var is_reg = 'true';
      var product_image_base = consts.S3_URL+'/profile/';
      var profile_pic = rows[0].profile_pic;
      if(rows[0].profile_pic) {
        profile_pic = product_image_base + profile_pic;
      }
      var resultdata = {
        fb_id: `${rows[0].fb_id}`,
        first_name: `${rows[0].first_name}`,
        last_name: `${rows[0].last_name}`,
        email_id: `${rows[0].email_id}`,
        mobile: `${rows[0].mobile}`,
        user_type: `${rows[0].user_type}`,
        zip_code: `${rows[0].zip_code}`,
        address: `${rows[0].address}`,
        signup_type: `${rows[0].signup_type}`,
        is_registered: is_reg,
        profile_pic : profile_pic
      };
      result(null,{ status:200, user: resultdata, msg:'Success'}); 
    });
};

Profile.update_profile_image = (profile, result) => {
  var user_id = profile.user_id;
  var profile_pic = profile.profile_pic;

  sql.query("Update users_tb SET profile_pic='"+profile_pic+"' WHERE user_id='"+user_id+"'", (err, res) => {
      if (err) throw err;
      
  });

  sql.query("select * from users_tb where user_id='"+user_id+"'",[user_id],(err,rows,fields)=>{
    var is_reg = 'true';
    var product_image_base = consts.S3_URL+'/profile/';
    var profile_pic = rows[0].profile_pic;
    if(rows[0].profile_pic) {
      profile_pic = product_image_base + profile_pic;
    }
    var resultdata = {
      fb_id: `${rows[0].fb_id}`,
      first_name: `${rows[0].first_name}`,
      last_name: `${rows[0].last_name}`,
      email_id: `${rows[0].email_id}`,
      mobile: `${rows[0].mobile}`,
      user_type: `${rows[0].user_type}`,
      zip_code: `${rows[0].zip_code}`,
      address: `${rows[0].address}`,
      signup_type: `${rows[0].signup_type}`,
      is_registered: is_reg,
      profile_pic : profile_pic
    };
    result(null,{ status:200, user: resultdata, msg:'Success'}); 
  });
};

Profile.faq_list = (req, result) => {

    sql.query('select faq_id, question, answer from faq_tb order by faq_id',(err,rows)=>{
      if (err) throw err;
        if (rows.length > 0) {
          
          result(null,{ status:200, faq: rows, msg:'Success'}); 
        }else{
           
            var resultdata = {
             
            };  
            result(null,{ status:200, faq: resultdata, msg:'Fail'}); 
        }
    })
  };

  Profile.notifications = (user_id, result) => {
    var s3_url = consts.S3_URL;
    sql.query('SELECT notifications.id,notifications.title,notifications.description,CONCAT("'+s3_url+'","/notifications/",notifications.banner) as banner_url,notifications.api_url,notifications.api_data FROM notifications WHERE notifications.id IN (SELECT notification_id FROM notifications_users WHERE user_id='+user_id+') ORDER BY notifications.id DESC',(err,rows)=>{
      if (err) throw err;
        if (rows.length > 0) {
          for (let i = 0; i < rows.length; i++) {
            var record_noti = rows[i];
            if(record_noti.api_data)
            {
              try {
                rows[i].api_data = JSON.parse(rows[i].api_data);
              } catch (e) {
                rows[i].api_url = null;
                rows[i].api_data = null;
              }
            }
            
          }
          result(null,{ status:200, notification: rows, msg:'Success'}); 
        }else{
           
            var resultdata = {
             
            };  
            result(null,{ status:200, notification: resultdata, msg:'No notification found'}); 
        }
    })
  };

  Profile.notification_destroy = (req, result) => {

    sql.query('DELETE FROM notifications_users WHERE user_id = '+req.user_id+' AND notification_id = '+req.body.notification_id,(err,rows)=>{
      if (err) throw err;
      result(null,{ status:200,  msg:'Success'}); 
      
    })
  };


  Profile.remove_account_reasons = (req, result) => {
    var reasons = [
      'I am not using this account anymore',
      'Account concerns / Unauthorised activity',
      'Privacy concers',
    ]
    result(null,{ status:200, reasons, msg:'Success'}); 
  };

  Profile.remove_account = (user, result) => {

    sql.query('Update users_tb set status = 1,fcm_id = "",remove_account_reason = "'+user.reason+'" WHERE user_id="'+user.user_id+'"',(err,rows)=>{
      if (err) throw err;
      result(null,{ status:200,  msg:'Success'}); 
      
    })
  };

module.exports = Profile;