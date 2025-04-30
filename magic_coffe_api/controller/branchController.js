const db = require("../db");

exports.getAllBranches = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM branches");
    res.status(200).json(rows);
  } catch (error) {
    console.error("Error fetching branches:", error);
    res.status(500).json({ message: "Error fetching branches" });
  }
};

exports.getBranchBaristas = async (req, res) => {
  const { branchId } = req.params;

  try {
    const [rows] = await db.query(
      "SELECT b.barista_id, CONCAT(b.first_name, ' ', b.last_name) as barista_name, b.email as barista_email FROM baristas b WHERE b.branch_id = ?",
      [branchId]
    );
    res.status(200).json(rows);
  } catch (error) {
    console.error("Error fetching branch baristas:", error);
    res.status(500).json({ message: "Error fetching branch baristas" });
  }
};
