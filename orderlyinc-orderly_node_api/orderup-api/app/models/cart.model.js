const sql = require("../utils/dbConnection.js");
const consts = require("../utils/constants.js");

// constructor
const Cart = function(cart) {
    this.user_id = cart.user_id;
    this.producer_id = cart.producer_id;
    this.product_id = cart.product_id;
    this.rate_per_hour = cart.rate_per_hour;
    this.qty = cart.qty;
  };

  var conv_fee = '0';

  Cart.add_to_cart = (cart, result) => {
    var user_id = cart.user_id;
    // var producer_id = cart.producer_id;
    var product_id = cart.product_id;
    // var rate_per_hour = cart.rate_per_hour;
    var qty = cart.qty;
    cart.producer_id = 0;
    cart.rate_per_hour = 0;

    
    sql.query("select cart_id, user_id, product_id, rate_per_hour, qty from cart_tb  where user_id = '"+user_id+"' and product_id = "+product_id+"",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            var cart_qty = rows[0].qty;
            var cart_id = rows[0].cart_id;
            sql.query("select product_id,product_qty from product_list  where product_id = "+product_id+"",(err,rows_prod,fields)=>{
                if (err) throw err;
                if (rows_prod.length) {
                    var current_qty = rows_prod[0].product_qty;
                    cart_qty = cart_qty + 1;
                    if(current_qty >= cart_qty) {

                        sql.query("UPDATE cart_tb SET qty="+cart_qty+" WHERE cart_id="+cart_id+" AND user_id="+user_id+";",(err,res,fields)=>{

                            if (err) throw err;

                            sql.query("select ct.cart_id, ct.user_id, pl.producerid, ct.product_id, pl.rate_per_hour, ct.qty, pl.product_name, pl.product_desc, pl.truck_name, pl.truck_number,pl.img_paths,ctb.currency,utb.unit, prodtb.producer_name from cart_tb ct INNER Join product_list pl ON ct.product_id = pl.product_id  inner join currency_tb ctb on pl.currency_id=ctb.cur_id inner join unit_tb utb on pl.unit_id=utb.unit_tb  inner join producer_list prodtb on pl.producerid=prodtb.producer_id WHERE ct.cart_id = '"+cart_id+"'", function (err, recordset) {
                        
                                if (err) throw err;
        
                                sql.query("select  * from conveyance_tb ",(err,rows)=>{
                                    var sum = `${rows[0].conveyance}`;
                                    //array1.push(sum);
                                    conv_fee = sum;
        
                                    // send records as a response
                                    result(null,{ status:200, cart: recordset, conv_fee: conv_fee, msg:'Successed'});
        
                                })
                            });
    
                        });
                    }
                    else {
                        result(null,{ status:201, cart: [], msg:'Required Qty is not available'}); 
                    }


                }
                else {
                    result(null,{ status:201, cart: [], msg:'Fail'}); 
                }

            });
            // result(null,{ status:200, cart: rows, msg:'Exists'}); 
        }else{
            //Check QTY
            sql.query("select product_id,product_qty from product_list  where product_id = "+product_id+"",(err,rows_prod,fields)=>{
                if (err) throw err;
                if(rows_prod.length){
                    var current_qty = rows_prod[0].product_qty;
                    if(current_qty >= cart.qty) {
                        sql.query('INSERT INTO cart_tb SET ?', cart, (err, res) => {
                            if (err) throw err;
                            //res.send('Data Inserted'+result.insertId);  
                            var last_insert_id = res.insertId;
                            if(last_insert_id != ''){
                                sql.query("select ct.cart_id, ct.user_id, pl.producerid, ct.product_id, pl.rate_per_hour, ct.qty, pl.product_name, pl.product_desc, pl.truck_name, pl.truck_number,pl.img_paths,ctb.currency,utb.unit, prodtb.producer_name from cart_tb ct INNER Join product_list pl ON ct.product_id = pl.product_id  inner join currency_tb ctb on pl.currency_id=ctb.cur_id inner join unit_tb utb on pl.unit_id=utb.unit_tb  inner join producer_list prodtb on pl.producerid=prodtb.producer_id WHERE ct.cart_id = '"+last_insert_id+"'", function (err, recordset) {
                        
                                    if (err) throw err;
            
                                    sql.query("select  * from conveyance_tb ",(err,rows)=>{
                                        var sum = `${rows[0].conveyance}`;
                                        //array1.push(sum);
                                        conv_fee = sum;
            
                                        // send records as a response
                                        result(null,{ status:200, cart: recordset, conv_fee: conv_fee, msg:'Successed'});
            
                                    })
                                });    
                                
                            }else{
                                var resultdata = { };
                                result(null,{ status:201, cart: [], msg:'Fail'}); 
                            }
                            
                        });

                    }
                    else {
                        result(null,{ status:201, cart: [], msg:'Required Qty is not available'}); 
                    }
                }
            });
        }
    })
    

  };

  Cart.update_cart = (cart, result) => {
    var user_id = cart.user_id;
    // var producer_id = cart.producer_id;
    var cart_id = cart.cart_id;
    // var rate_per_hour = cart.rate_per_hour;
    var qty = cart.qty;
  

    //Check QTY
    sql.query("select product_id,product_qty from product_list  where product_id = (SELECT product_id FROM cart_tb WHERE cart_id="+cart_id+" LIMIT 1)",(err,rows_prod,fields)=>{
        if(rows_prod.length){
            var current_qty = rows_prod[0].product_qty;
            if(current_qty >= cart.qty) {
                sql.query("UPDATE cart_tb SET qty="+qty+" WHERE cart_id="+cart_id+" AND user_id="+user_id+";",(err,res,fields)=>{
                    if (err) throw err;
                    if (res.changedRows > 0) {
                        sql.query("select ct.cart_id, ct.user_id, pl.producerid, ct.product_id, pl.rate_per_hour, ct.qty, pl.product_name, pl.product_desc, pl.truck_name, pl.truck_number,pl.img_paths,ctb.currency,utb.unit, prodtb.producer_name from cart_tb ct INNER Join product_list pl ON ct.product_id = pl.product_id  inner join currency_tb ctb on pl.currency_id=ctb.cur_id inner join unit_tb utb on pl.unit_id=utb.unit_tb  inner join producer_list prodtb on pl.producerid=prodtb.producer_id WHERE ct.cart_id = '"+cart_id+"'", function (err, recordset) {
                        
                            if (err) console.log(err)
            
                            sql.query("select  * from conveyance_tb ",(err,rows)=>{
                                var sum = `${rows[0].conveyance}`;
                                //array1.push(sum);
                                conv_fee = sum;
            
                                // send records as a response
                                result(null,{ status:200, cart: recordset, conv_fee: conv_fee, msg:'Successed'});
            
                            })
                        }); 
                    }else{
                        result(null,{ status:201, cart: {}, msg:'Cart not found'}); 
                        
                    }
                })
            }
            else {
                result(null,{ status:201, cart: [], msg:'Required Qty is not available'}); 
            }
        }
    });
    

  };


  Cart.view_cart = (cart, result) => {

    var user_id = cart.user_id;
    var product_image_base = consts.S3_URL+'/products/';
    var cust_lat = cart.cust_lat;
    var cust_long = cart.cust_long;
    var avail_query = ",0 AS available_on_address";
    var avail_cond = "";

    if(cust_lat && cust_long)
    {

        avail_query = ",CASE WHEN((ST_Distance_Sphere(point("+cust_long+","+cust_lat+"),point(store_user.longitude,store_user.latitude))/1000) <= distance) THEN 1 ELSE 0 END AS available_on_address";
        avail_cond = " JOIN producer_list store ON store.producer_id = pl.producerid JOIN users_tb store_user ON store_user.user_id = store.producer_id";


    }

    sql.query("select ct.cart_id, ct.user_id, pl.producerid, ct.product_id, pl.rate_per_hour, ct.qty, pl.product_name, pl.product_desc, pl.truck_name, pl.truck_number,CONCAT('"+product_image_base+"',pit.img_path) as img_paths,ctb.currency,utb.unit"+avail_query+",pl.product_qty as available_qty from cart_tb ct INNER Join product_list pl ON ct.product_id = pl.product_id inner join product_img_tb pit ON pl.product_id=pit.product_id join currency_tb ctb on pl.currency_id=ctb.cur_id join unit_tb utb on pl.unit_id=utb.unit_tb "+avail_cond+" WHERE ct.user_id = '"+user_id+"' ",(err,rows,fields)=>{
        if (err) throw err;
        if (rows.length > 0) {
            sql.query("select  * from conveyance_tb ",(err,recordset)=>{
                var conv_fee = 0;
                if(recordset.length) {
                    var conv_fee = `${recordset[0].conveyance}`;
                }
                result(null,{ status:200, cart: rows,conv_fee: conv_fee, msg:'Success'}); 
            })
        }else{
            var resultdata = { };
            sql.query("select  * from conveyance_tb ",(err,recordset)=>{
                var conv_fee = 0;
                if(recordset.length) {
                    var conv_fee = `${recordset[0].conveyance}`;
                }
                result(null,{ status:200, cart: resultdata,conv_fee: conv_fee, msg:'Success'}); 
            })
        }
    })
  };

    Cart.delete_cart = (cart, result) => {

        var cart_id = cart.cart_id;
        var user_id = cart.user_id;

        sql.query("delete from cart_tb WHERE user_id = '"+user_id+"' AND cart_id = '"+cart_id+"' ",(err,rows,fields)=>{
            if (err) throw err;
            if (rows.length > 0) {
                result(null,{ status:200, cart: rows, msg:'Success'}); 
            } else{
                var resultdata = { };
                result(null,{ status:200, cart: resultdata, msg:'Success'}); 
            }
        })
    };

  module.exports = Cart;