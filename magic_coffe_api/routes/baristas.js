const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const { authenticateToken } = require("../middleware/auth");

// Tüm baristaları getir
router.get("/", authenticateToken, async (req, res) => {
  try {
    const [baristas] = await req.db.query(`
            SELECT b.*, br.branch_name 
            FROM baristas b
            LEFT JOIN branches br ON b.branch_id = br.branch_id
            ORDER BY b.first_name, b.last_name
        `);
    res.json(baristas);
  } catch (error) {
    console.error("Barista listesi alınamadı:", error);
    res.status(500).json({ message: "Barista listesi alınamadı" });
  }
});

// Yeni barista ekle
router.post("/", authenticateToken, async (req, res) => {
  const {
    first_name,
    last_name,
    email,
    password,
    specialty,
    branch_id,
    image_url,
  } = req.body;

  try {
    // E-posta kontrolü
    const [existing] = await req.db.query(
      "SELECT * FROM baristas WHERE email = ?",
      [email]
    );
    if (existing.length > 0) {
      return res
        .status(400)
        .json({ message: "Bu e-posta adresi zaten kullanılıyor" });
    }

    // Şifreyi hashle
    const hashedPassword = await bcrypt.hash(password, 10);

    // Baristayı ekle
    const [result] = await req.db.query(
      "INSERT INTO baristas (first_name, last_name, email, password, specialty, branch_id, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)",
      [
        first_name,
        last_name,
        email,
        hashedPassword,
        specialty,
        branch_id,
        image_url,
      ]
    );

    res.status(201).json({
      message: "Barista başarıyla eklendi",
      barista_id: result.insertId,
    });
  } catch (error) {
    console.error("Barista eklenemedi:", error);
    res.status(500).json({ message: "Barista eklenemedi" });
  }
});

// Barista güncelle
router.put("/:id", authenticateToken, async (req, res) => {
  const { id } = req.params;
  const {
    first_name,
    last_name,
    email,
    password,
    specialty,
    branch_id,
    image_url,
  } = req.body;

  try {
    // E-posta kontrolü (kendi e-postası hariç)
    const [existing] = await req.db.query(
      "SELECT * FROM baristas WHERE email = ? AND barista_id != ?",
      [email, id]
    );
    if (existing.length > 0) {
      return res
        .status(400)
        .json({ message: "Bu e-posta adresi zaten kullanılıyor" });
    }

    let updateQuery = `
            UPDATE baristas 
            SET first_name = ?, last_name = ?, email = ?, specialty = ?, branch_id = ?, image_url = ?
        `;
    let queryParams = [
      first_name,
      last_name,
      email,
      specialty,
      branch_id,
      image_url,
    ];

    // Şifre değiştirilecekse
    if (password) {
      const hashedPassword = await bcrypt.hash(password, 10);
      updateQuery += ", password = ?";
      queryParams.push(hashedPassword);
    }

    updateQuery += " WHERE barista_id = ?";
    queryParams.push(id);

    await req.db.query(updateQuery, queryParams);

    res.json({ message: "Barista başarıyla güncellendi" });
  } catch (error) {
    console.error("Barista güncellenemedi:", error);
    res.status(500).json({ message: "Barista güncellenemedi" });
  }
});

// Barista sil
router.delete("/:id", authenticateToken, async (req, res) => {
  const { id } = req.params;

  try {
    // Bekleyen siparişleri kontrol et
    const [pendingOrders] = await req.db.query(
      'SELECT COUNT(*) as count FROM orders WHERE barista_id = ? AND status = "pending"',
      [id]
    );

    if (pendingOrders[0].count > 0) {
      return res.status(400).json({
        message:
          "Bu baristanın bekleyen siparişleri var. Önce siparişleri tamamlayın.",
      });
    }

    await req.db.query("DELETE FROM baristas WHERE barista_id = ?", [id]);
    res.json({ message: "Barista başarıyla silindi" });
  } catch (error) {
    console.error("Barista silinemedi:", error);
    res.status(500).json({ message: "Barista silinemedi" });
  }
});

module.exports = router;
