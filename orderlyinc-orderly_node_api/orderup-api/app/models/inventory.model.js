const sql = require("../utils/dbConnection.js");
const consts = require("../utils/constants.js");

// constructor
const Inventory = function(inventory) {
    this.producer_id = inventory.producer_id;
  };

    Inventory.view_inventory = (inventory, result) => {

        var producer_id = inventory.producer_id;
        var product_image_base = consts.S3_URL+'/products/';

        sql.query("select pt.product_id, pl.producer_name, pt.product_name, pt.product_desc, pt.rate_per_hour, pt.truck_name, pt.truck_number, pt.display_status, pt.product_qty, pit.img_path as raw_img_path, CASE WHEN pit.img_path LIKE 'http%' THEN pit.img_path ELSE CONCAT('"+product_image_base+"',pit.img_path) END as img_paths,ctb.currency_type,ctb.currency,utb.unit  from product_list pt INNER Join producer_list pl ON pt.producerid = pl.producer_id left join product_img_tb pit ON pt.product_id=pit.product_id LEFT join currency_tb ctb on pt.currency_id=ctb.cur_id LEFT join unit_tb utb on pt.unit_id=utb.unit_tb WHERE pt.producerid = '"+producer_id+"' and pt.display_status = 0 ORDER BY product_id DESC",(err,rows,fields)=>{
            if (err) throw err;
            if (rows.length > 0) {
                result(null,{ status:200, inventory: rows, msg:'Success'}); 
            }else{
                var resultdata = { };
                result(null,{ status:200, inventory: resultdata, msg:'Success'}); 
            }
        })
    };

    Inventory.remove_inventory = (inventory, result) => {
        var product_id = inventory.product_id;
        var status = 1;
        
        
        sql.query("Update product_list SET display_status = '"+status+"' Where product_id = '"+product_id+"'", (err, res) => {
            if (err) throw err;
            var resid = res.changedRows;
            result(null,{ status:200, inventory: resid, msg:'Successed'});  
        });
      };

    Inventory.add_inventory = (inventory, result) => {
        
        
        var inventory_data = {
            producerid : inventory.producerid,
            product_name : inventory.product_name,
            product_desc : inventory.product_desc,
            rate_per_hour : inventory.rate_per_hour,
            product_qty : inventory.product_qty
         };
            
        sql.query('INSERT INTO product_list SET ?', inventory_data, (err, res) => {
            //function(err, result) {
            if (err) throw err;
            //res.send('Data Inserted'+result.insertId); 
            var last_insert_id = res.insertId;
            if(last_insert_id != ''){
                var product_image = {
                    product_id : last_insert_id,
                    img_path : inventory.file_img,
                    img_name : inventory.file_img_name,
                 }
                sql.query('INSERT INTO product_img_tb SET ?', product_image, (err, res1) => {
                    if(res1.insertId) {

                        result(null,{ status:200, product: inventory, msg:'Success'});
                    }
                    else {
                        result(null,{ status:200, product: inventory, msg:'Product added but image not uploaded'});
                    }
                });
            }else{
                var resultdata = {
                    
                };
                result(null,{ status:201, product: resultdata, msg:'Fail'}); 
            }
        });            
                
            
    };  


    Inventory.update_inventory = (inventory, result) => {
        var product_id = inventory.product_id;
        var product_name = inventory.product_name;
        var product_desc = inventory.product_desc;
        var rate_per_hour = inventory.rate_per_hour;
        var product_qty = inventory.product_qty;


        var product_image_base = consts.S3_URL+'/products/';
        
        sql.query("Update product_list SET product_name = '"+product_name+"', product_desc = '"+product_desc+"', rate_per_hour = '"+rate_per_hour+"', product_qty = '"+product_qty+"' Where product_id = '"+product_id+"'", (err, res) => {
            if (err) throw err;
            var resid = res.changedRows;
            if(inventory.is_img_uploaded) {
                sql.query("select img_path  from product_img_tb WHERE product_id = '"+product_id+"' ",(err,rows,fields)=>{
                    if (rows.length > 0) {

                        var product_image = {
                            img_path : inventory.file_img,
                            img_name : inventory.file_img_name,
                         }
                         sql.query("Update product_img_tb SET img_path = '"+product_image.img_path+"', img_name = '"+product_image.img_name+"' Where product_id = '"+product_id+"'", (err1, res1) => {
        
                         });
                    }
                    else {
                        var product_image = {
                            product_id : product_id,
                            img_path : inventory.file_img,
                            img_name : inventory.file_img_name,
                         }
                        sql.query('INSERT INTO product_img_tb SET ?', product_image, (err, res1) => {

                        });
                    }

                });
            }
            result(null,{ status:200, product: resid, msg:'Successed'});  
        });

    };
    
    Inventory.sku_gallery = (inventory, result) => {

        var product_image_base = consts.S3_URL+'/products/sku/';
        var search_query = inventory.search_query;

        sql.query("select id,CONCAT('"+product_image_base+"',image_path) as image,title,description FROM product_gallery_mains WHERE title like '%"+search_query+"%';",(err,rows,fields)=>{
            if (err) throw err;
            result(null,{ status:200, sku_gallery: rows, msg:'Success'}); 
            
        })
    };

  module.exports = Inventory;
