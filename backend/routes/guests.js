const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// GET all guests
router.get('/', (req, res) => {
  const sql = 'SELECT * FROM pms_guest';
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// GET one guest by ID
router.get('/:id', (req, res) => {
  const sql = 'SELECT * FROM pms_guest WHERE guest_id = ?';
  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'Guest not found' });
    res.json(row);
  });
});

// POST new guest
router.post('/', (req, res) => {
  const { first_name, last_name, guest_email } = req.body;
  const sql = `INSERT INTO pms_guest (first_name, last_name, guest_email) VALUES (?, ?, ?)`;
  db.run(sql, [first_name, last_name, guest_email], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ guest_id: this.lastID, first_name, last_name, guest_email });
  });
});

// PUT update guest
router.put('/:id', (req, res) => {
  const { first_name, last_name, guest_email } = req.body;
  const sql = `
    UPDATE pms_guest 
    SET first_name = ?, last_name = ?, guest_email = ?
    WHERE guest_id = ?
  `;
  db.run(sql, [first_name, last_name, guest_email, req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Guest not found' });
    res.json({ message: 'Guest updated successfully' });
  });
});

// DELETE guest
router.delete('/:id', (req, res) => {
  const sql = 'DELETE FROM pms_guest WHERE guest_id = ?';
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Guest not found' });
    res.json({ message: 'Guest deleted successfully' });
  });
});

module.exports = router;
