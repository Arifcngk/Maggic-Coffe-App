const pool = require("../db");

exports.getUserPoints = async (req, res) => {
  const userId = req.user.id;

  try {
    const [points] = await pool.query(
      "SELECT total_points FROM user_points WHERE user_id = ?",
      [userId]
    );

    if (points.length === 0) {
      return res.status(404).json({ message: "Kullanıcı puanı bulunamadı" });
    }

    res.status(200).json(points[0]);
  } catch (error) {
    console.error("Puan sorgu hatası:", error);
    res
      .status(500)
      .json({ message: "Puan sorgusu başarısız", error: error.message });
  }
};

exports.getWeeklyOrderCount = async (req, res) => {
  const userId = req.user.id;

  try {
    const [count] = await pool.query(
      `SELECT COUNT(*) as count 
       FROM orders 
       WHERE user_id = ? 
       AND order_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)`,
      [userId]
    );

    res.status(200).json({ weeklyOrderCount: count[0].count });
  } catch (error) {
    console.error("Haftalık sipariş sorgu hatası:", error);
    res.status(500).json({ message: "Sorgu başarısız", error: error.message });
  }
};

exports.getCoffeeHistory = async (req, res) => {
  const userId = req.user.id;

  try {
    // Önce coffees tablosundaki point_value değerlerini kontrol et
    const [coffeePoints] = await pool.query(
      "SELECT coffee_id, coffee_name, point_value FROM coffees"
    );
    console.log("Coffee points:", coffeePoints);

    const [history] = await pool.query(
      `SELECT c.coffee_name, c.image_url, c.price, c.point_value,
              bo.quantity, bo.selected_volume_ml, bo.delivery_type, 
              bo.intensity, o.order_date
       FROM orders o
       JOIN branch_orders bo ON o.order_id = bo.order_id
       JOIN coffees c ON bo.coffee_id = c.coffee_id
       WHERE o.user_id = ?
       ORDER BY o.order_date DESC
       LIMIT 10`,
      [userId]
    );

    // Debug için veriyi kontrol et
    console.log("History data:", history);
    console.log("First item point_value:", history[0]?.point_value);

    res.status(200).json(history);
  } catch (error) {
    console.error("Sipariş geçmişi sorgu hatası:", error);
    res.status(500).json({ message: "Sorgu başarısız", error: error.message });
  }
};

exports.updatePoints = async (req, res) => {
  const userId = req.user.id;
  const { points } = req.body;

  try {
    await pool.query(
      `INSERT INTO user_points (user_id, total_points) 
       VALUES (?, ?) 
       ON DUPLICATE KEY UPDATE 
       total_points = total_points + ?`,
      [userId, points, points]
    );

    res.status(200).json({ message: "Puanlar güncellendi" });
  } catch (error) {
    console.error("Puan güncelleme hatası:", error);
    res
      .status(500)
      .json({ message: "Puan güncellenemedi", error: error.message });
  }
};

// Bedava kahve kullanma
exports.redeemFreeCoffee = async (req, res) => {
  const userId = req.user.id;
  const { coffee_id, branch_id } = req.body;
  const FREE_COFFEE_POINTS = 250;

  try {
    // Kullanıcının puanlarını kontrol et
    const [points] = await pool.query(
      "SELECT total_points FROM user_points WHERE user_id = ?",
      [userId]
    );

    if (points.length === 0 || points[0].total_points < FREE_COFFEE_POINTS) {
      return res.status(400).json({
        message: "Yeterli puanınız bulunmamaktadır",
        required_points: FREE_COFFEE_POINTS,
        current_points: points[0]?.total_points || 0,
      });
    }

    // Transaction başlat
    await pool.query("START TRANSACTION");

    try {
      // Şubedeki baristaları al
      const [baristas] = await pool.query(
        "SELECT barista_id FROM baristas WHERE branch_id = ?",
        [branch_id]
      );

      if (baristas.length === 0) {
        throw new Error("Bu şubede barista bulunamadı");
      }

      // Rastgele bir barista seç
      const randomBarista =
        baristas[Math.floor(Math.random() * baristas.length)];

      // Puanları güncelle
      await pool.query(
        `UPDATE user_points 
         SET total_points = total_points - ? 
         WHERE user_id = ?`,
        [FREE_COFFEE_POINTS, userId]
      );

      // Bedava kahve siparişini oluştur
      const [orderResult] = await pool.query(
        `INSERT INTO orders (user_id, branch_id, total_price, status, barista_id) 
         VALUES (?, ?, 0, 'completed', ?)`,
        [userId, branch_id, randomBarista.barista_id]
      );

      const orderId = orderResult.insertId;

      // Branch orders'a ekle
      await pool.query(
        `INSERT INTO branch_orders 
         (order_id, branch_id, coffee_id, quantity, price, selected_volume_ml, delivery_type, intensity, status, barista_id) 
         VALUES (?, ?, ?, 1, 0, 250, 'onsite', 'light', 'completed', ?)`,
        [orderId, branch_id, coffee_id, randomBarista.barista_id]
      );

      // Transaction'ı onayla
      await pool.query("COMMIT");

      res.status(200).json({
        message: "Bedava kahveniz başarıyla kullanıldı",
        remaining_points: points[0].total_points - FREE_COFFEE_POINTS,
      });
    } catch (error) {
      // Hata durumunda transaction'ı geri al
      await pool.query("ROLLBACK");
      throw error;
    }
  } catch (error) {
    console.error("Bedava kahve kullanma hatası:", error);
    res.status(500).json({
      message: "Bedava kahve kullanılamadı",
      error: error.message,
    });
  }
};
