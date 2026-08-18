const sql = require("../utils/dbConnection.js");
const consts = require("../utils/constants.js");

// constructor
const Product = function(product) {
    this.producer_id = product.producer_id;
    // this.type = product.type;
    this.offset = product.offset;
  };

  Product.product_list = (producer, result) => {
    // var type = producer.type;
    var offset = producer.offset;

    var product_image_base = consts.S3_URL+'/products/';

    if(producer.producer_id == '0'){
        sql.query("select pl.product_id, producerid, product_name, product_desc, rate_per_hour, truck_name, truck_number, display_status, product_qty, CASE WHEN img_path LIKE 'http%' THEN img_path ELSE CONCAT('"+product_image_base+"',img_path) END as product_image, ctb.currency,utb.unit from product_list pl inner join product_img_tb pit ON pl.product_id=pit.product_id  inner join currency_tb ctb on pl.currency_id=ctb.cur_id inner join unit_tb utb on pl.unit_id=utb.unit_tb WHERE pl.display_status=0 order by rate_per_hour limit "+offset+",10",(err,rows,fields)=>{
        if (err) throw err;
            if (rows.length > 0) {
              
            result(null,{ status:200, product: rows, msg:'Success'}); 
            }else{
                var resultdata = {
                
                };  
                result(null,{ status:200, product: resultdata, msg:'No Products Found'}); 
            }
        })
    }else{
        sql.query("select pl.product_id, producerid, product_name, product_desc, rate_per_hour, truck_name, truck_number, display_status, product_qty, CASE WHEN img_path LIKE 'http%' THEN img_path ELSE CONCAT('"+product_image_base+"',img_path) END as product_image, ctb.currency, utb.unit from product_list pl inner join product_img_tb pit ON pl.product_id=pit.product_id inner join currency_tb ctb on pl.currency_id=ctb.cur_id inner join unit_tb utb on pl.unit_id=utb.unit_tb where producerid = "+producer.producer_id+" AND pl.display_status=0 order by rate_per_hour limit "+offset+",10",(err,rows,fields)=>{
            if (err) throw err;
            if (rows.length > 0) {
            result(null,{ status:200, product: rows, msg:'Success'}); 
            }else{
                var resultdata = {
                
                };  
                result(null,{ status:200, product: resultdata, msg:'No Products Found'}); 
            }
        })
    }

  };

  module.exports = Product;
