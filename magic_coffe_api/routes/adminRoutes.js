const express = require("express");
const router = express.Router();
const adminController = require("../controller/adminController");

// Coffee routes
router.get("/coffees", adminController.getAllCoffees);
router.post("/coffees", adminController.addCoffee);
router.delete("/coffees/:id", adminController.deleteCoffee);

// Branch routes
router.get("/branches", adminController.getAllBranches);
router.post("/branches", adminController.addBranch);
router.delete("/branches/:id", adminController.deleteBranch);

// Barista routes
router.get("/baristas", adminController.getAllBaristas);
router.post("/baristas", adminController.addBarista);
router.delete("/baristas/:id", adminController.deleteBarista);

module.exports = router;
