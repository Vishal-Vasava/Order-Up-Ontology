const sql = require("../utils/dbConnection.js");
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const consts = require("../utils/constants.js");

// constructor
const User = function(user) {
    this.fb_id = user.fb_id;
  };

  User.create = (newUser, result) => {
    var fb_id = newUser.fb_id;
    var device_id = newUser.device_id;
    var fcm_id = newUser.fcm_id;
    var is_guest = newUser.is_guest;
    var old_token = newUser.old_token;

    sql.query("Update users_tb SET device_id = '"+device_id+"', fcm_id = '"+fcm_id+"' Where status = 0 AND fb_id = '"+fb_id+"'", (err, res) => {
                
    });

    sql.query('select * from users_tb where status = 0 AND user_type = 0 AND fb_id = ?',[newUser.fb_id],(err,rows,fields)=>{
      if (err) throw err;
        if (rows.length > 0) {
          const access_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id},consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
          const refresh_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id},consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });
          // res.status(200).json(rows); 
          var user_id = rows[0].user_id;
          var product_image_base = consts.S3_URL+'/profile/';
          var profile_pic = rows[0].profile_pic;
          if(rows[0].profile_pic) {
            profile_pic = product_image_base + profile_pic;
          }
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
              is_registered: is_reg,
              profile_pic : profile_pic,
              access_token: access_token,
              refresh_token:refresh_token
          };
          if(old_token) {
            try {
              var decoded_token = jwt.verify(old_token, consts.ACCESS_TOKEN.secret);
              var check_id =decoded_token.id;
              if(check_id && check_id != user_id) {
                //Update Cart
                var add_query = 'UPDATE cart_tb SET user_id = "'+user_id+'" WHERE user_id = "'+check_id+'" AND product_id NOT IN (SELECT product_id FROM (SELECT * FROM cart_tb) AS ct_guest WHERE user_id = "'+user_id+'");';
                var update_query = 'UPDATE cart_tb ct_main JOIN cart_tb ct_guest ON ct_main.product_id = ct_guest.product_id AND ct_main.user_id != ct_guest.user_id AND ct_guest.user_id = "'+check_id+'" SET ct_main.qty = (ct_main.qty + ct_guest.qty) WHERE ct_main.user_id = "'+user_id+'" ;';
                var delete_query = 'DELETE FROM cart_tb WHERE user_id = "'+check_id+'"';

                
                sql.query(add_query,(err_add_query,res_add_query)=>{
                  sql.query(update_query,(err_update_query,res_update_query)=>{
                    sql.query(delete_query,(err_delete_query,res_delete_query)=>{});
                  });

                });
              }
            } catch (error) {
              
            }
          }
          result(null,{ status:200, user: resultdata, msg:'Success'}); 
        } else if(is_guest) {
            //Insert in DB
            var new_user = {
              fb_id : fb_id,
              first_name : '',
              last_name : '',
              email_id : '',
              gender : '',
              version : newUser.version,
              signup_type : 'Guest',
              device_id : device_id,
              fcm_id : fcm_id,
              mobile : '',
              device : newUser.device,
              latitude : newUser.latitude,
              longitude : newUser.longitude,
              user_type : 0,
              address : '',
              zip_code : ''
          };

          sql.query('INSERT INTO users_tb SET ?', new_user, (err_ins, res_ins) => {
            //function(err, result) {
                if (err_ins) throw err_ins;
                //res.send('Data Inserted'+result.insertId); 
                var last_insert_id = res_ins.insertId;
                sql.query('select * from users_tb where user_id= ?',[last_insert_id],(err,rows,fields)=>{
                  if (err) throw err;
                    if (rows.length > 0) {
                      const access_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id},consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
                      const refresh_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id},consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });
                      // res.status(200).json(rows); 
                      var product_image_base = consts.S3_URL+'/profile/';
                      var profile_pic = rows[0].profile_pic;
                      if(rows[0].profile_pic) {
                        profile_pic = product_image_base + profile_pic;
                      }
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
                          is_registered: is_reg,
                          profile_pic : profile_pic,
                          access_token: access_token,
                          refresh_token:refresh_token
                      };
                      result(null,{ status:200, user: resultdata, msg:'Success'}); 
                    }
                  });
          });


        } else{
           
            var is_reg = 'false';
            var resultdata = {
              fb_id: newUser.fb_id,
              is_registered: is_reg
            };  
            result(null,{ status:200, user: resultdata, msg:'Fail'}); 
        }
    })
  };

  
  User.producer_login = (newUser, result) => {

    sql.query('select * from users_tb where status = 0 AND user_type = 1 AND mobile = ?',[newUser.mobile],(err,rows,fields)=>{
      if (err) throw err;
        if (rows.length > 0) {
          // res.status(200).json(rows); 
          var fb_id = newUser.fb_id;
          var mobile = newUser.mobile;
          var device_id = newUser.device_id;
          var fcm_id = newUser.fcm_id;
          sql.query("Update users_tb SET fb_id = '"+fb_id+"', device_id = '"+device_id+"', fcm_id = '"+fcm_id+"' Where status = 0 AND  mobile = '"+mobile+"'", (err, res) => {
                
          });

          const access_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id,type:'1',producer_id:rows[0].producerid},consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
          const refresh_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id,type:'1',producer_id:rows[0].producerid},consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });

          var product_image_base = consts.S3_URL+'/profile/';
          var profile_pic = rows[0].profile_pic;
          if(rows[0].profile_pic) {
            profile_pic = product_image_base + profile_pic;
          }
          var is_reg = 'true';
          var resultdata = {
            fb_id: fb_id,
            first_name: `${rows[0].first_name}`,
            last_name: `${rows[0].last_name}`,
            email_id: `${rows[0].email_id}`,
            mobile: `${rows[0].mobile}`,
            user_type: `${rows[0].user_type}`,
            address: `${rows[0].address}`,
            zip_code: `${rows[0].zip_code}`,
            producerid: `${rows[0].producerid}`, 
            signup_type: `${rows[0].signup_type}`,
            latitude: `${rows[0].latitude}`,
            longitude: `${rows[0].longitude}`,
              is_registered: is_reg,
              profile_pic : profile_pic,
              access_token: access_token,
              refresh_token:refresh_token
          };
          result(null,{ status:200, user: resultdata, msg:'Success'}); 
        }else{
           
            var is_reg = 'false';
            var resultdata = {
              fb_id: newUser.fb_id,
              is_registered: is_reg
            };  
            result(null,{ status:200, user: resultdata, msg:'Fail'}); 
        }
    })
  };

  User.delivery_login = (newUser, result) => {

    sql.query('select * from users_tb where status = 0 AND user_type = 2 AND mobile = ?',[newUser.mobile],(err,rows,fields)=>{
      if (err) throw err;
        if (rows.length > 0) {
          // res.status(200).json(rows); 
          var fb_id = newUser.fb_id;
          var mobile = newUser.mobile;
          var device_id = newUser.device_id;
          var fcm_id = newUser.fcm_id;
          sql.query("Update users_tb SET fb_id = '"+fb_id+"', device_id = '"+device_id+"', fcm_id = '"+fcm_id+"' Where status = 0 AND mobile = '"+mobile+"'", (err, res) => {
                
          });

          const access_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id,type:'2'},consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
          const refresh_token = jwt.sign({id:rows[0].user_id,fcm_id:rows[0].fcm_id,type:'2'},consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });

          var product_image_base = consts.S3_URL+'/profile/';
          var profile_pic = rows[0].profile_pic;
          if(rows[0].profile_pic) {
            profile_pic = product_image_base + profile_pic;
          }
          var is_reg = 'true';
          var resultdata = {
            fb_id: fb_id,
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
            is_registered: is_reg,
            profile_pic : profile_pic,
            access_token: access_token,
            refresh_token:refresh_token
          };
          result(null,{ status:200, user: resultdata, msg:'Success'}); 
        }else{

          sql.query('select * from users_tb where mobile = ?',[newUser.mobile],(err1,rows1,fields)=>{
            if (err1) throw err1;
            if (rows1.length > 0) {
              var is_reg = 'false';
              var resultdata = {
                fb_id: newUser.fb_id,
                is_registered: is_reg
              };  
              result(null,{ status:200, user: resultdata, msg:'User is not registered as delivery manager'}); 
            } else {

              var is_reg = 'false';
              var resultdata = {
                fb_id: newUser.fb_id,
                is_registered: is_reg
              };  
              result(null,{ status:200, user: resultdata, msg:'Fail'}); 
            }
          });
           
        }
    })
  };

  User.admin_login = (newUser, result) => {

    var email_id = newUser.email_id;
    var password = newUser.password;

    sql.query('select * from users_tb where status = 0 AND user_type = 3 AND email_id = ?',[email_id],(err,rows,fields)=>{
      if (err) throw err;
      if (rows.length > 0 && rows[0].password) {
        bcrypt.compare(password, rows[0].password, (bcrypt_err, is_match) => {
          if (bcrypt_err || !is_match) {
            result({ message: 'Invalid email or password' }, null);
            return;
          }

          const access_token = jwt.sign({id:rows[0].user_id,type:'3'},consts.ACCESS_TOKEN.secret,{ expiresIn: consts.ACCESS_TOKEN.expiresIn });
          const refresh_token = jwt.sign({id:rows[0].user_id,type:'3'},consts.REFRESH_TOKEN.secret,{ expiresIn: consts.REFRESH_TOKEN.expiresIn });

          var resultdata = {
            user_id: rows[0].user_id,
            first_name: `${rows[0].first_name}`,
            last_name: `${rows[0].last_name}`,
            email_id: `${rows[0].email_id}`,
            user_type: `${rows[0].user_type}`,
          };

          // Nested under data.data to match the admin portal's existing Login.js contract
          // (response.data.data.data.user / .tokens.access_token).
          result(null, {
            data: {
              data: {
                user: resultdata,
                tokens: {
                  access_token: access_token,
                  refresh_token: refresh_token
                }
              }
            }
          });
        });
      } else {
        result({ message: 'Invalid email or password' }, null);
      }
    })
  };

  User.logout = (newUser, result) => {

    var user_id = newUser.user_id;
    var fcm_id = newUser.fcm_id;

    sql.query("Update users_tb SET fcm_id = '' Where user_id = '"+user_id+"' AND fcm_id='"+fcm_id+"'", (err, res) => {
      var resultdata = { };
      result(null,{ status:200, user: resultdata, msg:'Success'}); 
                
    });

    
};

User.logout_post = (newUser, result) => {

  var fb_id = newUser.fb_id;

  sql.query("delete from cart_tb WHERE user_id = '"+fb_id+"' ",(err,rows,fields)=>{
      if (err) throw err;
      if (rows.length > 0) {
          result(null,{ status:200, user: rows, msg:'Success'}); 
      }else{
          var resultdata = { };
          result(null,{ status:200, user: resultdata, msg:'Success'}); 
      }
  })
};
User.check_user = (newUser,result) => {
  sql.query('select * from users_tb where status = 0 AND user_id = ?',[newUser.user_id],(err,rows,fields)=>{
    if (err) throw err;
      if (rows.length > 0) {
        // res.status(200).json(rows); 
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
          is_registered: is_reg,
        };

        result(null,{ status:200, user: resultdata, msg:'Success'}); 
      }else{
         
          var is_reg = 'false';
          var resultdata = {
            fb_id: newUser.fb_id,
            is_registered: is_reg
          };  
          result(null,{ status:200, user: resultdata, msg:'Fail'}); 
      }
  })
};
  module.exports = User;