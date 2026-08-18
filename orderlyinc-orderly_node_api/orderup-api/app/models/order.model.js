const { json } = require("body-parser");
const sql = require("../utils/dbConnection.js");
const consts = require("../utils/constants.js");
const {senPushNotification} = require("../services/firebase-config.js");

// constructor
const Order = function(order) {
    this.userid = order.userid;
    this.user_name = order.user_name;
    this.mobile = order.mobile;
    this.email_id = order.email_id;
    this.street_no = order.street_no;
    this.flat_no = order.flat_no;
    this.address = order.address;
    this.zipcode = order.zipcode;
    this.city = order.city;
    this.state = order.state;
    this.country = order.country;
    this.add_latitude = order.add_latitude;
    this.add_longitude = order.add_longitude;
  };

  var rec_sum = '0';
  var ord_id = '0';
  var ord_dt = '';
  const array = [];

  var source_lat = '0';
  var source_long = '0';
  var destination_lat = '0';
  var destination_long = '0';
  

  Order.add_address = (order, result) => {
    
    sql.query('INSERT INTO user_address SET ?', order, (err, res) => {
        if (err) throw err;
        //res.send('Data Inserted'+result.insertId);  
        var last_insert_id = res.insertId;
        if(last_insert_id != ''){
          if(order.is_default == 1) {
            sql.query("Update user_address SET is_default = 0 Where ua_id != '"+last_insert_id+"' AND userid = '"+order.userid+"'", (err, res) => {});
          }
            sql.query("select ua_id, user_name, mobile, email_id, street_no, flat_no, address, zipcode, city, state, country, add_latitude, add_longitude,address_type,is_default  from user_address  WHERE ua_id = '"+last_insert_id+"'", function (err, recordset) {
    
                if (err) console.log(err)
    
                // send records as a response
                result(null,{ status:200, address: recordset, msg:'Successed'}); 
            });    
        }else{
            var resultdata = { };
            result(null,{ status:201, address: rows, msg:'Fail'}); 
        }
    });
  };

  Order.view_address = (order, result) => {

    var userid = order.userid;

    sql.query("select ua_id, user_name, mobile, email_id, street_no, flat_no, address, zipcode, city, state, country, add_latitude, add_longitude,address_type,is_default from user_address  WHERE userid = '"+userid+"' ",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            result(null,{ status:200, address: rows, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, address: resultdata, msg:'Success'}); 
        }
    })
  };
  
  Order.update_address = (order, result) => {
    var addressid = order.addressid;
    var userid = order.userid;
    var user_name = order.user_name;
    var mobile = order.mobile;
    var email_id = order.email_id;
    var street_no = order.street_no;
    var flat_no = order.flat_no;
    var address = order.address;
    var zipcode = order.zipcode;
    var city = order.city;
    var state = order.state;
    var country = order.country; 
    var add_latitude = order.add_latitude;
    var add_longitude = order.add_longitude;
    var address_type = order.address_type;
    var is_default = order.is_default;

    //sql.query("select ua_id  WHERE ua_id = '"+last_insert_id+"'", function (err, recordset) {
    sql.query("Update user_address SET user_name = '"+user_name+"', mobile = '"+mobile+"', email_id = '"+email_id+"', street_no = '"+street_no+"', flat_no = '"+flat_no+"', address = '"+address+"', zipcode = '"+zipcode+"', city = '"+city+"', state = '"+state+"', country = '"+country+"', add_latitude = '"+add_latitude+"', add_longitude = '"+add_longitude+"',address_type = '"+address_type+"',is_default ="+is_default+" Where ua_id = '"+addressid+"' AND userid = '"+userid+"'", (err, res) => {
        if (err) throw err;
        if(is_default == 1) {
          sql.query("Update user_address SET is_default = 0 Where ua_id != '"+addressid+"' AND userid = '"+userid+"'", (err, res) => {});
        }
        var resid = res.changedRows;
        result(null,{ status:200, address: resid, msg:'Successed'});  
    });
  };

  Order.urgent_charges = (req, result) => {

    sql.query('select dc_id, delivery_name, amount from delivery_charge_tb',(err,rows)=>{
      if (err) throw err;
        if (rows.length > 0) {
          
          result(null,{ status:200, charges: rows, msg:'Success'}); 
        }else{
           
            var resultdata = {
             
            };  
            result(null,{ status:200, charges: resultdata, msg:'Fail'}); 
        }
    })
  };

  //delete address
  Order.delete_address = (order, result) => {
    var address_id = order.address_id;
    var user_id = order.user_id;
    
      sql.query("delete from user_address WHERE ua_id = '"+address_id+"' AND userid = '"+user_id+"'",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            result(null,{ status:200, address: rows, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, address: resultdata, msg:'Success'}); 
        }
      })
  };


  Order.place_order = (orders, result) => {

    
    // console.log(`SELECT add_latitude as 'lat',add_longitude as 'long' FROM user_address WHERE ua_id IN (${orders.src_address_id},${orders.dest_address_id})`);
    sql.query("select  * from conveyance_tb LIMIT 1",(err,conv_rec)=>{
      if(err) return result(null,{ status:500, msg:'Fail'});
      if(conv_rec.length) {
        var conv_fee = `${conv_rec[0].conveyance}`;
      }
      else {
        var conv_fee = 0;
      }
      //array1.push(sum);
      sql.query("select  * from delivery_charge_tb LIMIT 1",(err,delivery_rows)=>{
        if(err) return result(null,{ status:500, msg:'Fail'});
        if(delivery_rows.length && orders.delivery_option == 0) {
          var del_charge = `${delivery_rows[0].amount}`;
        }
        else {
          var del_charge = 0;
        }

        //Get address data
        sql.query("SELECT * from user_address WHERE ua_id = '"+orders.dest_address_id+"'", (err_address, res_address) => {
          if(err_address) throw err_address;
          if(res_address.length) {
            var rec_address = JSON.stringify(res_address[0]);
            sql.query(`SELECT  SUM((pl.rate_per_hour * cart.qty)) AS sub_total FROM cart_tb cart JOIN product_list pl ON pl.product_id = cart.product_id WHERE cart.user_id = ${orders.user_id}`, (err, cart_rows_grp) => {
              if (err) throw err;
              if(cart_rows_grp.length && cart_rows_grp[0].sub_total) {
                var sub_total = cart_rows_grp[0].sub_total;
                var order_main = {
                  user_id         : orders.user_id,
                  delivery_option : orders.delivery_option,
                  delivery_date   : orders.delivery_date,
                  delivery_slot   : orders.delivery_slot,
                  delivery_charge : del_charge,
                  sub_total       : sub_total,
                  convinience_fee : conv_fee,
                  grant_total     : (parseFloat(conv_fee) + parseFloat(del_charge) + parseFloat(sub_total)),
                  discount        : orders.discount,
                  // address         : orders.src_address_id,
                  dest_address    : orders.dest_address_id,
                  payment_transaction_id    : orders.payment_transaction_id,
                  payment_mode    : orders.payment_mode,
                  full_dest_address : rec_address
                }
                
                sql.query('INSERT INTO order_tb SET ?', order_main, (err, order_rec) => {
                  if (err) throw err;
                    var last_insert_id = order_rec.insertId;
                    if(last_insert_id && last_insert_id > 0) {
    
                      var notification_details = {
                        'producers':[],
                        'user':orders.user_id,
                        'order_number':'OD'+last_insert_id.toString().padStart(6, '0'),
                      };
    
                      sql.query(`SELECT  cart.cart_id,cart.product_id,cart.qty,pl.product_name,pl.product_desc,pl.rate_per_hour,(pl.rate_per_hour * cart.qty) AS item_total, pl.producerid FROM cart_tb cart JOIN product_list pl ON pl.product_id = cart.product_id WHERE cart.user_id = ${orders.user_id}`, (err, cart_rows) => {
                        if (err) throw err;
                        if(cart_rows.length) {
    
                          for (let cart_i = 0; cart_i < cart_rows.length; cart_i++) {
                            var cart_rec = cart_rows[cart_i];
                            notification_details['producers'].push(cart_rec.producerid);
                              var order_details = {
                                order_id      : last_insert_id,
                                order_number  : '',
                                producer_id   : cart_rec.producerid,
                                product_id    : cart_rec.product_id,
                                rate_per_hour : cart_rec.rate_per_hour,
                                qty           : cart_rec.qty,
                                product_name  : cart_rec.product_name,
                                product_desc  : cart_rec.product_desc,
                                img_paths     :  '',
                                total         :  cart_rec.item_total,
                                address       : 0,
                                dest_address  : 0,
                              }
    
    
                              sql.query('INSERT INTO order_details_id SET ?', order_details, (err, record_details) => {
                                if (err) throw err;
                                  var record_details_id = record_details.insertId;
                
                                  var historydata = {
                                    order_detail_id: `${record_details_id}`,
                                    order_num: 0,
                                    oh_status: 0
                                  };
                                              
                                  sql.query('INSERT INTO order_history SET ?', historydata, (err) => {
                                    if (err) throw err;
                                    sql.query(`delete from cart_tb WHERE user_id = ${orders.user_id}`, (err, res) => {
                                      if (err) throw err;
                                      // result(null,{ status:200, address: resultdata, msg:'Successed'});   
                                    });
                              });
    
                              //Update Qty of product
                              sql.query('UPDATE product_list SET product_qty = IF((product_qty - '+cart_rec.qty+') < 0 , 0, (product_qty - '+cart_rec.qty+')) WHERE product_id = "'+cart_rec.product_id+'"', (err, record_update) => {
    
                              });
    
                            });
                          }
    
                          //Send Notification
                          //{ producers: [ 1, 1, 1, 2 ], user: 1 }
                          if(notification_details.user) {
    
                            sql.query("SELECT fcm_id FROM `users_tb` WHERE `user_id`= '"+notification_details.user+"'  LIMIT 1",(err,result_noti_user)=>{
    
                              if(result_noti_user.length) {
                                var record_noti_user = result_noti_user[0];
                                if(record_noti_user.fcm_id) {
    
                                  var notification_data = {
                                    title: 'Order Placed',
                                    body: 'Your order placed successfully. Order Number : '+notification_details.order_number,
                                    user_token : record_noti_user.fcm_id,
                                    user_id : notification_details.user,
                                    api_url : 'my_order',
                                    api_data : {}
                                  }
                            
                                  senPushNotification(notification_data);
                                }
    
                              }
    
                            });
                          }
    
                          //Notification to Producer
                          if(notification_details.producers) {
    
                            var producers_ids = notification_details.producers.toString();
    
                            sql.query("SELECT user_id,fcm_id FROM `users_tb` WHERE `producerid` IN ("+producers_ids+")",(err,result_noti_prducer)=>{
    
                              if(result_noti_prducer.length) {
                                for (let i = 0; i < result_noti_prducer.length; i++) {
                                  var record_noti_user = result_noti_prducer[i];
                                  if(record_noti_user.fcm_id) {
    
                                    var notification_data = {
                                      title: 'New Order',
                                      body: 'You have new Order : '+notification_details.order_number,
                                      user_token : record_noti_user.fcm_id,
                                      user_id : record_noti_user.user_id,
                                      api_url : 'producer_orders_details',
                                      api_data : {'order_id':last_insert_id,'status':0}
                                    }
                              
                                    senPushNotification(notification_data);
                                  }
                                }
    
                              }
    
                            });
                          }
                        }
                      });
    
                    }
                    
    
                });
    
              }
    
            });
          }

        });
      
                
   
    });
  });
  result(null,{ status:200,  msg:'Successed'});   
    
  };



  Order.my_order = (order, result) => {

    var userid = order.userid;
    var product_image_base = consts.S3_URL+'/products/';
    var where_condition = "WHERE order_tb.user_id = '"+userid+"'";
    var filter = order.filter;
    if(filter) {
        if(filter.time) {

          if(filter.time.type == 'days' && filter.time.duration > 0 && filter.time.duration <= 60) {
            where_condition += " AND od.date_time > (current_timestamp - INTERVAL "+filter.time.duration+" DAY)";
          }
          if(filter.time.type == 'year' && filter.time.duration > 0) {
            where_condition += " AND YEAR(od.date_time) = "+filter.time.duration;
          }
          if(filter.time.type == 'older' && filter.time.duration > 0) {
            where_condition += " AND YEAR(od.date_time) < "+filter.time.duration;
          }
        }
        if(filter.status) {
          where_condition += " AND current_status = "+filter.status;
        }
    }
    
    
    sql.query("select order_details_id, od.order_id, CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, od.producer_id, od.product_id, qty, od.product_name, od.product_desc,CONCAT('"+product_image_base+"',pit.img_path) as img_paths, current_status,od.date_time as order_date, pl.producer_name,od.total as total_amount,order_tb.delivery_charge,order_tb.convinience_fee,(order_tb.delivery_charge + order_tb.sub_total + order_tb.convinience_fee) as order_total_amount,od.rate_per_hour as item_price,ctb.currency_type,ctb.currency from order_details_id od JOIN order_tb ON od.order_id = order_tb.order_id INNER Join producer_list pl ON od.producer_id = pl.producer_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id LEFT join currency_tb ctb on order_tb.currency_id=ctb.cur_id "+where_condition+" order by order_details_id desc",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            result(null,{ status:200, orders: rows, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, orders: resultdata, msg:'Success'}); 
        }
    })
  };

  /*Order.producer_orders = (order, result) => {

    
    var producerid = order.producerid;
    var status = order.status;
    
    sql.query("SELECT DISTINCT(order_number)  FROM order_details_id WHERE producer_id = '"+producerid+"' and current_status = '"+status+"'",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            
         

            result(null,{ status:200, orders: rows, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, orders: resultdata, msg:'Success'}); 
        }
    })
  };*/

  Order.producer_orders = (order, result) => {
    var producerid = order.producerid;
    var status = order.status;

    
    
    if(status==0){
      sql.query("SELECT odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,SUM(odi.total) as total_amount,currency_tb.currency,currency_tb.currency_type, order_date FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id JOIN order_tb ON order_tb.order_id = odi.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE odi.producer_id = '"+producerid+"' and odi.current_status = '"+status+"'  GROUP by order_number,odi.order_id, odi.producer_id, odi.current_status order by odi.order_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
              result(null,{ status:200, orders: rows, msg:'Success'}); 
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    }

    if(status==1){
      sql.query("SELECT odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,SUM(odi.total) as total_amount,currency_tb.currency,currency_tb.currency_type, order_date FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id JOIN order_tb ON order_tb.order_id = odi.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE odi.producer_id = '"+producerid+"' and (odi.current_status = '"+status+"' || odi.current_status = '7' || odi.current_status = '11') GROUP by order_number,odi.order_id, odi.producer_id, odi.current_status order by odi.order_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
              result(null,{ status:200, orders: rows, msg:'Success'}); 
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    }
    if(status==2){
      sql.query("SELECT odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,SUM(odi.total) as total_amount,currency_tb.currency,currency_tb.currency_type, order_date FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id JOIN order_tb ON order_tb.order_id = odi.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE odi.producer_id = '"+producerid+"' and (odi.current_status = '"+status+"' || odi.current_status = '9' || odi.current_status = '13') GROUP by order_number,odi.order_id, odi.producer_id, odi.current_status order by odi.order_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
              result(null,{ status:200, orders: rows, msg:'Success'}); 
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    }
    if(status==3){
      sql.query("SELECT odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,SUM(odi.total) as total_amount,currency_tb.currency,currency_tb.currency_type, order_date FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id JOIN order_tb ON order_tb.order_id = odi.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE odi.producer_id = '"+producerid+"' and (odi.current_status = '"+status+"' || odi.current_status = '10' || odi.current_status = '14') GROUP by order_number,odi.order_id, odi.producer_id, odi.current_status order by odi.order_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
              result(null,{ status:200, orders: rows, msg:'Success'}); 
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    }

    if(status==6){
      sql.query("SELECT odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,SUM(odi.total) as total_amount,currency_tb.currency,currency_tb.currency_type, order_date FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id JOIN order_tb ON order_tb.order_id = odi.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE odi.producer_id = '"+producerid+"' and (odi.current_status = '"+status+"' || odi.current_status = '8' || odi.current_status = '12') GROUP by order_number,odi.order_id, odi.producer_id, odi.current_status order by odi.order_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
              result(null,{ status:200, orders: rows, msg:'Success'}); 
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    }

    if(status==4){
      sql.query("SELECT odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,SUM(odi.total) as total_amount,currency_tb.currency,currency_tb.currency_type, order_date FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id JOIN order_tb ON order_tb.order_id = odi.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE odi.producer_id = '"+producerid+"' and (odi.current_status = '"+status+"' || odi.current_status = '5') GROUP by order_number,odi.order_id, odi.producer_id, odi.current_status order by odi.order_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
              result(null,{ status:200, orders: rows, msg:'Success'}); 
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    }

  };

  Order.producer_orders_details = (order, result) => {

    var orderid = order.order_id;
    var producerid = order.producerid;
    var status = order.status;
    var product_image_base = consts.S3_URL+'/products/';
    var user_data_array = [];
    var status_condition = (status >= 0) ? ' AND current_status='+status : ' ';
    // if(status == 4 || status == 5){
      // odi.order_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,COUNT(product_id) as cnt, odi.current_status,odi.total as total_amount,currency_tb.currency,currency_tb.currency_type, order_date
      sql.query("select od.order_details_id, od.order_id, CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, od.producer_id,  od.product_id, od.qty, od.product_name, od.rate_per_hour, od.product_desc, CONCAT('"+product_image_base+"',pit.img_path) as img_paths, od.current_status, od.date_time as order_date, od.reject_reason, pl.producer_name, return_title, review,od.total as total_amount,currency_tb.currency,currency_tb.currency_type,pl.producer_image_url,pl.producer_icon_url,order_tb.full_dest_address from order_details_id od INNER Join producer_list pl ON od.producer_id = pl.producer_id LEFT Join product_return pr ON od.order_details_id = pr.order_details_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id JOIN order_tb ON order_tb.order_id = od.order_id LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id WHERE od.producer_id = '"+producerid+"' and od.order_id = '"+orderid+"'"+status_condition+" order by order_details_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
            var rec = rows[0];
            var full_dest_address = JSON.parse(rec.full_dest_address);
            var parent_order = {
              order_id : rec.order_id,
              order_number : rec.order_number,
              producer_id : rec.producer_id,
              producer_image_url : rec.producer_image_url,
              producer_icon_url : rec.producer_icon_url

            };
            // var order_number = `${rows[0].order_number}`;
            // sql.query("SELECT ua.user_name, ua.mobile, ua.email_id, ua.street_no, ua.flat_no, ua.address, ua.zipcode, ua.city, ua.state, ua.country,ua.address_type FROM order_tb otb INNER JOIN user_address ua ON otb.dest_address= ua.ua_id  WHERE ua.ua_id = otb.dest_address and otb.order_id='"+orderid+"' ",(err,recordset)=>{
             
              // for (let i = 0; i < recordset.length; i++) {
  
              //   // var value = od_dt.substr(4, 11);
  
                
              //   array.push(full_dest_address);

              // }  
              // })
              user_data_array.push(full_dest_address);
              result(null,{ status:200, orders: rows, user_data: user_data_array,parent_order, msg:'Success'}); 
  
              
          }else{
              var resultdata = { };
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
   
  };


  Order.update_order_status = (orders, result) => {

    
    var order_detail_id = orders.order_detail_id;
    var status = orders.status;
    var reject_reason = orders.reject_reason;
    
    var str_array = order_detail_id.split(',');
    // str_array = str_array.filter(n=>n);
    str_array = str_array.filter(function (n) { if(n > 0)return true });

    //validate request
    if(!((orders.status == 3 && orders.user_type == 2) || orders.status != 3 &&  orders.user_type != 2)) {
      return result(null,{ status:403, order: status, msg:'Forbidden Request'});   
    }
    

    //console.log(str_array); 
    // if (err) console.log(err)
    for (let i = 0; i < str_array.length ; i++) {  //- 1
      var status_name = consts.ORDER_STATUS[status]
      notification_details = {
        'user' : '',
        'producer' : '',
        'status_name' : status_name ? status_name : ' Updated'
      };
      
      if(`${str_array[i]}`.trim() != ''){
        var order_detail_id = `${str_array[i]}`;
          if(status == 6 || status == 8 || status == 12){

            sql.query("Update order_details_id SET current_status = '"+status+"', reject_reason = '"+reject_reason+"'  Where order_details_id = '"+order_detail_id+"'", (err, res) => {
                
            });
          }else{
            sql.query("Update order_details_id SET current_status = '"+status+"' Where order_details_id = '"+order_detail_id+"'", (err, res) => {

              if((i+1) == str_array.length && orders.producer_id > 0) {

                var str_array_str = str_array.toString();
                sql.query("SELECT * from user_address WHERE userid = '"+orders.user_id+"' ORDER BY ua_id DESC LIMIT 1", (err, res_src) => {
                  if(res_src.length) {
                    var res_src_rec = res_src[0];
                    var rec_src_address = JSON.stringify(res_src_rec);
                    // console.log("UPDATE order_details_id SET address="+res_src_rec.ua_id+" WHERE address = 0 AND order_details_id = '"+order_detail_id+"'");
                    sql.query("UPDATE order_details_id SET address="+res_src_rec.ua_id+",full_src_address='"+rec_src_address+"' WHERE address = 0 AND order_details_id IN ("+str_array_str+")", (err, res_update) => {
                      
                      if(res_update.changedRows > 0) {
                        //Assign Delivery Agent
                        sql.query("SELECT user_id,fcm_id  FROM `users_tb` WHERE user_type=2 AND user_id NOT IN (SELECT delivery_agent FROM order_details_id WHERE current_status > 4);", (err, res_del) => {
                          if(res_del.length) {
                            var res_del_rec = res_del[0];
                            sql.query("UPDATE order_details_id SET delivery_agent="+res_del_rec.user_id+" WHERE order_details_id  IN ("+str_array_str+")",  (err, res_del_update) => {
                              var notification_data = {
                                title: 'Order Received',
                                body: 'You received an order',
                                user_token : res_del_rec.fcm_id,
                                user_id : res_del_rec.user_id,
                                api_url : 'delivery_agent_orders_details',
                                api_data : {'order_details_id':order_detail_id}
                              }
                        
                              senPushNotification(notification_data);
                              
                            });
  
                          }
                          else {
                            sql.query("SELECT user_id,fcm_id FROM `users_tb` WHERE user_type=2 ORDER BY rand();", (err, res_del_all) => {
                              if(res_del_all.length) {
                                var res_del_rec = res_del_all[0];
                                sql.query("UPDATE order_details_id SET delivery_agent="+res_del_rec.user_id+" WHERE order_details_id  IN ("+str_array_str+")",  (err, res_del_update) => {

                                  var notification_data = {
                                    title: 'Order Received',
                                    body: 'You received an order',
                                    user_token : res_del_rec.fcm_id,
                                    user_id : res_del_rec.user_id,
                                    api_url : 'delivery_agent_orders_details',
                                    api_data : {'order_details_id':order_detail_id}
                                  }

                                  senPushNotification(notification_data);
      
                                });
      
                              }
                            });
                          }
  
                        });
                      }
  
                    });
                  }
                })

              }

                  
            });
            
            
          }
          
          sql.query("select  odi.order_details_id, odi.producer_id,ot.user_id,odi.order_id from order_details_id odi JOIN order_tb ot ON ot.order_id = odi.order_id  WHERE odi.order_details_id = '"+order_detail_id+"' ",(err,rows)=>{
          
            if(rows.length) {

              // var order_num = `${rows[0].order_number}`;
              var ord_detail_id = `${rows[0].order_details_id}`;
              var order_id = `${rows[0].order_id}`;
              var order_number = 'OD'+order_id.toString().padStart(6, '0')
              
              var historydata = {
                order_detail_id: `${ord_detail_id}`,
                order_num: '',
                oh_status: `${status}`
              };
              sql.query('INSERT INTO order_history SET ?', historydata, (err, recordset) => {
  
              });  

              notification_details['user']=rows[0].user_id;
              notification_details['producer']=rows[0].producer_id;

              if(notification_details.user) {

                sql.query("SELECT fcm_id FROM `users_tb` WHERE `user_id`= '"+notification_details.user+"'  LIMIT 1",(err,result_noti_user)=>{
  
                  if(result_noti_user.length) {
                    var record_noti_user = result_noti_user[0];
                    if(record_noti_user.fcm_id) {
  
                      var notification_data = {
                        title: 'Order is '+notification_details.status_name,
                        body: 'Your order :'+order_number+' is '+notification_details.status_name,
                        user_token : record_noti_user.fcm_id,
                        user_id : notification_details.user,
                        api_url : 'track_order',
                        api_data : {'order_details_id':ord_detail_id}
                      }
                
                      senPushNotification(notification_data);
                    }
  
                  }
  
                });
              }
  
              //Notification to Producer
              // console.log(notification_details);
              if(notification_details.producer) {
                sql.query("SELECT user_id,fcm_id FROM `users_tb` WHERE `producerid` = '"+notification_details.producer+"'",(err,result_noti_prducer)=>{
  
                  if(result_noti_prducer.length) {
                    for (let i = 0; i < result_noti_prducer.length; i++) {
                      var record_noti_user = result_noti_prducer[i];
                      if(record_noti_user.fcm_id) {
  
                        var notification_data = {
                          title: 'Order is '+notification_details.status_name,
                          body: 'Order :'+order_number+' is '+notification_details.status_name,
                          user_token : record_noti_user.fcm_id,
                          user_id : record_noti_user.user_id,
                          api_url : 'producer_orders_details',
                          api_data : {'order_id':order_id,'status':status}
                        }
                  
                        senPushNotification(notification_data);
                      }
                    }
  
                  }
  
                });
              }
            }

            
            if(status == 10 || status == 14){
              if(status == 10){
                var cur_status = 4;
              }else{
                var cur_status = 5;
              }
              sql.query("Update product_return SET is_return_replace = '1', prod_status = '"+cur_status+"' Where order_details_id = '"+order_detail_id+"'", (err, res) => {
                  
              });
            }

            
            
          });

          
        }   
    }
              
    // send records as a response
    result(null,{ status:200, order: status, msg:'Successed'});   
  };


  Order.product_review = (order, result) => {
    
    

    
    sql.query('INSERT INTO product_review SET ?', order, (err, res) => {
        if (err) throw err;
        //res.send('Data Inserted'+result.insertId);  
        var last_insert_id = res.insertId;
        if(last_insert_id != ''){
          result(null,{ status:200, review: last_insert_id, msg:'Successed'});   
        }else{
            var resultdata = { };
            result(null,{ status:201, review: resultdata, msg:'Fail'}); 
        }
    });
  };

  Order.product_return = (order, result) => {
    var return_type = order.return_type;
    var return_title = order.return_title;
    var review = order.review;
    var order_number = order.order_number;
    var order_details_id = order.order_details_id;
    var product_id = order.product_id;
    var user_id = order.user_id;
    var status = order.prod_status;
    

    
    sql.query('INSERT INTO product_return SET ?', order, (err, res) => {
        if (err) throw err;
          
        var last_insert_id = res.insertId;
        if(last_insert_id != ''){

          var historydata = {
            order_detail_id: `${order_details_id}`,
            order_num: `${order_number}`,
            oh_status: `${status}`
          };
          
          sql.query('INSERT INTO order_history SET ?', historydata, (err, recordset) => {
  
          });  
  
          sql.query("Update order_details_id SET current_status = '"+status+"' Where order_details_id = '"+order.order_details_id+"'", (err, res) => {
                
          });

          result(null,{ status:200, return_order: last_insert_id, msg:'Successed'});   
        }else{
            var resultdata = { };
            result(null,{ status:201, return_order: resultdata, msg:'Fail'}); 
        }
    });
  };

  Order.producer_order_return = (order, result) => {
    var producerid = order.producerid;
    var status = 4;
    var product_image_base = consts.S3_URL+'/products/';
    
    //SELECT order_number,odi.producer_id,pl.producer_image_url,COUNT(product_id) as cnt FROM order_details_id odi INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id WHERE odi.producer_id = '"+producerid+"' and odi.current_status = '"+status+"' GROUP by odi.order_number,odi.order_id, odi.producer_id order by order_number
    sql.query("SELECT od.order_details_id, CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, od.product_name, od.product_desc, CONCAT('"+product_image_base+"',pit.img_path) as img_paths, od.qty, od.rate_per_hour, DATE(od.date_time) as order_date, pr.return_id, pr.return_type, pr.return_title, pr.review, pr.user_id FROM `order_details_id` od INNER JOIN product_return pr ON od.order_details_id = pr.order_details_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id WHERE od.producer_id = '"+producerid+"' and  `current_status`= '"+status+"' order by od.order_details_id ",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            result(null,{ status:200, orders: rows, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, orders: resultdata, msg:'Success'});  
        }
    })
  };

  Order.return_order_reasons = (req, result) => {

    sql.query('select reason_id, reason from order_return_reason_tb',(err,rows)=>{
      if (err) throw err;
        if (rows.length > 0) {
          
          result(null,{ status:200, charges: rows, msg:'Success'}); 
        }else{
           
            var resultdata = {
             
            };  
            result(null,{ status:200, charges: resultdata, msg:'Fail'}); 
        }
    })
  };

  Order.track_order = (order, result) => {
    var order_details_id = parseInt(order.order_details_id);
    var product_image_base = consts.S3_URL+'/products/';
    // select  CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, qty, od.product_name, od.product_desc,CONCAT('"+product_image_base+"',pit.img_path) as img_paths, current_status,od.date_time as order_date, pl.producer_name,od.total as total_amount,(order_tb.delivery_charge + order_tb.sub_total + order_tb.convinience_fee) as order_total_amount,od.rate_per_hour as item_price,ctb.currency_type,ctb.currency from order_details_id od JOIN order_tb ON od.order_id = order_tb.order_id INNER Join producer_list pl ON od.producer_id = pl.producer_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id LEFT join currency_tb ctb on order_tb.currency_id=ctb.cur_id "+where_condition+" order by order_details_id desc
    // select order_details_id, od.order_id, CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, od.producer_id, od.product_id, qty, od.product_name, od.product_desc,CONCAT('"+product_image_base+"',pit.img_path) as img_paths, current_status,od.date_time as order_date, pl.producer_name,od.total as total_amount,(order_tb.delivery_charge + order_tb.sub_total + order_tb.convinience_fee) as order_total_amount,od.rate_per_hour as item_price,ctb.currency_type,ctb.currency from order_details_id od JOIN order_tb ON od.order_id = order_tb.order_id INNER Join producer_list pl ON od.producer_id = pl.producer_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id LEFT join currency_tb ctb on order_tb.currency_id=ctb.cur_id "+where_condition+" order by order_details_id desc"
    sql.query("SELECT COUNT(odi.order_details_id) as total_sub_orders,(od.delivery_charge + od.sub_total + od.convinience_fee) as order_total_amount,ctb.currency_type,ctb.currency, qty,CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, odi.product_name, odi.product_desc,CONCAT('"+product_image_base+"',pit.img_path) as img_paths,od.order_id,odi.producer_id, odi.product_id,current_status,odi.date_time as order_date,odi.total as total_amount,odi.rate_per_hour as item_price,odi.reject_reason  FROM `order_details_id` odi JOIN order_tb od ON od.order_id = odi.order_id LEFT join currency_tb ctb on od.currency_id=ctb.cur_id join product_img_tb pit ON odi.product_id=pit.product_id WHERE od.order_id = (SELECT order_id FROM order_details_id WHERE order_details_id = '"+order_details_id+"') GROUP BY od.order_id ",(err,rows_grp)=>{
      if(err) throw err;
      if(rows_grp.length) {
        var rec_grp = rows_grp[0];
        var is_splitted = rec_grp.total_sub_orders > 1 ? true : false;
        var order_total_amount = rec_grp.order_total_amount;
        var splitted_orders = rec_grp.total_sub_orders;
        var currency = rec_grp.currency;
        var currency_type = rec_grp.currency_type;
        var reject_reason = rec_grp.reject_reason;

        var parent_order = {
          order_details_id : order_details_id,
          order_id : rec_grp.order_id,
          order_number : rec_grp.order_number,
          producer_id : rec_grp.producer_id,
          product_id : rec_grp.product_id,
          qty : rec_grp.qty,
          product_name : rec_grp.product_name,
          product_desc : rec_grp.product_desc,
          img_paths : rec_grp.img_paths,
          current_status : rec_grp.current_status,
          order_date : rec_grp.order_date,
          producer_name : '',
          total_amount : rec_grp.total_amount,
          order_total_amount : rec_grp.order_total_amount,
          item_price : rec_grp.item_price,
          currency_type : rec_grp.currency_type,
          currency : rec_grp.currency

        }
        sql.query("SELECT return_type, prod_status, is_return_replace FROM `product_return` WHERE `order_details_id`= '"+order_details_id+"'  order by return_id limit 1 ",(err,rows,fields)=>{
            if (err) throw err;
            if (rows.length > 0) {
              var is_return_replace = `${rows[0].is_return_replace}`;
              var prod_status = `${rows[0].prod_status}`;
    
              if(is_return_replace == 0){
                if(prod_status == 4){
                  sql.query("SELECT order_num, oh_status, oh_date_time as order_date FROM `order_history` WHERE `order_detail_id`= '"+order_details_id+"' and (oh_status=4 or oh_status=7 or oh_status=8 or oh_status=9 or oh_status=10)  order by order_history_id ",(err,recordset,fields)=>{
                    var array = [];
                    for (let i = 0; i < recordset.length; i++) {
    
                      const od_dt = `${recordset[i].order_date}`;
                      var value = od_dt.substr(4, 11);
    
                      var resultdata = {
                        order_num: `${recordset[i].order_num}`,
                        oh_status: `${recordset[i].oh_status}`,
                        order_date: value
                      };
                      array.push(resultdata);
                    }  
                    
                    var finaldata = {
                      ret_rplc: prod_status,
                      track_data: array,
                      is_splitted,
                      order_total_amount,
                      splitted_orders,
                      currency,
                      currency_type,
                      reject_reason
                    };
    
                    result(null,{ status:200, track_order: finaldata,parent_order, msg:'Success'});  
    
                  });
                }else{  //currently in replace state
                  sql.query("SELECT order_num, oh_status, oh_date_time as order_date FROM `order_history` WHERE `order_detail_id`= '"+order_details_id+"'  and (oh_status=5 or oh_status=11 or oh_status=12 or oh_status=13 or oh_status=14)  order by order_history_id ",(err,recordset,fields)=>{
                    var array = [];
                    for (let i = 0; i < recordset.length; i++) {
    
                      const od_dt = `${recordset[i].order_date}`;
                      var value = od_dt.substr(4, 11);
    
                      var resultdata = {
                        order_num: `${recordset[i].order_num}`,
                        oh_status: `${recordset[i].oh_status}`,
                        order_date: value
                      };
                      array.push(resultdata);
                    }  
                    
                    var finaldata = {
                      ret_rplc: prod_status,
                      track_data: array,
                      is_splitted,
                      order_total_amount,
                      splitted_orders,
                      currency,
                      currency_type,
                      reject_reason
                    };
    
                    result(null,{ status:200, track_order: finaldata,parent_order, msg:'Success'});  
    
                  });
                }  
              }else{
                if(prod_status == 4){
                  sql.query("SELECT order_num, oh_status, oh_date_time as order_date FROM `order_history` WHERE `order_detail_id`= '"+order_details_id+"'  and (oh_status=4 or oh_status=7 or oh_status=8 or oh_status=9 or oh_status=10) order by order_history_id ",(err,recordset,fields)=>{
                    var array = [];
                    for (let i = 0; i < recordset.length; i++) {
    
                      const od_dt = `${recordset[i].order_date}`;
                      var value = od_dt.substr(4, 11);
    
                      var resultdata = {
                        order_num: `${recordset[i].order_num}`,
                        oh_status: `${recordset[i].oh_status}`,
                        order_date: value
                      };
                      array.push(resultdata);
                    }  
    
                    var finaldata = {
                      ret_rplc: prod_status,
                      track_data: array,
                      is_splitted,
                      order_total_amount,
                      splitted_orders,
                      currency,
                      currency_type,
                      reject_reason
                    };
    
                    result(null,{ status:200, track_order: finaldata,parent_order, msg:'Success'});  
    
                  });
                }else{
                  sql.query("SELECT order_num, oh_status, oh_date_time as order_date FROM `order_history` WHERE `order_detail_id`= '"+order_details_id+"' and (oh_status=5 or oh_status=11 or oh_status=12 or oh_status=13 or oh_status=14) order by order_history_id ",(err,recordset,fields)=>{
                    var array = [];
                    for (let i = 0; i < recordset.length; i++) {
    
                      const od_dt = `${recordset[i].order_date}`;
                      var value = od_dt.substr(4, 11);
    
                      var resultdata = {
                        order_num: `${recordset[i].order_num}`,
                        oh_status: `${recordset[i].oh_status}`,
                        order_date: value
                      };
                      array.push(resultdata);
                    }  
    
                    var finaldata = {
                      ret_rplc: prod_status,
                      track_data: array,
                      is_splitted,
                      order_total_amount,
                      splitted_orders,
                      currency,
                      currency_type,
                      reject_reason
                    };
    
                    result(null,{ status:200, track_order: finaldata,parent_order, msg:'Success'});  
    
                  });
                }  
    
              }
    
              /*sql.query("SELECT order_num, oh_status, oh_date_time as order_date FROM `order_history` WHERE `order_detail_id`= '"+order_details_id+"'  order by order_history_id ",(err,rows,fields)=>{
              });*/
               
            }else{
              sql.query("SELECT order_num, oh_status, oh_date_time as order_date FROM `order_history` WHERE `order_detail_id`= '"+order_details_id+"' and (oh_status=0 or oh_status=1 or oh_status=2 or oh_status=3 or oh_status=6)  order by order_history_id ",(err,recordset,fields)=>{
                var array = [];
                for (let i = 0; i < recordset.length; i++) {
    
                  const od_dt = `${recordset[i].order_date}`;
                  var value = od_dt.substr(4, 11);
    
                  var resultdata = {
                    order_num: `${recordset[i].order_num}`,
                    oh_status: `${recordset[i].oh_status}`,
                    order_date: value
                  };
                  array.push(resultdata);
                }  
    
                var finaldata = {
                  ret_rplc: '',
                  track_data: array,
                  is_splitted,
                  order_total_amount,
                  splitted_orders,
                  currency,
                  currency_type,
                  reject_reason
    
                };
    
                result(null,{ status:200, track_order: finaldata,parent_order, msg:'Success'});  
    
              });
            }
        })
      }
      else {
        result(null,{ status:200, track_order: {}, msg:'Fail'});  
      }

    });
  };


  Order.update_temp_loacation = (order, result) => {
    var device_id = order.device_id;
    var latitude = order.latitude;
    var longitude = order.longitude;
    var temperature = order.temperature;
    
      sql.query('INSERT INTO temp_location SET ?', order, (err, res) => {
        if (err) throw err;
          
        var last_insert_id = res.insertId;
        if(last_insert_id != ''){
           result(null,{ status:200, result_data: last_insert_id, msg:'Successed'});   
        }else{
            var resultdata = { };
            result(null,{ status:201, result_data: resultdata, msg:'Fail'}); 
        }
    });
  };

  Order.send_notification = (order, result) => {
    
   /* var notification = {
      'title':'Title of notification',
      'text':'Subtitle'
    };

    var fcm_tokens = ['d4CN1ZHyS5iHqiCBZRmsuG:APA91bHJO-HwFYIELxheZ6BSdYR1xeG-Y5lOsZnYRqLGoHVfOjQZWFcCl5kwXNzUrcqCQ3GZBg5ldl2-fEpLg6jC6jOylOBMxPHkpuea5fpyKRQumnEdticZj1c8CLq3RG2Va7f2YTL9'];

    var notification_body = {
      'notification': notification,
      'registration_ids':fcm_tokens
    }

      fetch('https://fcm.googleapis.com/fcm/send',{
        'method':'POST',
        'headers':{
          'Authorization': 'key=' + serverKey,
          'Content-Type':'application/json'
        },
        'body':JSON.stringify(notification_body)
      }).then(()=>{
        res.status(200).send('Notification Send Successfully');
      }).catch((err)=>{
        res.status(400).send('Something went wrong');
        console.log(err);
      });*/
     /* var fb_id = 'qhixWAXVqLeRYemD9qvuR9k7njy2';  
      sql.query("select fcm_id from users_tb  WHERE fb_id = '"+fb_id+"' ",(err,rows,fields)=>{
        if (err) throw err;
          if (rows.length > 0) {*/
              //const registrationToken = `${rows[0].fcm_id}`;

              // const registrationToken = 'c3lu85CJxkQhgAsDCCR7gQ:APA91bFWGnhUm1uQeBxsNc85RTsL6N0ocjdC1heJyY7l-rVy8xPYEpeNtJyGSenYlShHCTO9zhV0rMYaWvh5KMPaBcYBLiJt01sBOISNwJGQlCcgcEwJR0jKO91DoEFCg-Y9fLgS0DB9';

              //const registrationToken = 'eqRs_VWeThaCsQI7iwAo_Q:APA91bGvma8Dt9F9g42pKpmpvsPxnQsgugPEr-XJ7aB7VL8BSRsVaMKVr63Rn-aJUfkHRLqQdn0z02J07CaFJj7D34DPoOJ3iQ48_XK1yWrUtaMorkOSSWNDhqj0DF1Nfns17OUVXupj';

              //const registrationToken = 'dJat7HotR3aBlBEgWBypRI:APA91bEmi1wLU3q8AMku9nwbhJB7Bxi7GgeU2Ad15qjmoCUk46o_8kSOD-elEyp-354MpqCX7uFL6ghT30XaOzHz4gxwga6fFeJJTY_BREQ1Seg0yGJlvweBOySVNOqXHqOxzVygq_yP';

              /*var serviceAccount = require("../../orderlyproject-firebase-adminsdk-qoedt-b7531d21c2.json");
              admin.initializeApp({
                  credential: admin.credential.cert(serviceAccount),
              });*/

              /* const messaging = admin.messaging()
              var payload = {
                  notification: {
                      title: "New Order",
                      body: "New Order Placed from pankaj"
                  },
                  data: {
                      flag: "producer_order",  // where to redsirect
                      user_type: "1"
                  },
                  //topic: 'topic'
                  token: registrationToken
                  };
              messaging.send(payload)
              .then((result) => {
                  console.log(result);
                  
              }) */
              // result(null,{ status:200, result_data: '', msg:'Successed'});   
          /*}  
        })  */      
  };

 
  

  Order.download_invoice = (order, result) => {

    var order_id = order.order_id;
    
    sql.query("select order_details_id, order_id, CONCAT('OD',LPAD(order_id,6,0)) as order_number, product_name, qty, rate_per_hour, img_paths, total, date_time as order_date, current_status from order_details_id  WHERE order_id = '"+order_id+"' ", function (err, recordset) {
      if (err) throw error;
      var array = [];
      for (let i = 0; i < recordset.length; i++) {

        const od_dt = `${recordset[i].order_date}`;
        var value = od_dt.substr(4, 11);

        var resultdata = {
          order_details_id: `${recordset[i].order_details_id}`,
          order_id: `${recordset[i].order_id}`,
          order_number: `${recordset[i].order_number}`,
          product_name: `${recordset[i].product_name}`,
          qty: `${recordset[i].qty}`,
          rate_per_hour: `${recordset[i].rate_per_hour}`,
          total: `${recordset[i].total}`,
          img_paths: `${recordset[i].img_paths}`,
          order_date: value,
          current_status: `${recordset[i].current_status}`
        };
        array.push(resultdata);
      }
      
      sql.query("select  sum(total) as receive_amount  from order_details_id  WHERE order_id = '"+order_id+"' ",(err,rows)=>{
        if(rows.length) {
          
          var receve_sum = `${rows[0].receive_amount}`;
          rec_sum = receve_sum;
  
          sql.query("select odi.order_id, odi.date_time as order_date,ot.convinience_fee,ot.delivery_charge  from order_details_id odi JOIN order_tb ot ON ot.order_id=odi.order_id WHERE odi.order_id = '"+order_id+"'",(err,rows)=>{
            if(rows.length) {

              var order_id = `${rows[0].order_id}`;
              ord_id = order_id;
              const odr_dt = `${rows[0].order_date}`;
              var order_dt = odr_dt.substr(4, 11);
              var convinience_fee = `${rows[0].convinience_fee}`;
              var delivery_charge = `${rows[0].delivery_charge}`;
      
              ord_dt = order_dt;
    
              var finaldata = {
                invoice_number: 'OD'+ord_id.toString().padStart(6, '0'),
                order_date: ord_dt,
                total_amount: rec_sum,
                claim_data: array,
                convinience_fee,
                delivery_charge
              };
        
              // send records as a response
              result(null,{ status:200, invoice_details: finaldata, msg:'Successed'}); 
            }
            else {

              result(null,{ status:201, invoice_details: {}, msg:'Fail'}); 
            }
          })
        }
        else {

          result(null,{ status:201, invoice_details: {}, msg:'Fail'}); 
        }
      });
    }); 
  };

  Order.fetch_temprature = (order, result) => {

    var order_details_id = order.order_details_id;
    var device_id = 1; 

    if(order_status == 2 || order_status == 3 || order_status == 10 || order_status == 14){
      
      sql.query("select latitude, longitude, temperature from temp_location_history  WHERE device_id = '"+device_id+"' and orders_detail_id = '"+order_details_id+"'  order by temp_his_id desc limit 10  ", function (err, recordset) {
        if (err) throw err;
        var array = [];

        for (let i = 0; i < recordset.length; i++) {

          var resultdata = {
            latitude: `${recordset[i].latitude}`,
            longitude: `${recordset[i].longitude}`,
            temperature: `${recordset[i].temperature}`
          };
          array.push(resultdata);
        }
        

          var array1 = [];
          sql.query("SELECT ua.add_latitude, ua.add_longitude FROM order_details_id odi INNER JOIN user_address ua ON odi.address = ua.ua_id WHERE odi.order_details_id = '"+order_details_id+"' ",(err,rows)=>{
            if(rows.length) {

              var add_latitude = `${rows[0].add_latitude}`;
              var add_longitude = `${rows[0].add_longitude}`;
              
              source_lat = add_latitude;
              source_long = add_longitude;
  
              sql.query("SELECT ua.add_latitude, ua.add_longitude FROM order_details_id odi INNER JOIN user_address ua ON odi.dest_address = ua.ua_id WHERE odi.order_details_id = '"+order_details_id+"' ",(err,rows)=>{
                if(rows.length) {
                  var add_latitude = `${rows[0].add_latitude}`;
                  var add_longitude = `${rows[0].add_longitude}`;
                  
                  destination_lat = add_latitude;
                  destination_long = add_longitude;
    
                  var finaldata = {
                    source_latitude : source_lat,
                    source_longitude : source_long,
                    destination_latitude : destination_lat,
                    destination_longitude : destination_long,
                    current_location: array
                  };

                  result(null,{ status:200, ordertemp: finaldata, msg:'Success'}); 
                }
                else {
                  result(null,{ status:200, ordertemp: {}, msg:'Success'}); 
                }
      
              })
            }
            else {
              result(null,{ status:200, ordertemp: {}, msg:'Success'}); 
            }

            
          }) 

          /*var array2 = [];
          sql.query("SELECT ua.add_latitude, ua.add_longitude FROM order_details_id odi INNER JOIN user_address ua ON odi.dest_address = ua.ua_id WHERE odi.order_details_id = '"+order_details_id+"' ",(err,rows)=>{
            var add_latitude = `${rows[0].add_latitude}`;
            var add_longitude = `${rows[0].add_longitude}`;
            
            destination_lat = add_latitude;
            destination_long = add_longitude;
          })*/

          
        
      })
    }
    // }else{
      /*sql.query("select latitude, longitude, temperature from temp_location  WHERE device_id = '"+device_id+"' order by temp_id desc limit 10",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            result(null,{ status:200, ordertemp: rows, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, ordertemp: resultdata, msg:'Success'}); 
        }
      })*/
    // }
    


  };
  

  Order.fetch_truck_listing = (order, result) => {

    
    var producerid = order.producerid;

    
      sql.query("select truck_id, truck_name, device_id from truck_tb WHERE producerid = '"+producerid+"' and is_available = 0 and truck_status = 0",(err,rows,fields)=>{
          if (err) throw err;

          result(null,{ status:200, truck_list: rows, msg:'Success'}); 
      })
    
  };

  Order.delivery_agent_orders = (order, result) => {
    var user_id = order.user_id;

    sql.query("SELECT odi.order_id,MAX(odi.order_details_id) as order_details_id,CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number,odi.producer_id,pl.producer_image_url,pl.producer_icon_url,pl.producer_name,odi.date_time as order_date,odi.total as total_amount,odi.current_status,full_src_address as src_address,full_dest_address as dest_address FROM order_details_id odi JOIN order_tb otb ON otb.order_id = odi.order_id  INNER JOIN producer_list pl ON odi.producer_id=pl.producer_id WHERE odi.delivery_agent = '"+user_id+"' GROUP BY odi.order_id  order by FIELD(odi.current_status, 2,1,3),odi.order_id desc",(err,rows)=>{
        if (err) throw err;
        if (rows.length > 0) {
          var resultdata = [];
          var rec_set = [];
          for (let i = 0; i < rows.length; i++) {
            rec_set = rows[i];
            resultdata[i] = rec_set;
            resultdata[i]['src_address'] = JSON.parse(resultdata[i]['src_address']);
            resultdata[i]['dest_address'] = JSON.parse(resultdata[i]['dest_address']);
            //Get Source Address
            // sql.query("SELECT * FROM user_address WHERE ua_id = (SELECT address FROM order_details_id WHERE order_details_id = " +rec_set.order_details_id+" LIMIT 1)",(err_src,rows_src)=>{
            //   if (err_src) throw err_src;
            //   if (rows_src.length > 0) {
            //     var src_add_rec = rows_src[0];
            //     resultdata[i]['src_addresses'] = src_add_rec;
            //   }
            //   //Get Dest Address
            //   sql.query("SELECT * FROM user_address WHERE ua_id = (SELECT dest_address FROM order_tb WHERE order_id = " +rec_set.order_id+" LIMIT 1)",(err_dest,rows_dest)=>{
            //     if (err_dest) throw err_dest;
            //     if (rows_dest.length > 0) {
            //       var dest_add_rec = rows_dest[0];
            //       resultdata[i]['dest_addresses'] = dest_add_rec;
            //     }
            //     if((i+1) == rows.length) {
            //     }
                
            //   });
            // });
            
          }
          result(null,{ status:200, orders: resultdata, msg:'Success'}); 
        }else{
            var resultdata = { };
            result(null,{ status:200, orders: resultdata, msg:'Success'}); 
        }
    })
    

  };

  Order.delivery_agent_orders_details = (order, result) => {
    var order_details_id = order.order_details_id;
    var user_id = order.user_id;
    var product_image_base = consts.S3_URL+'/products/';
    var resultdata = {};
      sql.query("select od.order_details_id, od.order_id,full_src_address as src_address,full_dest_address as dest_address from order_details_id od JOIN order_tb otb ON otb.order_id = od.order_id INNER Join producer_list pl ON od.producer_id = pl.producer_id LEFT Join product_return pr ON od.order_details_id = pr.order_details_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id WHERE od.delivery_agent = '"+user_id+"' and od.order_details_id = '"+order_details_id+"' order by order_details_id desc",(err,rows,fields)=>{
          if (err) throw err;
          if (rows.length > 0) {
            var rec_set  = rows[0];
            resultdata['src_address'] = JSON.parse(rec_set['src_address']);
            resultdata['dest_address'] = JSON.parse(rec_set['dest_address']);
            // var order_number = `${rows[0].order_number}`;
            // sql.query("SELECT * FROM user_address WHERE ua_id = (SELECT address FROM order_details_id WHERE order_details_id = " +rec_set.order_details_id+" LIMIT 1)",(err_src,rows_src,fields)=>{
            //   if (rows_src.length > 0) {
            //     var src_add_rec = rows_src[0];
            //     resultdata['src_addresses'] = src_add_rec;
            //   }
            //   //Get Dest Address
            //   sql.query("SELECT * FROM user_address WHERE ua_id = (SELECT dest_address FROM order_tb WHERE order_id = " +rec_set.order_id+" LIMIT 1)",(err_src,rows_dest,fields)=>{
            //     if (rows_dest.length > 0) {
            //       var dest_add_rec = rows_dest[0];
            //       resultdata['dest_addresses'] = dest_add_rec;
            //     }
                
            //   });
            // });
            sql.query("select od.order_details_id, order_id, CONCAT('OD',LPAD(od.order_id,6,0)) as order_number, od.producer_id,  od.product_id, od.qty, od.product_name, od.rate_per_hour, od.product_desc, CONCAT('"+product_image_base+"',pit.img_path) as img_paths,od.date_time as order_date,od.total as total_amount, od.current_status, od.date_time as order_date, od.reject_reason, pl.producer_name, return_title, review from order_details_id od INNER Join producer_list pl ON od.producer_id = pl.producer_id LEFT Join product_return pr ON od.order_details_id = pr.order_details_id JOIN product_list ON product_list.product_id = od.product_id join product_img_tb pit ON product_list.product_id=pit.product_id WHERE od.delivery_agent = '"+user_id+"' and od.order_id = '"+rec_set.order_id+"' order by order_details_id desc",(err,rows_orders_array,fields)=>{
              if(rows_orders_array.length) {
                resultdata['order_items'] = rows_orders_array;
                resultdata['current_status'] = rows_orders_array[0].current_status;

              }
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
            });
           
              
          }else{
              result(null,{ status:200, orders: resultdata, msg:'Success'}); 
          }
      })
    };

    Order.my_customers = (customer, result) => {
      var user_id = customer.user_id;
      var limit = customer.limit;
      var page = customer.page;
      var offset = (page - 1) * limit;
      var select_fields = "SELECT ct.first_name,ct.last_name,ct.mobile,SUM(odi.total) as total_amount_spend,ctb.currency_type,ctb.currency";
      var count_fields = "SELECT ct.user_id AS user_ids";
      var main_query = " FROM order_details_id odi JOIN users_tb ut ON ut.producerid = odi.producer_id JOIN order_tb ot on ot.order_id = odi.order_id JOIN users_tb ct ON ct.user_id = ot.user_id LEFT join currency_tb ctb on ot.currency_id=ctb.cur_id WHERE ut.user_id = "+user_id+" AND odi.current_status = 3 GROUP BY ct.user_id ";
      sql.query(select_fields+main_query+" ORDER BY total_amount_spend DESC LIMIT "+limit+" OFFSET "+offset,(err,rows)=>{
        if (err) throw err;
        sql.query(count_fields+main_query,(err,rows_count)=>{
          total_pages = 0;
          if(rows_count.length) {
            var total_records = rows_count.length;
            var total_pages = Math.ceil((total_records/limit));
          }
          result(null,{ status:200, customers: rows,total_pages, msg:'Success'}); 
        });
      })
      
  
    };

    Order.update_order_addresses = (customer, result) => {
      
      var query = "SELECT * FROM user_address WHERE ua_id IN (SELECT dest_address FROM order_tb WHERE full_dest_address IS NULL) OR ua_id IN (SELECT address FROM order_details_id WHERE full_src_address IS NULL)";
      
      
      sql.query(query,(err,rows)=>{
        if (err) throw err;
        if(rows.length)
        {
          for (let address_i = 0; address_i < rows.length; address_i++) {
            var address_rec = rows[address_i];
            var addres_json = JSON.stringify(address_rec);
            
            var updte_query1 = "UPDATE order_tb SET full_dest_address = '"+addres_json+"' WHERE dest_address = '"+address_rec.ua_id+"' AND full_dest_address IS NULL";
            sql.query(updte_query1,(err1,rows1)=>{});
            var updte_query2 = "UPDATE order_details_id SET full_src_address = '"+addres_json+"' WHERE address = '"+address_rec.ua_id+"' AND full_src_address IS NULL";
            sql.query(updte_query2,(err2,rows2)=>{});

            
          }
        }
      })
      
  
    };

    Order.cancellation_reasons = (customer, result) => {
      var reasons = [
        'Product not available',
        'Address not deliverable'
      ]
      result(null,{ status:200, reasons, msg:'Success'}); 
    };


Order.order_address_update = (order, result) => {

  var address_id = order.address_id;
  var user_id = order.user_id;
  
  sql.query("SELECT add_latitude,add_longitude FROM user_address WHERE ua_id='"+address_id+"' AND userid='"+user_id+"'",(err,rows,fields)=>{
      if (err) throw err;
      if (rows.length > 0) {
        var rec = rows[0];
        var customer_lat = rec.add_latitude;
        var customer_long = rec.add_longitude;

        //Get Address of Store manager relavant to product from cart
        var q = "SELECT count(cart_id) AS total_cart_items FROM cart_tb WHERE user_id = '"+user_id+"'";
        var address_query = q+" AND product_id IN (SELECT product_id FROM product_list WHERE producerid IN (SELECT user_id FROM users_tb WHERE (ST_Distance_Sphere(point("+customer_long+","+customer_lat+"),point(longitude,latitude))/1000) <= distance))";
        
        sql.query(q,(err_cart,rows_cart)=>{
          if (err_cart) throw err_cart;
          var available_cart_items = 0;
          var total_cart_items = 0;
          if(rows_cart.length) {
            total_cart_items = rows_cart[0].total_cart_items;
            sql.query(address_query,(err_cart_add,rows_cart_add)=>{
              if (err_cart_add) throw err_cart_add;
              if(rows_cart_add.length) {
                available_cart_items = rows_cart_add[0].total_cart_items;
              }
              if(total_cart_items > available_cart_items) {
                result(null,{ status:200, all_items_available:0,total_cart_items,available_cart_items}); 
              }
              else {
                result(null,{ status:200, all_items_available:1,total_cart_items,available_cart_items}); 
              }
            });

          }
          else {
            result(null,{ status:200, all_items_available:1,total_cart_items,available_cart_items}); 
          }


        });

        
          
      }else{
          
          result(null,{ status:201,msg:'Address Not found'}); 
      }
  })
  
};

Order.my_order_collapse = (order, result) => {

  var userid = order.userid;
  var page = order.page;
  var limit = order.limit;
  var offset = (page - 1) * limit;
  var product_image_base = consts.S3_URL+'/products/';
  var where_condition = "WHERE ot.user_id = '"+userid+"'";
  var filter = order.filter;
  if(filter) {
      if(filter.time) {

        if(filter.time.type == 'days' && filter.time.duration > 0 && filter.time.duration <= 60) {
          where_condition += " AND ot.order_date > (current_timestamp - INTERVAL "+filter.time.duration+" DAY)";
        }
        if(filter.time.type == 'year' && filter.time.duration > 0) {
          where_condition += " AND YEAR(ot.order_date) = "+filter.time.duration;
        }
        if(filter.time.type == 'older' && filter.time.duration > 0) {
          where_condition += " AND YEAR(ot.order_date) < "+filter.time.duration;
        }
      }
      if(filter.status) {
        where_condition += " AND odi.current_status = "+filter.status;
      }
  }
  
  sql.query("SELECT ot.order_id,CONCAT('OD',LPAD(ot.order_id,6,0)) as order_number,ot.sub_total,ot.delivery_charge,ot.convinience_fee,(ot.sub_total + ot.delivery_charge + ot.convinience_fee) as order_total,odi.order_details_id,pr.producer_name,pl.product_name,CONCAT('"+product_image_base+"',pit.img_path) as img_path,odi.current_status,odi.rate_per_hour as product_rate,odi.qty, odi.total as item_total,ctb.currency_type,ctb.currency FROM order_details_id odi JOIN order_tb ot ON odi.order_id = ot.order_id JOIN producer_list pr ON pr.producer_id = odi.producer_id JOIN product_list pl ON pl.product_id = odi.product_id JOIN product_img_tb as pit ON pit.product_id = odi.product_id LEFT join currency_tb ctb on ot.currency_id=ctb.cur_id "+where_condition+" ORDER BY ot.order_id DESC,odi.order_details_id ASC",(err,rows,fields)=>{
      if (err) throw err;
      if (rows.length > 0) {
          const resultdata = [];
          for(let index = 0; index < rows.length; index++) {
            const element = rows[index];
            const item = {
              order_details_id  : element.order_details_id,
              producer_name     : element.producer_name,
              product_name      : element.product_name,
              img_path          : element.img_path,
              current_status    : element.current_status,
              product_rate      : element.product_rate,
              qty               : element.qty,
              item_total        : element.item_total,
              currency_type     : element.currency_type,
              currency          : element.currency

            }
            var ind = -1;
            if(resultdata.length) {
              ind = resultdata.findIndex(item => item.order_id == element.order_id);
            }

            if(ind >= 0) {
              resultdata[ind].items.push(item);
            } else {
              resultdata.push({
                order_id        : element.order_id,
                order_number    : element.order_number,
                sub_total       : element.sub_total,
                delivery_charge : element.delivery_charge,
                convinience_fee : element.convinience_fee,
                order_total     : element.order_total,
                currency_type   : element.currency_type,
                currency        : element.currency,
                items           : [item]
              });
            }
          }

          result(null,{ status:200, orders: resultdata,total_orders : resultdata.length, msg:'Success'}); 
      }else{
          const resultdata = [];
          result(null,{ status:200, orders: resultdata, msg:'Success'}); 
      }
  })
};

module.exports = Order;