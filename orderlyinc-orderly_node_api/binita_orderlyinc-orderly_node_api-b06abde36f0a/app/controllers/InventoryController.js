const Inventory = require('../models/inventory.model.js');
const upload = require("../services/ImageUpload");
const singleUpload = upload.single("image");
const { validationResult } = require('express-validator');
const fs = require('fs');
const path = require('path');
const OpenAI = require('openai');
const sql = require('../utils/dbConnection.js');



 // fetch inventory details
 exports.view_inventory = (req, res) => {

     // Validate request
     if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
    
    // fetch from products
    var inventory = {
      producer_id : req.producer_id
    };

    Inventory.view_inventory(inventory, (err, data) => {
      if (err)
        res.status(500).send({
          message:
            err.message || "Some error occurred while fetching products"
        });
      else res.send(data);
    });
};  

// Compatibility response for the newer Flutter store-manager client.
exports.view_inventory_modern = (req, res) => {
  const inventory = { producer_id: req.producer_id };

  Inventory.view_inventory(inventory, (err, data) => {
    if (err) {
      return res.status(500).send({
        statusCode: 500,
        message: err.message || 'Some error occurred while fetching products'
      });
    }

    const rows = Array.isArray(data.inventory) ? data.inventory : [];
    const now = new Date(0).toISOString();
    const products = rows.map((row) => ({
      _id: String(row.product_id),
      id: String(row.product_id),
      name: row.product_name,
      desc: row.product_desc || '',
      image: row.raw_img_path && /^https?:\/\//.test(row.raw_img_path) ? row.raw_img_path : (row.img_paths || ''),
      image_url: row.raw_img_path && /^https?:\/\//.test(row.raw_img_path) ? row.raw_img_path : (row.img_paths || ''),
      price: Number(row.rate_per_hour || 0),
      qty: Number(row.product_qty || 0),
      visible: Number(row.display_status) === 0,
      deleted: Number(row.display_status) !== 0,
      _currency: {
        _id: '',
        name: row.currency_type || 'US Dollar',
        locale: 'en_US',
        code: row.currency || 'USD'
      },
      _producer: {
        _id: String(req.producer_id || ''),
        name: row.producer_name || '',
        desc: '',
        icon_url: '',
        banner_url: ''
      },
      _creator: '',
      createdAt: now,
      updatedAt: now,
      unit: row.unit || '',
      _returnPolicy: null,
      _estimatedPickup: null,
      _filters: []
    }));

    return res.send({
      statusCode: 200,
      data: { data: products, next_cursor: '' },
      msg: 'Success'
    });
  });
};

// Product listing for customers uses the selected store id rather than the
// store id carried by a producer token, but shares the same response model.
exports.customer_products_modern = (req, res) => {
  const storeId = Number(req.body && req.body.store_id);
  if (!storeId) {
    return res.status(400).send({
      statusCode: 400,
      message: 'Store id is required'
    });
  }

  req.producer_id = storeId;
  return exports.view_inventory_modern(req, res);
};

exports.generate_product_image = async (req, res) => {
  const productId = Number(req.body && req.body.product_id);
  const name = String((req.body && req.body.name) || '').trim();
  const description = String((req.body && req.body.description) || '').trim();

  if (!productId || !name) {
    return res.status(400).send({ statusCode: 400, message: 'Product id and name are required' });
  }
  if (!process.env.OPENAI_API_KEY) {
    return res.status(503).send({ statusCode: 503, message: 'Image generation is not configured' });
  }

  try {
    const ownsProduct = await new Promise((resolve, reject) => {
      sql.query(
        `SELECT p.product_id
           FROM product_list p
           LEFT JOIN users_tb u ON u.user_id = ?
          WHERE p.product_id = ?
            AND (p.producerid = ? OR p.producerid = u.producerid)
          LIMIT 1`,
        [req.user_id, productId, req.producer_id],
        (err, rows) => err ? reject(err) : resolve(rows.length > 0)
      );
    });
    if (!ownsProduct) {
      return res.status(404).send({
        statusCode: 404,
        code: 'PRODUCT_STORE_MISMATCH',
        message: 'This product is not assigned to the signed-in store manager'
      });
    }

    const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const result = await client.images.generate({
      model: process.env.OPENAI_IMAGE_MODEL || 'gpt-image-2',
      prompt: `Create a clean ecommerce catalog product photo of ${name}. ${description}. Single product centered, realistic studio lighting, pure white background, no text, no logo, no watermark, square composition.`,
      size: '1024x1024',
      quality: 'medium'
    });
    const base64 = result.data && result.data[0] && result.data[0].b64_json;
    if (!base64) throw new Error('The image service returned no image data');

    const outputDir = path.join(__dirname, '..', '..', 'public', 'product-images');
    await fs.promises.mkdir(outputDir, { recursive: true });
    const filename = `product-${productId}-${Date.now()}.png`;
    await fs.promises.writeFile(path.join(outputDir, filename), Buffer.from(base64, 'base64'));
    const imageUrl = `${req.protocol}://${req.get('host')}/product-images/${filename}`;

    await new Promise((resolve, reject) => {
      sql.query(
        'SELECT img_id FROM product_img_tb WHERE product_id = ? ORDER BY img_id LIMIT 1',
        [productId],
        (selectError, rows) => {
          if (selectError) return reject(selectError);
          const query = rows.length
            ? 'UPDATE product_img_tb SET img_path = ?, img_name = ? WHERE img_id = ?'
            : 'INSERT INTO product_img_tb (img_path, img_name, product_id) VALUES (?, ?, ?)';
          const params = rows.length
            ? [imageUrl, filename, rows[0].img_id]
            : [imageUrl, filename, productId];
          sql.query(query, params, (writeError) => writeError ? reject(writeError) : resolve());
        }
      );
    });

    return res.send({ statusCode: 200, data: { image_url: imageUrl }, msg: 'Image generated' });
  } catch (error) {
    const upstreamStatus = Number(error.status) || 500;
    const safeStatus = upstreamStatus >= 400 && upstreamStatus < 600 ? upstreamStatus : 500;
    return res.status(safeStatus).send({
      statusCode: safeStatus,
      code: error.code || 'IMAGE_GENERATION_FAILED',
      message: error.message || 'Could not generate product image'
    });
  }
};

