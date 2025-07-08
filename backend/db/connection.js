// db/connection.js

const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Create or open the SQLite database file at /db/pms.db
const dbPath = path.resolve(__dirname, 'pms.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('❌ Failed to connect to SQLite DB:', err.message);
  } else {
    console.log('✅ Connected to SQLite database at', dbPath);
  }
});

module.exports = db;
