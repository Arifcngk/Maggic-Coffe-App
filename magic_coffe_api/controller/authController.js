const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../db');

exports.register = async (req, res) => {
  const { username, phone, email, password, address } = req.body;

  try {
    // Kullanıcıyı kontrol et
    const [existingUser] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'Bu e-posta zaten kayıtlı.' });
    }

    const [existingPhone] = await pool.query('SELECT * FROM users WHERE phone = ?', [phone]);
    if (existingPhone.length > 0) {
      return res.status(400).json({ message: 'Bu telefon numarası zaten kayıtlı.' });
    }

    const [existingUsername] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
    if (existingUsername.length > 0) {
      return res.status(400).json({ message: 'Bu kullanıcı adı zaten alınmış.' });
    }

    // Şifreyi hash'le
    const hashedPassword = await bcrypt.hash(password, 10);

    // Kullanıcıyı veritabanına ekle
    await pool.query(
      'INSERT INTO users (username, phone, email, password, address) VALUES (?, ?, ?, ?, ?)',
      [username, phone, email, hashedPassword, address]
    );

    res.status(201).json({ message: 'Kullanıcı başarıyla oluşturuldu.' });
  } catch (error) {
    res.status(500).json({ message: 'Sunucu hatası', error });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    // Kullanıcıyı e-posta ile bul
    const [user] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);

    if (user.length === 0) {
      return res.status(401).json({ message: 'Geçersiz e-posta veya şifre.' });
    }

    // Şifreyi kontrol et
    const validPassword = await bcrypt.compare(password, user[0].password);
    if (!validPassword) {
      return res.status(401).json({ message: 'Geçersiz e-posta veya şifre.' });
    }

    // JWT token oluştur
    const token = jwt.sign({ id: user[0].user_id }, process.env.JWT_SECRET, {
      expiresIn: '1h'
    });

    res.json({
      token,
      user: {
        id: user[0].user_id,
        username: user[0].username,
        email: user[0].email
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'Sunucu hatası', error });
  }
};
