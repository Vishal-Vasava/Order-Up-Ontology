const sql = require("../utils/dbConnection.js");

// constructor
const User = function(user) {
    this.fb_id = user.fb_id;
    this.first_name = user.first_name;
    this.last_name = user.last_name;
    this.email_id = user.email_id || user.user_email;
    this.gender = user.gender;
    this.version = user.version;
    this.signup_type = user.signup_type;
    this.device_id = user.device_id;
    this.fcm_id = user.fcm_id;
    this.mobile = user.mobile;
    this.device = user.device;
    this.latitude = user.latitude;
    this.longitude = user.longitude;
    this.user_type = user.user_type;
    this.address = user.address;
    this.zip_code = user.zip_code;
  };

  User.create = (newUser, result) => {

    sql.query('select * from users_tb where status = 0 AND fb_id = ?',[newUser.fb_id],(err,rows,fields)=>{
      if (err) throw err;
        if (rows.length > 0) {
          // res.status(200).json(rows); 
          var is_reg = 'true';
          var resultdata = {
            fb_id: `${rows[0].fb_id}`,
            first_name: `${rows[0].first_name}`,
            last_name: `${rows[0].last_name}`,
            email_id: `${rows[0].email_id}`,
            mobile: `${rows[0].mobile}`,
            user_type: `${rows[0].user_type}`,
            address: `${rows[0].address}`,
            zip_code: `${rows[0].zip_code}`,
            signup_type: `${rows[0].signup_type}`,
            latitude: `${rows[0].latitude}`,
            longitude: `${rows[0].longitude}`,
              is_registered: is_reg
          };
          result(null,{ status:200, user: resultdata, msg:'Success'}); 
        }else{
           
                
            sql.query('INSERT INTO users_tb SET ?', newUser, (err, res) => {
            //function(err, result) {
                if (err) throw err;
                //res.send('Data Inserted'+result.insertId); 
                var last_insert_id = res.insertId;
                if(last_insert_id != ''){

                  var addressdata = {
                    userid: last_insert_id,
                    user_name: newUser.first_name+' '+newUser.last_name,
                    mobile: newUser.mobile,
                    email_id: newUser.email_id,
                    street_no:'',
                    flat_no:'',
                    address: newUser.address,
                    zipcode: newUser.zip_code,
                    city:'',
                    state:'',
                    country:'',
                    add_latitude: newUser.latitude,
                    add_longitude: newUser.longitude
                  };

                  sql.query('INSERT INTO user_address SET ?', addressdata, (err, res) => {
                    var is_reg = 'true';
                    var resultdata = {
                        fb_id: newUser.fb_id,
                        first_name: newUser.first_name,
                        last_name: newUser.last_name,
                        email_id: newUser.email_id,
                        mobile: newUser.mobile,
                        user_type: newUser.user_type,
                        address: newUser.address,
                        zip_code: newUser.zip_code,
                        signup_type: newUser.signup_type,
                        latitude: newUser.latitude,
                        longitude: newUser.longitude,
                        is_registered: is_reg,
                        is_default: 1
                    };
                    result(null,{ status:200, user: resultdata, msg:'Success'}); 
                  });

                  
                }else{
                  result(null,{ status:201, user: resultdata, msg:'Fail'}); 
                }
                
            });
        }
    })
  };

  module.exports = User;
