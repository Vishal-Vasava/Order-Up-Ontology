const sql = require("../utils/dbConnection.js");

// constructor
  const Producer = function(producer) {
    this.cust_lat = producer.cust_lat;
    this.cust_long = producer.cust_long;
  };

  var conv_fee = '0';

  Producer.list = (producer, result) => {
    var cust_lat = producer.cust_lat;
    var cust_long = producer.cust_long;
      try {
        sql.query("SELECT x.distance, x.dist, x.user_id, x.first_name, x.user_type, x.producerid, pl.producer_id, pl.producer_name, pl.producer_image_url, pl.producer_icon_url,pl.prod_desc from (SELECT *, (ST_Distance_Sphere(point("+cust_long+","+cust_lat+"),point(longitude,latitude))/1000) as dist FROM `users_tb`) as x INNER JOIN producer_list pl ON x.producerid = pl.producer_id WHERE x.dist <= distance and  x.user_type=1",(err,rows)=>{
        if (err) return result(null,{ status:200, producer: {}, conv_fee: "", msg:'Fail'});
          if (rows.length > 0) {
              sql.query("select  * from conveyance_tb ",(err,recordset)=>{
                var sum = `${recordset[0].conveyance}`;
                //array1.push(sum);
                conv_fee = sum;
  
                // send records as a response
                result(null,{ status:200, producer: rows, conv_fee: conv_fee, msg:'Success'}); 
  
            })
            
          }else{
             conv_fee = '';
              var resultdata = {
               
              };  
              result(null,{ status:204, producer: resultdata, conv_fee: conv_fee, msg:'No result found'}); 
          }
      })
      } catch (error) {
        conv_fee = '';
        var resultdata = {
          
        }; 
        result(null,{ status:200, producer: resultdata, conv_fee: conv_fee, msg:'Fail'}); 
      }
  };

  module.exports = Producer;