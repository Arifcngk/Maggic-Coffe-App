const bcrypt = require("bcrypt");
const mysql = require("mysql2/promise");

// Veritabanı bağlantı bilgileri
const config = {
  host: "localhost",
  user: "root",
  password: "admin",
  database: "magic_coffe",
};

async function updateBaristaPasswords() {
  try {
    // Veritabanı bağlantısı
    const connection = await mysql.createConnection(config);

    // Yeni şifre (örnek: "123456")
    const newPassword = "123456";

    // Şifreyi hashle
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Tüm baristaların şifresini güncelle
    const [result] = await connection.execute(
      "UPDATE baristas SET password = ?",
      [hashedPassword]
    );

    console.log(`${result.affectedRows} baristanın şifresi güncellendi.`);
    console.log("Yeni şifre:", newPassword);

    // Bağlantıyı kapat
    await connection.end();
  } catch (error) {
    console.error("Hata:", error);
  }
}

// Scripti çalıştır
updateBaristaPasswords();
