const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const authRoutes = require("./routes/auth");
const coffeeRoutes = require("./routes/coffee");
const creditCardRoutes = require("./routes/creditcard");
const branchRoutes = require("./routes/branch");
const orderRoutes = require("./routes/orders"); // Yeni rota
const loyaltyRoutes = require("./routes/loyalty"); // Yeni rota

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api", coffeeRoutes);
app.use("/api", branchRoutes);
app.use("/api", creditCardRoutes);
app.use("/api/orders", orderRoutes); // Yeni rota
app.use("/api/loyalty", loyaltyRoutes); // Yeni rota

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
