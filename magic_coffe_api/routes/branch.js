const express = require("express");
const router = express.Router();
const branchController = require("../controller/branchController");
const authenticateToken = require("../middleware/authMiddleware");

router.get("/branches", branchController.getAllBranches);
router.get(
  "/branches/:branchId/baristas",
  authenticateToken,
  branchController.getBranchBaristas
);

module.exports = router;
