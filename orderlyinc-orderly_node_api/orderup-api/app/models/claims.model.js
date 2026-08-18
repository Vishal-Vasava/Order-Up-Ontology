const { json } = require("body-parser");
const sql = require("../utils/dbConnection.js");

// constructor
const Claims = function(claim) {
    //this.producer_id = claim.producer_id;
    //this.claim_type = claim.claim_type;
  };

  var rec_sum = '0';
  var refd_sum = '0';
  

  Claims.fetch_claims_details = (claim, result) => {
    var producer_id = claim.producer_id;
    var claim_type = claim.claim_type;

    

    if(claim_type == 1){
      sql.query("select order_details_id, odi.order_id, CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number, qty, img_paths, total, date_time as order_date, current_status,otb.full_dest_address from order_details_id odi JOIN order_tb otb ON otb.order_id=odi.order_id  WHERE producer_id = '"+producer_id+"' and (current_status = 3 || current_status = 10 || current_status = 14) ORDER BY order_details_id DESC", function (err, recordset) {
          if (err) console.log(err)
          var array = [];
          for (let i = 0; i < recordset.length; i++) {

            const od_dt = `${recordset[i].order_date}`;
            var value = od_dt.substr(4, 11);
            try {
              
              var customer_details = JSON.parse(recordset[i].full_dest_address);
            } catch (error) {
              var customer_details = null;
            }

            var resultdata = {
              order_details_id: `${recordset[i].order_details_id}`,
              order_id: `${recordset[i].order_id}`,
              order_number: `${recordset[i].order_number}`,
              qty: `${recordset[i].qty}`,
              total: `${recordset[i].total}`,
              img_paths: `${recordset[i].img_paths}`,
              order_date: value,
              current_status: `${recordset[i].current_status}`,
              customer_details : customer_details
            };
            array.push(resultdata);
          }
          
          sql.query("select  sum(total) as receive_amount from order_details_id  WHERE producer_id = '"+producer_id+"' and (current_status = 3 || current_status = 10 || current_status = 14) ORDER BY order_details_id DESC",(err,rows)=>{
           
            var sum = `${rows[0].receive_amount}`;

           

            var finaldata = {
              received_amount: sum,
              refunded_amount: 0,
              claim_data: array
            };
  
            // send records as a response
            result(null,{ status:200, claim_details: finaldata, msg:'Successed'}); 
            
          })
          
          
      });   
    }else if(claim_type == 2){
      sql.query("select order_details_id, odi.order_id, CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number, qty, img_paths, total, date_time as order_date, current_status,otb.full_dest_address from order_details_id odi JOIN order_tb otb ON otb.order_id=odi.order_id  WHERE producer_id = '"+producer_id+"' and (current_status = 6 || current_status = 8 || current_status = 12) ORDER BY order_details_id DESC", function (err, recordset) {
          if (err) console.log(err)
          var array = [];
          for (let i = 0; i < recordset.length; i++) {

            const od_dt = `${recordset[i].order_date}`;
            var value = od_dt.substr(4, 11);
            try {
              
              var customer_details = JSON.parse(recordset[i].full_dest_address);
            } catch (error) {
              var customer_details = null;
            }

            var resultdata = {
              order_details_id: `${recordset[i].order_details_id}`,
              order_id: `${recordset[i].order_id}`,
              order_number: `${recordset[i].order_number}`,
              qty: `${recordset[i].qty}`,
              total: `${recordset[i].total}`,
              img_paths: `${recordset[i].img_paths}`,
              order_date: value,
              current_status: `${recordset[i].current_status}`,
              customer_details : customer_details
            };
            array.push(resultdata);
          }
          
          sql.query("select  sum(total) as receive_amount from order_details_id  WHERE producer_id = '"+producer_id+"' and (current_status = 6 || current_status = 8 || current_status = 12) ",(err,rows)=>{
          
            var sum = `${rows[0].receive_amount}`;

            var finaldata = {
              received_amount: 0,
              refunded_amount: sum,
              claim_data: array
            };

            // send records as a response
            result(null,{ status:200, claim_details: finaldata, msg:'Successed'}); 
            
          })
          
          
      });   
    }else{
      sql.query("select order_details_id, odi.order_id, CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number, qty, img_paths, total, date_time as order_date, current_status,otb.full_dest_address from order_details_id odi JOIN order_tb otb ON otb.order_id=odi.order_id  WHERE producer_id = '"+producer_id+"' and (current_status = 4 || current_status = 6 || current_status = 8 || current_status = 12) ORDER BY order_details_id DESC", function (err, recordset) {
          if (err) console.log(err)
          var array = [];

          var date = require('date-and-time');

          for (let i = 0; i < recordset.length; i++) {

            const od_dt = `${recordset[i].order_date}`;
            var value = od_dt.substr(4, 11);
            try {
              
              var customer_details = JSON.parse(recordset[i].full_dest_address);
            } catch (error) {
              var customer_details = null;
            }
            //const now  =  new Date();
            //const dt = date.parse(od_dt, 'DD/MM/YYYY');
            //var value = date.format(od_dt,'DD/MM/YYYY');

            var resultdata = {
              order_details_id: `${recordset[i].order_details_id}`,
              order_id: `${recordset[i].order_id}`,
              order_number: `${recordset[i].order_number}`,
              qty: `${recordset[i].qty}`,
              total: `${recordset[i].total}`,
              img_paths: `${recordset[i].img_paths}`,
              order_date: value,
              current_status: `${recordset[i].current_status}`,
              customer_details : customer_details
            };
            array.push(resultdata);
          }
          
          

          var array1 = [];
          sql.query("select  sum(total) as receive_amount from order_details_id  WHERE producer_id = '"+producer_id+"' and current_status = 4 ",(err,rows)=>{
            var sum = `${rows[0].receive_amount}`;
            //array1.push(sum);
            rec_sum = sum;
          })

          var array2 = [];
          sql.query("select  sum(total) as receive_amount from order_details_id  WHERE producer_id = '"+producer_id+"' and (current_status = 10 || current_status = 14) ",(err,rows)=>{
            var sum = `${rows[0].receive_amount}`;
            //var refundsum = `10`;
            //array2.push(refundsum); 
            refd_sum = sum;
          })

          var finaldata = {
            received_amount: rec_sum,
            refunded_amount: refd_sum,
            claim_data: array
          };

          // send records as a response
          result(null,{ status:200, claim_details: finaldata, msg:'Successed'}); 
          
          
      });    
    }
      
    

  };

  Claims.claims_details = (claim, result) => {
    var producer_id = claim.producer_id;
    var claim_query = "SELECT order_details_id, odi.order_id, CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number, qty, total, date_time as order_date, current_status,otb.full_dest_address,odi.pay_status from order_details_id odi JOIN order_tb otb ON otb.order_id=odi.order_id  WHERE producer_id = '"+producer_id+"' AND current_status = 3 ORDER BY order_details_id DESC";
    sql.query(claim_query,(err,rows)=>{
      if(err) throw err;
      if(rows.length) {
        var order_details = [];
        var pending_amount = 0;
        var paid_amount = 0;
        var current_amount = 0;
        var total_amount = 0;
        for (let index = 0; index < rows.length; index++) {
          var element = rows[index];
          try {
              
            var customer_details = JSON.parse(element.full_dest_address);
          } catch (error) {
            var customer_details = null;
          }
          element.customer_details = customer_details;
          order_details.push(element);
          var current_amount = element.total;
          if(element.pay_status == 1) {
            paid_amount += current_amount;
          } else {
            pending_amount += current_amount;
          }
          if(index == (rows.length -1 )) {
            total_amount = paid_amount + pending_amount;
            var claim_details = {
              order_details : order_details,
              paid_amount : paid_amount,
              pending_amount : pending_amount,
              total_amount : total_amount

            }
            result(null,{ status:200, claim_details : claim_details, msg:'Successed'}); 
          }
        }
      } else {
        var claim_details = {
          order_details : [],
          paid_amount : 0,
          pending_amount : 0,
          total_amount : 0

        }
        result(null,{ status:200, claim_details : claim_details, msg:'Successed'}); 
      }
    });
  };

  module.exports = Claims;