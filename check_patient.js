const mysql = require('mysql2/promise');
const { loadConfig } = require('./src/config');

async function run() {
  try {
    const config = loadConfig();
    const mysqlConn = await mysql.createConnection(config.mysql);
    console.log("Connected to MySQL.");

    console.log("\nRows in MySQL tbletest for E17030633:");
    let [rows] = await mysqlConn.execute("SELECT * FROM tbletest WHERE ClinicID = 'E17030633'");
    console.log(rows);

    console.log("\nRows in MySQL tblevmain for E17030633:");
    [rows] = await mysqlConn.execute("SELECT * FROM tblevmain WHERE ClinicID = 'E17030633'");
    console.log(rows);

  } catch (err) {
    console.error(err);
  }
  process.exit(0);
}

run();
