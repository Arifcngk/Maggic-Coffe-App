const pool = require("../db");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Multer ayarları - resim yükleme için
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/coffee-images/");
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});

const upload = multer({
  storage: storage,
  fileFilter: function (req, file, cb) {
    if (!file.originalname.match(/\.(jpg|jpeg|png|gif)$/)) {
      return cb(new Error("Sadece resim dosyaları yüklenebilir!"), false);
    }
    cb(null, true);
  },
}).single("image");

exports.getAllCoffees = async (req, res) => {
  try {
    const [coffees] = await pool.query("SELECT * FROM coffees");
    if (!coffees.length) {
      return res.status(404).json({ message: "Kahve bulunamadı" });
    }
    res.status(200).json(coffees);
  } catch (error) {
    console.error("Kahve listesi alınırken hata:", error);
    res.status(500).json({ message: "Sunucu hatası", error: error.message });
  }
};

exports.getCoffeeManagementPage = async (req, res) => {
  try {
    const [coffees] = await pool.query(
      "SELECT * FROM coffees ORDER BY coffee_name"
    );
    res.render("coffee-management/index", { coffees });
  } catch (error) {
    console.error("Kahve listesi yüklenirken hata:", error);
    res.status(500).send("Kahve listesi yüklenemedi");
  }
};

exports.addCoffee = async (req, res) => {
  upload(req, res, async function (err) {
    if (err) {
      return res.status(400).json({ message: err.message });
    }

    if (!req.file) {
      return res.status(400).json({ message: "Lütfen bir resim yükleyin" });
    }

    const { coffee_name, volume_ml, price, point_value, is_hot } = req.body;

    try {
      await pool.query(
        `INSERT INTO coffees 
                (coffee_name, image_url, volume_ml, is_hot, price, point_value) 
                VALUES (?, ?, ?, ?, ?, ?)`,
        [
          coffee_name,
          req.file.filename,
          volume_ml,
          is_hot === "1" ? 1 : 0,
          price,
          point_value,
        ]
      );

      res.redirect("/admin/coffees");
    } catch (error) {
      // Hata durumunda yüklenen resmi sil
      fs.unlinkSync(req.file.path);
      console.error("Kahve eklenirken hata:", error);
      res.status(500).json({ message: "Kahve eklenemedi" });
    }
  });
};

exports.deleteCoffee = async (req, res) => {
  const coffeeId = req.params.id;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // Önce kahvenin resim URL'sini al
    const [coffee] = await connection.query(
      "SELECT image_url FROM coffees WHERE coffee_id = ?",
      [coffeeId]
    );

    if (!coffee) {
      await connection.rollback();
      return res.status(404).json({ message: "Kahve bulunamadı" });
    }

    // Kahveyi veritabanından sil
    await connection.query("DELETE FROM coffees WHERE coffee_id = ?", [
      coffeeId,
    ]);

    // Eğer resim varsa, sunucudan da sil
    if (coffee.image_url) {
      const imagePath = path.join(
        __dirname,
        "..",
        "public",
        "coffee-images",
        coffee.image_url
      );
      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }

    await connection.commit();
    res.json({ message: "Kahve başarıyla silindi" });
  } catch (error) {
    await connection.rollback();
    console.error("Kahve silme hatası:", error);
    res.status(500).json({ message: "Kahve silinirken bir hata oluştu" });
  } finally {
    connection.release();
  }
};

exports.updateCoffee = async (req, res) => {
  const coffeeId = req.params.id;
  const { coffee_name, volume_ml, price, point_value, is_hot } = req.body;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // Önce kahvenin mevcut bilgilerini al
    const [coffee] = await connection.query(
      "SELECT * FROM coffees WHERE coffee_id = ?",
      [coffeeId]
    );

    if (!coffee) {
      await connection.rollback();
      return res.status(404).json({ message: "Kahve bulunamadı" });
    }

    let imageUrl = coffee[0].image_url;

    // Eğer yeni resim yüklendiyse
    if (req.file) {
      // Eski resmi sil
      if (imageUrl) {
        const oldImagePath = path.join(
          __dirname,
          "..",
          "public",
          "coffee-images",
          imageUrl
        );
        if (fs.existsSync(oldImagePath)) {
          fs.unlinkSync(oldImagePath);
        }
      }

      // Yeni resmi kaydet
      const image = req.file;
      const imageName = `${Date.now()}-${image.originalname}`;
      const imagePath = path.join(
        __dirname,
        "..",
        "public",
        "coffee-images",
        imageName
      );

      fs.writeFileSync(imagePath, image.buffer);
      imageUrl = imageName;
    }

    // Kahveyi güncelle
    await connection.query(
      `UPDATE coffees 
       SET coffee_name = ?, volume_ml = ?, price = ?, point_value = ?, is_hot = ?, image_url = ?
       WHERE coffee_id = ?`,
      [coffee_name, volume_ml, price, point_value, is_hot, imageUrl, coffeeId]
    );

    await connection.commit();
    res.json({ message: "Kahve başarıyla güncellendi" });
  } catch (error) {
    await connection.rollback();
    console.error("Kahve güncelleme hatası:", error);
    res.status(500).json({ message: "Kahve güncellenirken bir hata oluştu" });
  } finally {
    connection.release();
  }
};
