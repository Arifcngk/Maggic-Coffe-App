const db = require("../config/database");

// Get all coffees
exports.getAllCoffees = async (req, res) => {
  try {
    console.log("Fetching all coffees...");
    const [coffees] = await db.query("SELECT * FROM coffees");
    console.log("Coffees found:", coffees);
    res.json(coffees);
  } catch (error) {
    console.error("Error fetching coffees:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Add new coffee
exports.addCoffee = async (req, res) => {
  const { name, price, volumeMl, imageUrl, isHot } = req.body;
  console.log("Adding new coffee:", { name, price, volumeMl, imageUrl, isHot });

  try {
    const [result] = await db.query(
      "INSERT INTO coffees (name, price, volumeMl, imageUrl, isHot) VALUES (?, ?, ?, ?, ?)",
      [name, price, volumeMl, imageUrl, isHot]
    );
    console.log("Coffee added successfully:", result);
    res.json({ id: result.insertId, message: "Coffee added successfully" });
  } catch (error) {
    console.error("Error adding coffee:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Delete coffee
exports.deleteCoffee = async (req, res) => {
  const { id } = req.params;
  console.log("Deleting coffee with ID:", id);

  try {
    await db.query("DELETE FROM coffees WHERE id = ?", [id]);
    console.log("Coffee deleted successfully");
    res.json({ message: "Coffee deleted successfully" });
  } catch (error) {
    console.error("Error deleting coffee:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Get all branches
exports.getAllBranches = async (req, res) => {
  try {
    console.log("Fetching all branches...");
    const [branches] = await db.query("SELECT * FROM branches");
    console.log("Branches found:", branches);
    res.json(branches);
  } catch (error) {
    console.error("Error fetching branches:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Add new branch
exports.addBranch = async (req, res) => {
  const { name, location } = req.body;
  console.log("Adding new branch:", { name, location });

  try {
    const [result] = await db.query(
      "INSERT INTO branches (name, location) VALUES (?, ?)",
      [name, location]
    );
    console.log("Branch added successfully:", result);
    res.json({ id: result.insertId, message: "Branch added successfully" });
  } catch (error) {
    console.error("Error adding branch:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Delete branch
exports.deleteBranch = async (req, res) => {
  const { id } = req.params;
  console.log("Deleting branch with ID:", id);

  try {
    await db.query("DELETE FROM branches WHERE id = ?", [id]);
    console.log("Branch deleted successfully");
    res.json({ message: "Branch deleted successfully" });
  } catch (error) {
    console.error("Error deleting branch:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Get all baristas
exports.getAllBaristas = async (req, res) => {
  try {
    console.log("Fetching all baristas...");
    const [baristas] = await db.query(`
            SELECT b.*, br.name as branchName 
            FROM baristas b 
            LEFT JOIN branches br ON b.branchId = br.id
        `);
    console.log("Baristas found:", baristas);
    res.json(baristas);
  } catch (error) {
    console.error("Error fetching baristas:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Add new barista
exports.addBarista = async (req, res) => {
  const { firstName, lastName, email, password, branchId, specialty } =
    req.body;
  console.log("Adding new barista:", {
    firstName,
    lastName,
    email,
    branchId,
    specialty,
  });

  try {
    const [result] = await db.query(
      "INSERT INTO baristas (firstName, lastName, email, password, branchId, specialty) VALUES (?, ?, ?, ?, ?, ?)",
      [firstName, lastName, email, password, branchId, specialty]
    );
    console.log("Barista added successfully:", result);
    res.json({ id: result.insertId, message: "Barista added successfully" });
  } catch (error) {
    console.error("Error adding barista:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};

// Delete barista
exports.deleteBarista = async (req, res) => {
  const { id } = req.params;
  console.log("Deleting barista with ID:", id);

  try {
    await db.query("DELETE FROM baristas WHERE id = ?", [id]);
    console.log("Barista deleted successfully");
    res.json({ message: "Barista deleted successfully" });
  } catch (error) {
    console.error("Error deleting barista:", error);
    res
      .status(500)
      .json({ error: "Internal server error", details: error.message });
  }
};
