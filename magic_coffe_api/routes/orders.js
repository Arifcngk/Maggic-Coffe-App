const express = require("express");
const router = express.Router();
const {
  createOrder,
  getBranchOrders,
  getBaristaOrders,
  updateOrderStatus,
} = require("../controller/ordersController");
const authenticateToken = require("../middleware/authMiddleware");

router.post("/", authenticateToken, createOrder);
router.get("/", authenticateToken, getBranchOrders);
router.get("/barista", authenticateToken, getBaristaOrders);
router.put("/:orderId/status", authenticateToken, updateOrderStatus);

module.exports = router;
