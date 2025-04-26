const express = require("express");
const router = express.Router();
const coffeeController = require("../controller/coffeeController");
const authMiddleware = require("../middleware/authMiddleware");

// GET /api/coffees - Tüm kahveleri getir
router.get("/coffees", authMiddleware, coffeeController.getAllCoffees);

// POST /api/coffees - Yeni kahve ekle
router.post("/coffees", authMiddleware, coffeeController.addCoffee);

module.exports = router;
