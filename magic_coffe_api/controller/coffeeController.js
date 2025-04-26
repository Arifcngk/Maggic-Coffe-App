const pool = require('../db');

exports.getAllCoffees = async (req, res) => {
  try {
    const [coffees] = await pool.query('SELECT * FROM coffees');
    if (!coffees.length) {
      return res.status(404).json({ message: 'Kahve bulunamadı' });
    }
    res.status(200).json(coffees);
  } catch (error) {
    console.error('Kahve listesi alınırken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};

exports.addCoffee = async (req, res) => {
  const { coffee_name, image_url, volume_ml, is_hot, price, point_value = 0 } = req.body;

  try {
    if (!coffee_name || !volume_ml || is_hot === undefined || !price || !image_url) {
      return res.status(400).json({ message: 'Tüm zorunlu alanlar doldurulmalı' });
    }

    const [result] = await pool.query(
      'INSERT INTO coffees (coffee_name, image_url, volume_ml, is_hot, price, point_value) VALUES (?, ?, ?, ?, ?, ?)',
      [coffee_name, image_url, volume_ml, is_hot, price, point_value]
    );

    res.status(201).json({
      message: 'Kahve başarıyla eklendi',
      coffeeId: result.insertId,
      coffee: {
        coffee_id: result.insertId,
        coffee_name,
        image_url,
        volume_ml,
        is_hot,
        price,
        point_value,
      },
    });
  } catch (error) {
    console.error('Kahve eklenirken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};