const sql = require("../utils/dbConnection.js");
const consts = require("../utils/constants.js");

const Admin = function () {};

// All stores (producers) on the platform, with their store-manager account if one exists
Admin.list_producers = (result) => {
  sql.query(
    "SELECT pl.producer_id, pl.producer_name, pl.producer_image_url, pl.producer_icon_url, pl.prod_desc, " +
    "u.user_id AS manager_user_id, u.first_name AS manager_first_name, u.last_name AS manager_last_name, u.mobile AS manager_mobile, u.status AS manager_status " +
    "FROM producer_list pl " +
    "LEFT JOIN users_tb u ON u.producerid = pl.producer_id AND u.user_type = 1 " +
    "ORDER BY pl.producer_id DESC",
    (err, rows) => {
      if (err) return result(err, null);
      result(null, { status: 200, producers: rows, msg: 'Success' });
    }
  );
};

// All delivery agents on the platform
Admin.list_delivery_agents = (result) => {
  sql.query(
    "SELECT user_id, first_name, last_name, mobile, email_id, status, created_at " +
    "FROM users_tb WHERE user_type = 2 ORDER BY user_id DESC",
    (err, rows) => {
      if (err) return result(err, null);
      result(null, { status: 200, delivery_agents: rows, msg: 'Success' });
    }
  );
};

// All customers on the platform
Admin.list_customers = (result) => {
  sql.query(
    "SELECT user_id, first_name, last_name, mobile, email_id, status, created_at " +
    "FROM users_tb WHERE user_type = 0 ORDER BY user_id DESC",
    (err, rows) => {
      if (err) return result(err, null);
      result(null, { status: 200, customers: rows, msg: 'Success' });
    }
  );
};

// Orders across every store on the platform, optionally filtered by status
Admin.list_orders = (filters, result) => {
  var status = filters.status;
  var status_condition = (status !== undefined && status !== null && status !== '') ? ' AND odi.current_status = ' + sql.escape(status) : '';

  sql.query(
    "SELECT odi.order_id, CONCAT('OD',LPAD(odi.order_id,6,0)) as order_number, odi.producer_id, pl.producer_name, " +
    "COUNT(odi.product_id) as item_count, odi.current_status, SUM(odi.total) as total_amount, " +
    "currency_tb.currency, currency_tb.currency_type, order_tb.order_date, order_tb.user_id as customer_id " +
    "FROM order_details_id odi " +
    "INNER JOIN producer_list pl ON odi.producer_id = pl.producer_id " +
    "JOIN order_tb ON order_tb.order_id = odi.order_id " +
    "LEFT JOIN currency_tb ON currency_tb.cur_id = order_tb.currency_id " +
    "WHERE 1=1" + status_condition + " " +
    "GROUP BY order_number, odi.order_id, odi.producer_id, odi.current_status " +
    "ORDER BY odi.order_id DESC",
    (err, rows) => {
      if (err) return result(err, null);
      result(null, { status: 200, orders: rows, msg: 'Success' });
    }
  );
};

// Platform-wide dashboard counts
Admin.dashboard_stats = (result) => {
  sql.query(
    "SELECT " +
    "(SELECT COUNT(*) FROM producer_list) as total_producers, " +
    "(SELECT COUNT(*) FROM users_tb WHERE user_type = 2 AND status = 0) as total_delivery_agents, " +
    "(SELECT COUNT(*) FROM users_tb WHERE user_type = 0 AND status = 0) as total_customers, " +
    "(SELECT COUNT(*) FROM order_tb) as total_orders, " +
    "(SELECT IFNULL(SUM(grant_total),0) FROM order_tb) as total_revenue",
    (err, rows) => {
      if (err) return result(err, null);
      result(null, { status: 200, stats: rows[0], msg: 'Success' });
    }
  );
};

// Create a new store: a producer_list row plus its store-manager account (user_type = 1).
// The manager account is a placeholder until the manager themselves logs in via
// /producer_login, which claims it by matching on mobile and attaching fb_id/fcm_id.
Admin.create_producer = (data, result) => {
  var mobile = data.manager_mobile;

  sql.query('SELECT user_id FROM users_tb WHERE mobile = ? AND user_type = 1', [mobile], (err, existing) => {
    if (err) return result(err, null);
    if (existing.length > 0) {
      return result({ message: 'A store manager with this mobile number already exists' }, null);
    }

    sql.query('INSERT INTO producer_list SET ?', {
      producer_name: data.producer_name,
      producer_image_url: data.producer_image_url || '',
      producer_icon_url: data.producer_icon_url || '',
      prod_desc: data.prod_desc || ''
    }, (err2, insertResult) => {
      if (err2) return result(err2, null);
      var producer_id = insertResult.insertId;

      sql.query('INSERT INTO users_tb SET ?', {
        first_name: data.manager_first_name,
        last_name: data.manager_last_name || '',
        email_id: data.manager_email || '',
        mobile: mobile,
        user_type: 1,
        producerid: producer_id,
        latitude: data.latitude || 0,
        longitude: data.longitude || 0,
        distance: data.distance || 10,
        status: 0
      }, (err3, userInsertResult) => {
        if (err3) return result(err3, null);
        result(null, { status: 200, producer_id: producer_id, manager_user_id: userInsertResult.insertId, msg: 'Success' });
      });
    });
  });
};

