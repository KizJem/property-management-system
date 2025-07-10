const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// Create a new history log
router.post('/', (req, res) => {
  const { booking_id, user_id, action } = req.body;
  const sql = `
    INSERT INTO pms_history (booking_id, user_id, action, time)
    VALUES (?, ?, ?, datetime('now'))
  `;
  db.run(sql, [booking_id, user_id, action], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'History created', history_id: this.lastID });
  });
});

// Get all history logs
router.get('/', (req, res) => {
  const sql = `
    SELECT h.*, 
           b.booking_id,
           u.name AS user_name
    FROM pms_history h
    JOIN pms_booking b ON h.booking_id = b.booking_id
    JOIN pms_user u ON h.user_id = u.user_id
    ORDER BY h.time DESC
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// Get history log by ID
router.get('/:id', (req, res) => {
  const sql = `
    SELECT h.*, 
           b.booking_id,
           u.name AS user_name
    FROM pms_history h
    JOIN pms_booking b ON h.booking_id = b.booking_id
    JOIN pms_user u ON h.user_id = u.user_id
    WHERE h.history_id = ?
  `;
  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'History not found' });
    res.json(row);
  });
});

// Delete a history log (optional)
router.delete('/:id', (req, res) => {
  const sql = `DELETE FROM pms_history WHERE history_id = ?`;
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'History not found' });
    res.json({ message: 'History deleted successfully' });
  });
});

module.exports = router;
