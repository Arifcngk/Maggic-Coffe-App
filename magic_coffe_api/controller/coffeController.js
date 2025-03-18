const pool = require('../db');

exports.getAllCoffees = async (req, res) => {
  try {
    const [coffees] = await pool.query('SELECT * FROM coffees');
    res.status(200).json(coffees);
  } catch (error) {
    console.error('Kahve listesi alınırken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};

exports.addCoffee = async (req, res) => {
  const { coffee_name, volume_ml, is_hot, price } = req.body;
  const imageFile = req.file; // Multer'dan gelen dosya

  try {
    if (!imageFile) {
      return res.status(400).json({ message: 'Fotoğraf dosyası gerekli' });
    }

    const imageUrl = `/images/${imageFile.filename}`; // Fotoğrafın URL'si

    const [result] = await pool.query(
      'INSERT INTO coffees (coffee_name, image_url, volume_ml, is_hot, price) VALUES (?, ?, ?, ?, ?)',
      [coffee_name, imageUrl, volume_ml, is_hot, price]
    );

    res.status(201).json({ 
      message: 'Kahve başarıyla eklendi',
      coffeeId: result.insertId,
      imageUrl: imageUrl
    });
  } catch (error) {
    console.error('Kahve eklenirken hata:', error);
    res.status(500).json({ message: 'Sunucu hatası', error: error.message });
  }
};

