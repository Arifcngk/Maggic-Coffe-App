const express = require("express");
const router = express.Router();
const authController = require("../controller/authController");
const authMiddleware = require("../middleware/authMiddleware");

router.post("/register", authController.register);
router.post("/login", authController.login);
router.get("/me", authMiddleware, authController.getUserInfo);

// Barista girişi
router.post("/barista-login", authController.baristaLogin);

// Barista yönetimi sayfası
router.get("/barista-management", authMiddleware, (req, res) => {
  res.render("barista-management/index");
});

module.exports = router;
