const bcrypt = require("bcryptjs");
const pool = require("../db");

async function updateBaristaPassword(email, newPassword) {
  try {
    // Şifreyi hash'le
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Şifreyi güncelle
    const [result] = await pool.query(
      "UPDATE baristas SET password = ? WHERE email = ?",
      [hashedPassword, email]
    );

    if (result.affectedRows > 0) {
      console.log(`Barista şifresi güncellendi (${email})`);
      console.log("Yeni şifre:", newPassword);
    } else {
      console.log("Barista bulunamadı");
    }
  } catch (error) {
    console.error("Hata:", error);
  } finally {
    process.exit();
  }
}

// admin@gmail.com için şifreyi güncelle
updateBaristaPassword("admin@gmail.com", "123456");
