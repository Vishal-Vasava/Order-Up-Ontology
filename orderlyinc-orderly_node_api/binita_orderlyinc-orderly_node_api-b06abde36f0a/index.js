var express = require('express');  //load express module to crate instance of app
require('dotenv').config()
const multer = require('multer');

var app = express();
const path = require('path');

// Allow the local admin portal to call the API during development.
app.use((req, res, next) => {
    const origin = req.headers.origin;
    const allowedOrigins = [
        'http://localhost:3000',
        'http://127.0.0.1:3000',
        'http://localhost:3002',
        'http://127.0.0.1:3002',
        process.env.CORS_ORIGIN
    ].filter(Boolean);

    if (origin && allowedOrigins.includes(origin)) {
        res.header('Access-Control-Allow-Origin', origin);
        res.header('Vary', 'Origin');
        res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
        res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS');
    }

    if (req.method === 'OPTIONS') return res.sendStatus(204);
    next();
});

// Keep local product images behind the same CORS policy as the API so
// Flutter Web can render them from its separate development origin.
app.use('/product-images', express.static(path.join(__dirname, 'public', 'product-images')));

const { check } = require('express-validator');

const auth = require('./app/middleware/auth.js');
// for parsing application/json
app.use(express.json()); 

// for parsing application/x-www-form-urlencoded
// app.use(express.urlencoded({ extended: true })); 



// for parsing multipart/form-data
// app.use(upload.array()); 
// app.use(express.static('public'));


//body parsing middleware, does not support multi-part, you have to use other module for multi-part parsing.
// var bodyParser = require('body-parser');
// app.use(bodyParser.json());

//PORT
const port = process.env.PORT || 3000;
//app.listen(3000,()=>console.log('Express server is running at port no : 3000'));
if(process.env.APP_ENV == 'production' || process.env.APP_ENV == 'live' ) {

    const https = require("https"),fs = require("fs");
    
    const sslServer =  https.createServer (
    {
      key: fs.readFileSync('./cert_directory/privkey.pem'),
      cert: fs.readFileSync('./cert_directory/fullchain.pem'),
    },
    app
    )
    sslServer.listen(port, () => {
        // console.log(`Express running PORT 3000 working!`)
    });

}
else {

    app.listen(port,()=>console.log(`Express server is running at port no : ${port}`));
}

var aws = require('aws-sdk');
var multerS3 = require('multer-s3');

const sql1 = require("./app/utils/dbConnection.js");
const e = require('express');

//var admin = require("firebase-admin");
// IOT
require("./app/routes/temperature.routes.js")(app,check);



//register routes
require("./app/routes/register.routes.js")(app,check);

//login routes
require("./app/routes/login.routes.js")(app,check);

app.use(auth);
//producer routes
require("./app/routes/producer.routes.js")(app,check);


//product list against producer routes
require("./app/routes/products.routes.js")(app,check);

//add to cart 
require("./app/routes/cart.routes.js")(app,check);

//order
require("./app/routes/order.routes.js")(app,check);

//inventory
require("./app/routes/inventory.routes.js")(app,check);

//profile
require("./app/routes/profile.routes.js")(app,check);

//claims
require("./app/routes/claims.routes.js")(app,check);

//read-only ontology-backed semantic context
require("./app/routes/semantic.routes.js")(app);

//bounded customer-to-store negotiation (pricing remains deterministic)
require("./app/routes/negotiation.routes.js")(app);

//platform manager (admin portal) - route-level requireAdmin gate, see admin.routes.js
require("./app/routes/admin.routes.js")(app,check);


/*
// Image Upload
const imageStorage = multer.diskStorage({
    destination: 'public/images', // Destination to store image 
    filename: (req, file, cb) => {
        cb(null, file.fieldname + '_' + Date.now() + path.extname(file.originalname))
        // file.fieldname is name of the field (image), path.extname get the uploaded file extension
    }
});

const imageUpload = multer({
    storage: imageStorage,
    limits: {
        fileSize: 1000000   // 1000000 Bytes = 1 MB
    },
    fileFilter(req, file, cb) {
        if (!file.originalname.match(/\.(png|jpg)$/)) {     // upload only png and jpg format
            return cb(new Error('Please upload a Image'))
        }
        cb(undefined, true)
    }
}) */

const consts = require('./app/utils/constants.js');

var s3 = new aws.S3({
    accessKeyId: consts.S3_ACCESS_KEY,
    secretAccessKey: consts.S3_SECRET,
    bucket: consts.S3_BUCKET
 });

 var imageUpload = multer({
    storage: multerS3({
        s3: s3,
        acl: "public-read",
        dirname: 'profile/',
        bucket: consts.S3_BUCKET,
        key: function (req, file, cb) {
            //console.log(file);
            cb(null, `profile/`+file.originalname)
            //cb(null, Date.now().toString())file.originalname
        }
    })
 });

app.post('/uploadImage', imageUpload.single('image'), (req, res) => {
    //res.send(req.file.originalname)
     var profile_image = `${consts.S3_URL}/profile/`+req.file.originalname;
     var fb_id = req.body.fb_id;
    //res.send(profile_image)
    
    sql1.query("Update users_tb SET profile_pic = '"+profile_image+"' Where fb_id = '"+fb_id+"'", (err, res) => {
                
    });
    //res(null,{ status:200, fb_id: fb_id, msg:'Successed'});   
    res.status(200).send({ profile_pic: profile_image, msg: 'Successed' })
}, (error, req, res, next) => {
    res.status(400).send({ error: error.message })
    //var fb_id = '';
   // res(null,{ status:200, fb_id: fb_id, msg:'Successed'});   
})
