exports.ACCESS_TOKEN = {expiresIn:process.env.ACCESS_TIME_OUT,secret:process.env.ACCESS_SECRET};
exports.REFRESH_TOKEN = {expiresIn:process.env.REFRESH_TIME_OUT,secret:process.env.REFRESH_SECRET};
exports.S3_URL = process.env.S3_URL;
exports.S3_SECRET = process.env.S3_SECRET;
exports.S3_ACCESS_KEY = process.env.S3_ACCESS_KEY;
exports.S3_BUCKET = process.env.S3_BUCKET;
exports.ORDER_STATUS = {
	"1": "Ready",
	"2": "Shipped",
	"3": "Delivered",
	"6": "Canceled",
	"7": "Return Confirmed",
	"8": "Return Rejected",
	"9": "Return Shipped",
	"10": "Return Delivered",
	"11": "Replace Confirmed",
	"12": "Replace Rejected",
	"13": "Replace Shipped",
	"14": "Replace Delivered"
}