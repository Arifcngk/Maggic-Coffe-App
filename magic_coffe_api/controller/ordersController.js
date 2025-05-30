const pool = require("../db");

exports.createOrder = async (req, res) => {
  const { items, branch_id, card_id, total_price, barista_id } = req.body;
  const userId = req.user.id;

  try {
    // Validation
    if (
      !items ||
      !Array.isArray(items) ||
      items.length === 0 ||
      !branch_id ||
      !total_price ||
      !userId ||
      !barista_id
    ) {
      return res.status(400).json({ message: "Geçersiz veri" });
    }

    for (const item of items) {
      if (
        !item.coffee_id ||
        !item.quantity ||
        !item.unit_price ||
        !item.volume_ml ||
        typeof item.is_takeaway !== "boolean"
      ) {
        return res.status(400).json({ message: "Geçersiz ürün verisi" });
      }
      if (![250, 350, 450].includes(item.volume_ml)) {
        return res.status(400).json({ message: "Geçersiz hacim" });
      }
      if (item.intensity && !["light", "strong"].includes(item.intensity)) {
        return res.status(400).json({ message: "Geçersiz yoğunluk" });
      }
    }

    const connection = await pool.getConnection();
    try {
      await connection.beginTransaction();

      // orders tablosuna ekle
      const [orderResult] = await connection.query(
        "INSERT INTO orders (user_id, branch_id, card_id, total_price, status, barista_id) VALUES (?, ?, ?, ?, ?, ?)",
        [userId, branch_id, card_id || null, total_price, "pending", barista_id]
      );
      const orderId = orderResult.insertId;

      // branch_orders tablosuna her ürün için ekle
      for (const item of items) {
        await connection.query(
          "INSERT INTO branch_orders (order_id, branch_id, coffee_id, quantity, price, selected_volume_ml, delivery_type, intensity, status, barista_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            orderId,
            branch_id,
            item.coffee_id,
            item.quantity,
            item.unit_price,
            item.volume_ml,
            item.is_takeaway ? "takeaway" : "onsite",
            item.intensity || "light",
            "pending",
            barista_id,
          ]
        );

        // Kahve puanını al
        const [coffee] = await connection.query(
          "SELECT point_value FROM coffees WHERE coffee_id = ?",
          [item.coffee_id]
        );

        if (coffee.length > 0) {
          const points = coffee[0].point_value * item.quantity;

          // Puanları güncelle
          await connection.query(
            `INSERT INTO user_points (user_id, total_points) 
             VALUES (?, ?) 
             ON DUPLICATE KEY UPDATE 
             total_points = total_points + ?`,
            [userId, points, points]
          );

          // Kahve sayısını güncelle
          await connection.query(
            `INSERT INTO user_coffee_counts (user_id, coffee_id, purchase_count) 
             VALUES (?, ?, ?) 
             ON DUPLICATE KEY UPDATE 
             purchase_count = purchase_count + ?`,
            [userId, item.coffee_id, item.quantity, item.quantity]
          );
        }
      }

      await connection.commit();
      res
        .status(201)
        .json({ message: "Sipariş oluşturuldu", order_id: orderId });
    } catch (error) {
      await connection.rollback();
      console.error("Sipariş hatası:", error);
      res
        .status(500)
        .json({ message: "Sipariş oluşturulamadı", error: error.message });
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error("Bağlantı hatası:", error);
    res.status(500).json({ message: "Sunucu hatası", error: error.message });
  }
};

exports.getBranchOrders = async (req, res) => {
  const { branch_id, status = "pending" } = req.query;

  try {
    if (!branch_id) {
      return res.status(400).json({ message: "branch_id gerekli" });
    }

    const [rows] = await pool.query(
      `SELECT bo.branch_order_id, bo.order_id, c.coffee_name, bo.quantity, bo.selected_volume_ml, bo.delivery_type, bo.intensity, bo.status
       FROM branch_orders bo
       JOIN coffees c ON bo.coffee_id = c.coffee_id
       WHERE bo.branch_id = ? AND bo.status = ?`,
      [branch_id, status]
    );
    res.status(200).json(rows);
  } catch (error) {
    console.error("Sorgu hatası:", error);
    res.status(500).json({ message: "Sorgu başarısız", error: error.message });
  }
};

exports.getBaristaOrders = async (req, res) => {
  try {
    const { barista_id, branch_id } = req.user;

    if (!barista_id || !branch_id) {
      return res.status(400).json({ message: "Barista bilgileri eksik" });
    }

    // Önce siparişleri getir
    const [orders] = await pool.query(
      `
      SELECT 
        o.order_id,
        o.user_id,
        o.branch_id,
        o.status,
        o.order_date as created_at,
        o.total_price,
        u.username,
        u.phone,
        u.address
      FROM orders o
      LEFT JOIN users u ON o.user_id = u.user_id
      WHERE o.branch_id = ? AND o.barista_id = ?
      ORDER BY o.order_date DESC
    `,
      [branch_id, barista_id]
    );

    // Her sipariş için sipariş detaylarını getir
    for (let order of orders) {
      const [items] = await pool.query(
        `
        SELECT 
          bo.branch_order_id,
          bo.coffee_id,
          bo.quantity,
          bo.price,
          bo.selected_volume_ml,
          bo.delivery_type,
          bo.intensity,
          bo.status,
          c.coffee_name,
          c.image_url
        FROM branch_orders bo
        LEFT JOIN coffees c ON bo.coffee_id = c.coffee_id
        WHERE bo.order_id = ?
      `,
        [order.order_id]
      );

      order.items = items;
    }

    res.json(orders);
  } catch (error) {
    console.error("Barista siparişleri getirme hatası:", error);
    res
      .status(500)
      .json({ message: "Siparişler getirilirken bir hata oluştu" });
  }
};

exports.updateOrderStatus = async (req, res) => {
  const { orderId } = req.params;
  const { status } = req.body;
  const baristaId = req.user.barista_id;

  // Geçerli durumları kontrol et
  const validStatuses = ["pending", "completed", "cancelled"];
  if (!validStatuses.includes(status)) {
    return res.status(400).json({ message: "Geçersiz sipariş durumu" });
  }

  try {
    // Önce siparişin bu baristaya ait olup olmadığını kontrol et
    const [order] = await pool.query(
      `SELECT o.order_id, o.branch_id 
       FROM orders o
       JOIN branch_orders bo ON o.order_id = bo.order_id
       WHERE o.order_id = ? AND bo.barista_id = ?`,
      [orderId, baristaId]
    );

    if (order.length === 0) {
      return res.status(404).json({
        message: "Sipariş bulunamadı veya bu siparişi güncelleme yetkiniz yok",
      });
    }

    // Sipariş durumunu güncelle
    await pool.query(
      `UPDATE orders o
       JOIN branch_orders bo ON o.order_id = bo.order_id
       SET o.status = ?, bo.status = ?
       WHERE o.order_id = ? AND bo.barista_id = ?`,
      [status, status, orderId, baristaId]
    );

    res.status(200).json({ message: "Sipariş durumu güncellendi" });
  } catch (error) {
    console.error("Sipariş durumu güncelleme hatası:", error);
    res
      .status(500)
      .json({ message: "Sipariş durumu güncellenemedi", error: error.message });
  }
};
