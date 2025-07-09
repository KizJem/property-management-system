const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// GET all rooms with room type name
router.get('/', (req, res) => {
  const sql = `
    SELECT r.room_id, r.room_number, rt.room_category, rt.price
    FROM pms_room r
    JOIN pms_room_type rt ON r.room_type_id = rt.room_type_id`;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// GET single room
router.get('/:id', (req, res) => {
  const sql = 'SELECT * FROM pms_room WHERE room_id = ?';
  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'Room not found' });
    res.json(row);
  });
});

// POST create room
router.post('/', (req, res) => {
  const { room_type_id, room_number } = req.body;
  const sql = `INSERT INTO pms_room (room_type_id, room_number) VALUES (?, ?)`;
  db.run(sql, [room_type_id, room_number], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ room_id: this.lastID, room_number });
  });
});

// PUT update room
router.put('/:id', (req, res) => {
  const { room_type_id, room_number } = req.body;
  const sql = `
    UPDATE pms_room
    SET room_type_id = ?, room_number = ?
    WHERE room_id = ?`;
  db.run(sql, [room_type_id, room_number, req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Room not found' });
    res.json({ message: 'Room updated successfully' });
  });
});

// DELETE room
router.delete('/:id', (req, res) => {
  const sql = 'DELETE FROM pms_room WHERE room_id = ?';
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Room not found' });
    res.json({ message: 'Room deleted successfully' });
  });
});

module.exports = router;
