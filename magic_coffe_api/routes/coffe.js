const express = require('express');
const { getAllCoffees, addCoffee } = require('../controller/coffeController');
const multer = require('multer');

const router = express.Router();
const upload = multer({ dest: 'public/images' }); // Geçici çözüm, server.js'deki storage kullanılacak

router.get('/coffees', getAllCoffees);
router.post('/coffees', upload.single('image'), addCoffee); // 'image' form-data anahtarı

module.exports = router;