const express = require("express");
const cors = require("cors");
const app = express();

// Import routes
const adminRoutes = require("./routes/admin");
const ordersRoutes = require("./routes/ordersRoutes");
const productsRoutes = require("./routes/productsRoutes");
const branchesRoutes = require("./routes/branchesRoutes");
const baristasRoutes = require("./routes/baristasRoutes");
const authRoutes = require("./routes/auth");
const coffeeRoutes = require("./routes/coffees");
const orderRoutes = require("./routes/orders");
const baristaRoutes = require("./routes/baristas");

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use("/api", adminRoutes);
app.use("/api", ordersRoutes);
app.use("/api", productsRoutes);
app.use("/api", branchesRoutes);
app.use("/api", baristasRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/coffees", coffeeRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/baristas", baristaRoutes);

// Statik dosyaları servis et
app.use(express.static("public"));

// Admin route'larını ekle
app.use("/admin", adminRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Something went wrong!" });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
