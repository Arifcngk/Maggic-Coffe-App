const pool = require("../db");

async function listBaristas() {
  try {
    const [baristas] = await pool.query(
      "SELECT barista_id, first_name, last_name, email, specialty, branch_id FROM baristas"
    );

    console.log("\nMevcut Baristalar:");
    console.log("------------------");
    baristas.forEach((barista) => {
      console.log(`ID: ${barista.barista_id}`);
      console.log(`Ad Soyad: ${barista.first_name} ${barista.last_name}`);
      console.log(`Email: ${barista.email}`);
      console.log(`Uzmanlık: ${barista.specialty}`);
      console.log(`Şube ID: ${barista.branch_id}`);
      console.log("------------------");
    });
  } catch (error) {
    console.error("Hata:", error);
  } finally {
    process.exit();
  }
}

listBaristas();
