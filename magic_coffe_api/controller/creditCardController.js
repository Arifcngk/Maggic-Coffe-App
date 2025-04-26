const pool = require('../db');

exports.getCreditCards = async (req, res) => {
  try {
    const userId = req.user.id; // authMiddleware’dan
    const [cards] = await pool.query('SELECT * FROM credit_cards WHERE user_id = ?', [userId]);
    if (!cards.length) {
      return res.status(200).json([]); // Boş liste dön
    }
    res.status(200).json(cards);
  } catch (error) {
    console.error('Kart listesi alınırken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};

exports.addCreditCard = async (req, res) => {
  const { card_title, card_number, expiry_date, cvv } = req.body;
  const userId = req.user.id;

  try {
    if (!card_title || !card_number || !expiry_date || !cvv) {
      return res.status(400).json({ message: 'Tüm zorunlu alanlar doldurulmalı' });
    }
    // Basit validasyon (gerçek uygulamada daha kapsamlı olmalı)
    if (!/^\d{16}$/.test(card_number) || !/^\d{2}\/\d{2}$/.test(expiry_date) || !/^\d{3}$/.test(cvv)) {
      return res.status(400).json({ message: 'Geçersiz kart bilgileri' });
    }

    const [result] = await pool.query(
      'INSERT INTO credit_cards (user_id, card_title, card_number, expiry_date, cvv) VALUES (?, ?, ?, ?, ?)',
      [userId, card_title, card_number, expiry_date, cvv]
    );

    res.status(201).json({
      message: 'Kart başarıyla eklendi',
      card: {
        card_id: result.insertId,
        user_id: userId,
        card_title,
        card_number,
        expiry_date,
        cvv,
      },
    });
  } catch (error) {
    console.error('Kart eklenirken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};

exports.deleteCreditCard = async (req, res) => {
  const { card_id } = req.params;
  const userId = req.user.id;

  try {
    const [result] = await pool.query('DELETE FROM credit_cards WHERE card_id = ? AND user_id = ?', [card_id, userId]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Kart bulunamadı veya yetkiniz yok' });
    }
    res.status(200).json({ message: 'Kart başarıyla silindi' });
  } catch (error) {
    console.error('Kart silinirken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};