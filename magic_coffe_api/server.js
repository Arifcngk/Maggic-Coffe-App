const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const authRoutes = require("./routes/auth");
const coffeeRoutes = require("./routes/coffee");
const creditCardRoutes = require("./routes/creditcard");
const branchRoutes = require("./routes/branch");
const orderRoutes = require("./routes/orders"); // Yeni rota
const loyaltyRoutes = require("./routes/loyalty"); // Yeni rota
const adminRoutes = require("./routes/admin");

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

// Statik dosyaları servis et
app.use(express.static("public"));

// View engine ayarla
app.set("view engine", "ejs");
app.set("views", "views");

app.use("/api/auth", authRoutes);
app.use("/api", coffeeRoutes);
app.use("/api", branchRoutes);
app.use("/api", creditCardRoutes);
app.use("/api/orders", orderRoutes); // Yeni rota
app.use("/api/loyalty", loyaltyRoutes); // Yeni rota
app.use("/admin", adminRoutes);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
