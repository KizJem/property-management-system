const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// GET all room statuses with joined data
router.get('/', (req, res) => {
  const sql = `
    SELECT rs.*, 
           r.room_number, 
           b.booking_id,
           rt.room_category
    FROM pms_room_status rs
    LEFT JOIN pms_room r ON rs.room_id = r.room_id
    LEFT JOIN pms_booking b ON rs.booking_id = b.booking_id
    LEFT JOIN pms_room_type rt ON r.room_type_id = rt.room_type_id
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// GET one room status by ID
router.get('/:id', (req, res) => {
  const sql = `
    SELECT rs.*, 
           r.room_number, 
           b.booking_id,
           rt.room_category
    FROM pms_room_status rs
    LEFT JOIN pms_room r ON rs.room_id = r.room_id
    LEFT JOIN pms_booking b ON rs.booking_id = b.booking_id
    LEFT JOIN pms_room_type rt ON r.room_type_id = rt.room_type_id
    WHERE rs.status_id = ?
  `;
  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'Room status not found' });
    res.json(row);
  });
});

// POST - Add a new room status
router.post('/', (req, res) => {
  const { room_id, booking_id, date, status, housekeeping_status } = req.body;
  const sql = `
    INSERT INTO pms_room_status (room_id, booking_id, date, status, housekeeping_status)
    VALUES (?, ?, ?, ?, ?)
  `;
  db.run(sql, [room_id, booking_id || null, date, status, housekeeping_status], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ status_id: this.lastID });
  });
});

// PUT - Update a room status
router.put('/:id', (req, res) => {
  const { room_id, booking_id, date, status, housekeeping_status } = req.body;
  const sql = `
    UPDATE pms_room_status
    SET room_id = ?, booking_id = ?, date = ?, status = ?, housekeeping_status = ?
    WHERE status_id = ?
  `;
  db.run(sql, [room_id, booking_id || null, date, status, housekeeping_status, req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Room status not found' });
    res.json({ message: 'Room status updated successfully' });
  });
});

// DELETE - Remove a room status
router.delete('/:id', (req, res) => {
  const sql = `DELETE FROM pms_room_status WHERE status_id = ?`;
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Room status not found' });
    res.json({ message: 'Room status deleted successfully' });
  });
});

module.exports = router;
