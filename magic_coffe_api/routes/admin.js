const express = require("express");
const router = express.Router();
const coffeeController = require("../controller/coffeeController");
const path = require("path");

// Kahve yönetimi sayfası
router.get("/coffees", coffeeController.getCoffeeManagementPage);

// Yeni kahve ekleme
router.post("/coffees", coffeeController.addCoffee);

// Kahve silme
router.delete("/coffees/:id", coffeeController.deleteCoffee);

// Admin paneli ana sayfası
router.get("/coffees", (req, res) => {
  res.render("coffee-management/index");
});

// Barista paneli
router.get("/barista", (req, res) => {
  res.render("barista/index");
});

module.exports = router;
