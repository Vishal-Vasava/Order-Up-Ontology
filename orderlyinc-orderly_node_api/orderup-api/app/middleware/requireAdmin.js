// Gate for platform manager (user_type = 3) only endpoints.
// Must run after the global `auth` middleware, which sets req.user_type from the JWT.
module.exports = (req, res, next) => {
    if (req.user_type != '3') {
        return res.status(403).json({
            message: "Platform manager access required",
        });
    }
    next();
};
