const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const pool = require("../db");

// Mevcut register ve login fonksiyonları...
exports.register = async (req, res) => {
  const { username, phone, email, password, address } = req.body;

  try {
    const [existingUser] = await pool.query(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );
    if (existingUser.length > 0) {
      return res.status(400).json({ message: "Bu e-posta zaten kayıtlı." });
    }

    const [existingPhone] = await pool.query(
      "SELECT * FROM users WHERE phone = ?",
      [phone]
    );
    if (existingPhone.length > 0) {
      return res
        .status(400)
        .json({ message: "Bu telefon numarası zaten kayıtlı." });
    }

    const [existingUsername] = await pool.query(
      "SELECT * FROM users WHERE username = ?",
      [username]
    );
    if (existingUsername.length > 0) {
      return res
        .status(400)
        .json({ message: "Bu kullanıcı adı zaten alınmış." });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await pool.query(
      "INSERT INTO users (username, phone, email, password, address) VALUES (?, ?, ?, ?, ?)",
      [username, phone, email, hashedPassword, address]
    );

    res.status(201).json({ message: "Kullanıcı başarıyla oluşturuldu." });
  } catch (error) {
    console.error("Kayıt hatası:", error);
    res.status(500).json({ message: "Sunucu hatası", error: error.message });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const [user] = await pool.query("SELECT * FROM users WHERE email = ?", [
      email,
    ]);
    if (user.length === 0) {
      return res.status(401).json({ message: "Geçersiz e-posta veya şifre." });
    }

    const validPassword = await bcrypt.compare(password, user[0].password);
    if (!validPassword) {
      return res.status(401).json({ message: "Geçersiz e-posta veya şifre." });
    }

    const token = jwt.sign(
      { id: user[0].user_id },
      process.env.JWT_SECRET || "supersecretkey123",
      {
        expiresIn: "1h",
      }
    );

    res.json({
      token,
      user: {
        id: user[0].user_id,
        username: user[0].username,
        email: user[0].email,
      },
    });
  } catch (error) {
    console.error("Giriş hatası:", error);
    res.status(500).json({ message: "Sunucu hatası", error: error.message });
  }
};

// Yeni fonksiyon: Kullanıcı bilgilerini getir
exports.getUserInfo = async (req, res) => {
  try {
    const userId = req.user.id; // authMiddleware'dan gelen user_id
    const [user] = await pool.query(
      "SELECT user_id, username, email, phone, address FROM users WHERE user_id = ?",
      [userId]
    );

    if (user.length === 0) {
      return res.status(404).json({ message: "Kullanıcı bulunamadı" });
    }

    res.json(user[0]);
  } catch (error) {
    console.error("Kullanıcı bilgileri hatası:", error);
    res.status(500).json({ message: "Sunucu hatası", error: error.message });
  }
};

// Barista girişi
exports.baristaLogin = async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log("Login attempt:", { email }); // Giriş denemesini logla

    // Barista bilgilerini getir
    const [baristas] = await pool.query(
      "SELECT * FROM baristas WHERE email = ?",
      [email]
    );

    console.log("Found baristas:", baristas.length); // Bulunan barista sayısını logla

    if (baristas.length === 0) {
      return res.status(401).json({
        message: "E-posta veya şifre hatalı",
      });
    }

    const barista = baristas[0];

    // Şifreyi kontrol et
    const validPassword = await bcrypt.compare(password, barista.password);
    console.log("Password validation:", validPassword); // Şifre kontrolünü logla

    if (!validPassword) {
      return res.status(401).json({
        message: "E-posta veya şifre hatalı",
      });
    }

    // JWT token oluştur
    const token = jwt.sign(
      {
        barista_id: barista.barista_id,
        branch_id: barista.branch_id,
        email: barista.email,
      },
      process.env.JWT_SECRET || "supersecretkey123", // JWT_SECRET yoksa varsayılan değer kullan
      { expiresIn: "8h" }
    );

    // Hassas bilgileri çıkar
    delete barista.password;

    res.json({
      token,
      ...barista,
    });
  } catch (error) {
    console.error("Login error details:", {
      message: error.message,
      stack: error.stack,
      code: error.code,
    });
    res.status(500).json({
      message: "Giriş yapılırken bir hata oluştu",
      error: error.message, // Hata mesajını client'a gönder
    });
  }
};

// Token doğrulama middleware'i
exports.verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(" ")[1];

  if (!token) {
    return res.status(401).json({
      message: "Yetkilendirme token'ı bulunamadı",
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.barista = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      message: "Geçersiz token",
    });
  }
};
