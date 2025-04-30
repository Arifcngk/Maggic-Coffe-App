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
    const [history] = await pool.query(
      `SELECT c.coffee_name, c.image_url, c.price, 
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
