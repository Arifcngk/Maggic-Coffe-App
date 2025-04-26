const express = require("express");
const router = express.Router();
const {
  createOrder,
  getBranchOrders,
} = require("../controller/ordersController");
const authenticateToken = require("../middleware/authMiddleware");

router.post("/", authenticateToken, createOrder);
router.get("/", authenticateToken, getBranchOrders);

module.exports = router;