// Update a store's catalog-facing details (name, images, description)
Admin.update_producer = (data, result) => {
  sql.query(
    'UPDATE producer_list SET producer_name = ?, producer_image_url = ?, producer_icon_url = ?, prod_desc = ? WHERE producer_id = ?',
    [data.producer_name, data.producer_image_url || '', data.producer_icon_url || '', data.prod_desc || '', data.producer_id],
    (err, updateResult) => {
      if (err) return result(err, null);
      if (updateResult.affectedRows === 0) return result({ message: 'Producer not found' }, null);
      result(null, { status: 200, msg: 'Success' });
    }
  );
};

// Activate/deactivate a store by activating/deactivating its manager account -
// Producer.list (the customer-facing browse query) inner-joins on that row, so this
// is what actually hides/shows the store to customers.
Admin.update_producer_status = (data, result) => {
  sql.query(
    'UPDATE users_tb SET status = ? WHERE producerid = ? AND user_type = 1',
    [data.status, data.producer_id],
    (err, updateResult) => {
      if (err) return result(err, null);
      if (updateResult.affectedRows === 0) return result({ message: 'Producer has no manager account to update' }, null);
      result(null, { status: 200, msg: 'Success' });
    }
  );
};

// Create a new delivery agent account (user_type = 2). Like producers, it's a
// placeholder until the agent logs in via /delivery_login and claims it by mobile.
Admin.create_delivery_agent = (data, result) => {
  var mobile = data.mobile;

  sql.query('SELECT user_id FROM users_tb WHERE mobile = ? AND user_type = 2', [mobile], (err, existing) => {
    if (err) return result(err, null);
    if (existing.length > 0) {
      return result({ message: 'A delivery agent with this mobile number already exists' }, null);
    }

    sql.query('INSERT INTO users_tb SET ?', {
      first_name: data.first_name,
      last_name: data.last_name || '',
      email_id: data.email_id || '',
      mobile: mobile,
      user_type: 2,
      status: 0
    }, (err2, insertResult) => {
      if (err2) return result(err2, null);
      result(null, { status: 200, user_id: insertResult.insertId, msg: 'Success' });
    });
  });
};

// Update a delivery agent's profile details
Admin.update_delivery_agent = (data, result) => {
  sql.query(
    'UPDATE users_tb SET first_name = ?, last_name = ?, email_id = ? WHERE user_id = ? AND user_type = 2',
    [data.first_name, data.last_name || '', data.email_id || '', data.user_id],
    (err, updateResult) => {
      if (err) return result(err, null);
      if (updateResult.affectedRows === 0) return result({ message: 'Delivery agent not found' }, null);
      result(null, { status: 200, msg: 'Success' });
    }
  );
};

// Activate/deactivate a delivery agent account
Admin.update_delivery_agent_status = (data, result) => {
  sql.query(
    'UPDATE users_tb SET status = ? WHERE user_id = ? AND user_type = 2',
    [data.status, data.user_id],
    (err, updateResult) => {
      if (err) return result(err, null);
      if (updateResult.affectedRows === 0) return result({ message: 'Delivery agent not found' }, null);
      result(null, { status: 200, msg: 'Success' });
    }
  );
};

Admin.list_products = (result) => {
  sql.query(
    "SELECT p.product_id, p.producerid AS producer_id, pr.producer_name, p.product_name, p.product_desc, " +
    "p.rate_per_hour, p.product_qty, p.display_status, p.created_at " +
    "FROM product_list p LEFT JOIN producer_list pr ON pr.producer_id = p.producerid " +
    "ORDER BY p.product_id DESC",
    (err, rows) => {
      if (err) return result(err, null);
      result(null, { status: 200, products: rows, msg: 'Success' });
    }
  );
};

Admin.create_product = (data, result) => {
  sql.query('INSERT INTO product_list SET ?', {
    producerid: data.producer_id,
    product_name: data.product_name,
    product_desc: data.product_desc || '',
    rate_per_hour: data.rate_per_hour,
    product_qty: data.product_qty,
    display_status: data.display_status || 0,
    currency_id: data.currency_id || null,
    unit_id: data.unit_id || null
  }, (err, insertResult) => {
    if (err) return result(err, null);
    result(null, { status: 200, product_id: insertResult.insertId, msg: 'Success' });
  });
};

Admin.update_product = (data, result) => {
  sql.query(
    'UPDATE product_list SET producerid = ?, product_name = ?, product_desc = ?, rate_per_hour = ?, product_qty = ? WHERE product_id = ?',
    [data.producer_id, data.product_name, data.product_desc || '', data.rate_per_hour, data.product_qty, data.product_id],
    (err, updateResult) => {
      if (err) return result(err, null);
      if (updateResult.affectedRows === 0) return result({ message: 'Product not found' }, null);
      result(null, { status: 200, msg: 'Success' });
    }
  );
};

Admin.update_product_status = (data, result) => {
  sql.query('UPDATE product_list SET display_status = ? WHERE product_id = ?',
    [data.display_status, data.product_id], (err, updateResult) => {
      if (err) return result(err, null);
      if (updateResult.affectedRows === 0) return result({ message: 'Product not found' }, null);
      result(null, { status: 200, msg: 'Success' });
    });
};

module.exports = Admin;
