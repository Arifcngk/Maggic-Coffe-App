const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
      return res
        .status(401)
        .json({ message: "Yetkilendirme token'ı bulunamadı" });
    }

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET || "supersecretkey123"
    );

    // Barista veya normal kullanıcı kontrolü
    if (decoded.barista_id) {
      // Barista girişi
      req.user = {
        barista_id: decoded.barista_id,
        branch_id: decoded.branch_id,
        email: decoded.email,
      };
    } else {
      // Normal kullanıcı girişi
      req.user = {
        id: decoded.id,
      };
    }

    next();
  } catch (error) {
    console.error("Token doğrulama hatası:", error);
    return res.status(401).json({ message: "Geçersiz token" });
  }
};
