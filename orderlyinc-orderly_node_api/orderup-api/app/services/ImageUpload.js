const aws = require("aws-sdk");
const multer = require("multer");
const multerS3 = require("multer-s3");
const consts = require("../utils/constants.js");


aws.config.update({
  secretAccessKey: consts.S3_SECRET,
  accessKeyId: consts.S3_ACCESS_KEY,
  region: "ap-south-1",
});

const s3 = new aws.S3();
const fileFilter = (req, file, cb) => {
  if (file.mimetype === "image/jpeg" || file.mimetype === "image/png") {
    cb(null, true);
  } else {
    cb(new Error("Invalid file type, only JPEG and PNG is allowed!"), false);
  }
};

const upload = multer({
  fileFilter,
  storage: multerS3({
    acl: "public-read",
    s3,
    bucket: consts.S3_BUCKET,
    contentType:multerS3.AUTO_CONTENT_TYPE,
    key: function (req, file, cb) {
      if(file.mimetype === "image/png" ) {
        var img_extenstion = '.png';
      }
      else {
        var img_extenstion = '.jpg';
      }
      var dir = 'products';
      if (req.upload_type) {
        dir = req.upload_type;
      }
      cb(null, dir+'/'+Date.now().toString()+img_extenstion);
    },
  }),
});

module.exports = upload;