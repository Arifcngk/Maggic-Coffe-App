const express = require("express");
const router = express.Router();
const coffeeController = require("../controller/coffeeController");

// Kahve yönetimi sayfası
router.get("/coffees", coffeeController.getCoffeeManagementPage);

// Yeni kahve ekleme
router.post("/coffees", coffeeController.addCoffee);

// Kahve silme
router.delete("/coffees/:id", coffeeController.deleteCoffee);

module.exports = router;
