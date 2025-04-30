const express = require('express');
const router = express.Router();
const loyaltyController = require('../controller/loyaltyController');
const authMiddleware = require('../middleware/authMiddleware');

// Tüm route'lar için authentication gerekli
router.use(authMiddleware);

// Kullanıcı puanlarını getir
router.get('/points', loyaltyController.getUserPoints);

// Haftalık sipariş sayısını getir
router.get('/weekly-orders', loyaltyController.getWeeklyOrderCount);

// Kahve geçmişini getir
router.get('/history', loyaltyController.getCoffeeHistory);

// Puanları güncelle
router.post('/update-points', loyaltyController.updatePoints);

module.exports = router; 