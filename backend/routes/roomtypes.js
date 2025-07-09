const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// GET all room types
router.get('/', (req, res) => {
  const sql = 'SELECT * FROM pms_room_type';
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// GET one room type
router.get('/:id', (req, res) => {
  const sql = 'SELECT * FROM pms_room_type WHERE room_type_id = ?';
  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'Room type not found' });
    res.json(row);
  });
});

// POST create new room type
router.post('/', (req, res) => {
  const { room_category, description, price, no_guest, additional_guest_price } = req.body;
  const sql = `
    INSERT INTO pms_room_type (room_category, description, price, no_guest, additional_guest_price)
    VALUES (?, ?, ?, ?, ?)`;
  db.run(sql, [room_category, description, price, no_guest, additional_guest_price], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ room_type_id: this.lastID, room_category });
  });
});

// PUT update room type
router.put('/:id', (req, res) => {
  const { room_category, description, price, no_guest, additional_guest_price } = req.body;
  const sql = `
    UPDATE pms_room_type
    SET room_category = ?, description = ?, price = ?, no_guest = ?, additional_guest_price = ?
    WHERE room_type_id = ?`;
  db.run(sql, [room_category, description, price, no_guest, additional_guest_price, req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Room type not found' });
    res.json({ message: 'Room type updated successfully' });
  });
});

// DELETE room type
router.delete('/:id', (req, res) => {
  const sql = 'DELETE FROM pms_room_type WHERE room_type_id = ?';
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Room type not found' });
    res.json({ message: 'Room type deleted successfully' });
  });
});

module.exports = router;
