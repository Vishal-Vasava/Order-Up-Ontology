const jwt = require('jsonwebtoken');
const consts = require("../utils/constants.js");
const sql = require("../utils/dbConnection.js");

module.exports = (req, res, next) => {
    try {
        if(!req.headers.authorization || !req.headers.authorization.startsWith('Bearer') || !req.headers.authorization.split(' ')[1])
        {
            return res.status(422).json({
                message: "Please provide the token",
            });
        }
        // const token = req.header("x-auth-token");
        // if (!token) return res.status(403).send("Access denied.");
        const token = req.headers.authorization.split(' ')[1];
        const decoded_token = jwt.verify(token, consts.ACCESS_TOKEN.secret);
        var check_id =decoded_token.id;

        //Check user status 
        sql.query('select user_id from users_tb where status = 0 AND user_id = ?',[check_id],(err,rows,fields)=>{
            if(err) {
                return res.status(400).json({
                    message: "Invalid Token",
                });
            }
            if(rows.length) {

                req.user_id = decoded_token.id;
                req.producer_id = 0;
                if(decoded_token.type) {
                    req.user_type = decoded_token.type;
                }
                else {
                    req.user_type = 0;
                }
                if(decoded_token.fcm_id) {
                    req.fcm_id = decoded_token.fcm_id;
                }
                else {
                    req.fcm_id = '';
                }
                if(decoded_token.type && decoded_token.type == '1' && decoded_token.producer_id && decoded_token.producer_id > 0) {
                    req.producer_id = decoded_token.producer_id;
                }
                next();
            } else {
                return res.status(400).json({
                    message: "Invalid Token",
                });
            }

        });
    } catch (error) {
        res.status(400).json({
            message: "Invalid Token",
        });
    }
};