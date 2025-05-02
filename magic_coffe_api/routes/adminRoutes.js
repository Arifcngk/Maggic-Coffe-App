const express = require("express");
const router = express.Router();
const adminController = require("../controller/adminController");
const coffeeController = require("../controller/coffeeController");
const upload = require("../middleware/uploadMiddleware");

// Coffee routes
router.get("/coffees", coffeeController.getCoffeeManagementPage);
router.post("/coffees", upload.single("image"), coffeeController.addCoffee);
router.delete("/coffees/:id", coffeeController.deleteCoffee);
router.put(
  "/coffees/:id",
  upload.single("image"),
  coffeeController.updateCoffee
);

// Branch routes
router.get("/branches", adminController.getAllBranches);
router.post("/branches", adminController.addBranch);
router.delete("/branches/:id", adminController.deleteBranch);

// Barista routes
router.get("/baristas", adminController.getAllBaristas);
router.post("/baristas", adminController.addBarista);
router.delete("/baristas/:id", adminController.deleteBarista);

module.exports = router;
