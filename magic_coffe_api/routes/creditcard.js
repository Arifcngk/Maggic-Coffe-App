const express = require("express");
const router = express.Router();
const creditCardController = require("../controller/creditCardController");
const authMiddleware = require("../middleware/authMiddleware");

// GET /api/credit_cards - Kullanıcının kartlarını getir
router.get(
  "/credit_cards",
  authMiddleware,
  creditCardController.getCreditCards
);

// POST /api/credit_cards - Yeni kart ekle
router.post(
  "/credit_cards",
  authMiddleware,
  creditCardController.addCreditCard
);

// DELETE /api/credit_cards/:card_id - Kart sil
router.delete(
  "/credit_cards/:card_id",
  authMiddleware,
  creditCardController.deleteCreditCard
);

module.exports = router;
