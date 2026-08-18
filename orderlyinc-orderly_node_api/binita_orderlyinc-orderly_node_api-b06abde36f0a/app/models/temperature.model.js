const sql = require("../utils/dbConnection.js");

// constructor
const Temperature = function() {};

Temperature.add_temperature = (temperature, result) => {
    

        sql.query('INSERT INTO temp_location SET ?', temperature, (err, res) => {
            if (err) throw err;
            var last_insert_id = res.insertId;
            if(last_insert_id != ''){
                result(null,{ status:200, msg:'Success'});
            }else{
                result(null,{ status:201, msg:'Fail'}); 
            }
        });            
                
            
}; 
module.exports = Temperature;