// delete inventory
exports.remove_inventory = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
 // Inventory
 var inventory = {
  product_id : req.body.product_id
 };

 Inventory.remove_inventory(inventory, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching user address"
     });
   else res.send(data);
 });

}; 


 // save inventory details
 exports.add_inventory = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 //Upload s3
 try{

   singleUpload(req, res, function (err) {
  //   console.log(res);
    if (err) {
      return res.status(400).json({
        success: false,
        errors: {
          title: "Image Upload Error",
          detail: err.message,
          error: err,
        },
      });
    }
    else {
      if(req.file) {
        var file_path = req.file.key;
        file_path = file_path.replace('products/', '')
         var inventory = {
            producerid : req.producer_id,
            product_name : req.body.product_name,
            product_desc : req.body.product_desc,
            rate_per_hour : req.body.rate_per_hour,
            product_qty : req.body.product_qty,
            file_img : file_path,
            file_img_name : req.file.originalname,
            img_paths : req.file.location
        };
        
        Inventory.add_inventory(inventory, (err, data) => {
          
          if (err)
            res.status(500).send({
              message:
                err.message || "Some error occurred while fetching products"
            });
          else res.send(data);
        });
  

      }
      else {
        return res.status(400).json({
          success: false,
          errors: {
            title: "Image Upload Error",
            detail: 'Please provide image',
            // error: err,
          },
        });
      }

    }
  });
 } catch(ex) {
  return res.status(400).json({
    success: false,
    errors: {
      title: "Image Upload Error",
      detail: "File not uplaoded",
      error: ex,
    },
  });
 }
 
};
  

exports.update_inventory = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 //Upload s3
 try{

   singleUpload(req, res, function (err) {
  //   console.log(res);
    if (err) {
      return res.status(400).json({
        success: false,
        errors: {
          title: "Image Upload Error",
          detail: err.message,
          error: err,
        },
      });
    }
    else {
      var file_path = file_img_name = img_paths = null;
      var is_img_uploaded = false;
      if(req.file) {
        file_path = req.file.key;
        file_img_name = req.file.originalname;
        img_paths = req.file.location;
        file_path = file_path.replace('products/', '');
        is_img_uploaded = true;
      }
      var inventory = {
        product_id : req.body.product_id,
        producerid : req.producer_id,
        product_name : req.body.product_name,
        product_desc : req.body.product_desc,
        rate_per_hour : req.body.rate_per_hour,
        product_qty : req.body.product_qty,
        file_img : file_path,
        file_img_name : file_img_name,
        img_paths : img_paths,
        is_img_uploaded : is_img_uploaded
    };
        
        Inventory.update_inventory(inventory, (err, data) => {
   
          if (err)
            res.status(500).send({
              message:
                err.message || "Some error occurred while fetching products"
            });
          else res.send(data);
        });
  

      
      

    }
  });
 } catch(ex) {
  return res.status(400).json({
    success: false,
    errors: {
      title: "Image Upload Error",
      detail: "File not uplaoded",
      error: ex,
    },
  });
 }
 
};


// update inventory details
exports.update_inventory_old = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
  
 // fetch from products
 var inventory = {
    product_id : req.body.product_id,
    product_name : req.body.product_name,
    product_desc : req.body.product_desc,
    rate_per_hour : req.body.rate_per_hour,
    product_qty : req.body.product_qty
 };
 
 Inventory.update_inventory(inventory, (err, data) => {
   
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching products"
     });
   else res.send(data);
 });
};  




 // save inventory details
 exports.add_inventory_new = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }
 
  
 // fetch from products
 var inventory = {
    producerid : req.body.producerid,
    product_name : req.body.product_name,
    product_desc : req.body.product_desc,
    rate_per_hour : req.body.rate_per_hour,
    product_qty : req.body.product_qty,
    img_paths : req.file.img_paths
 };
 
 Inventory.add_inventory_new(inventory, (err, data) => {
   
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching products"
     });
   else res.send(data);
 });

 
};

// fetch inventory details
exports.sku_gallery = (req, res) => {

  // Validate request
  if (!req.body) {
   res.status(400).send({
     message: "Content can not be empty!"
   });
 }

 const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
 
 // fetch from products
 var inventory = {
   search_query : req.body.search
 };

 Inventory.sku_gallery(inventory, (err, data) => {
   if (err)
     res.status(500).send({
       message:
         err.message || "Some error occurred while fetching products"
     });
   else res.send(data);
 });
}; 
