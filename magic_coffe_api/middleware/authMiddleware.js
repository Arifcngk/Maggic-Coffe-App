const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
  // Authorization başlığından token'ı al, "Bearer " ön ekini kaldır
  const token = req.header("Authorization")?.replace("Bearer ", "");

  if (!token) {
    return res
      .status(401)
      .json({ message: "Token bulunamadı, yetkilendirme reddedildi" });
  }

  try {
    // Token'ı doğrula
    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET || "supersecretkey123"
    );
    req.user = decoded; // decoded içinde user_id (id) olacak
    next();
  } catch (error) {
    console.error("Token doğrulama hatası:", error.message);
    if (error.name === "TokenExpiredError") {
      return res
        .status(401)
        .json({ message: "Token süresi dolmuş, lütfen tekrar giriş yapın" });
    }
    return res.status(401).json({ message: "Geçersiz token" });
  }
};

module.exports = authMiddleware;
