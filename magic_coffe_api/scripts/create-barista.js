const bcrypt = require("bcryptjs");
const pool = require("../db");

async function createBarista() {
  try {
    const barista = {
      first_name: "Test",
      last_name: "Barista",
      email: "test@example.com",
      password: "123456", // Bu şifreyi kullanacağız
      specialty: "Espresso",
      branch_id: 1, // Mevcut bir şube ID'si kullanın
    };

    // Şifreyi hash'le
    const hashedPassword = await bcrypt.hash(barista.password, 10);

    // Barista'yı veritabanına ekle
    const [result] = await pool.query(
      "INSERT INTO baristas (first_name, last_name, email, password, specialty, branch_id) VALUES (?, ?, ?, ?, ?, ?)",
      [
        barista.first_name,
        barista.last_name,
        barista.email,
        hashedPassword,
        barista.specialty,
        barista.branch_id,
      ]
    );

    console.log("Barista başarıyla oluşturuldu:");
    console.log("Email:", barista.email);
    console.log("Şifre:", barista.password);
    console.log("Barista ID:", result.insertId);
  } catch (error) {
    console.error("Hata:", error);
  } finally {
    process.exit();
  }
}

createBarista();
