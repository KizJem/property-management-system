const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// Get all bookings with foreign key data
router.get('/', (req, res) => {
  const sql = `
    SELECT b.*, 
           g.first_name || ' ' || g.last_name AS guest_name,
           u.name AS user_name,
           r.room_number,
           rt.room_category,
           rt.price AS room_price,
           rt.no_guest,
           rt.additional_guest_price
    FROM pms_booking b
    JOIN pms_guest g ON b.guest_id = g.guest_id
    JOIN pms_user u ON b.user_id = u.user_id
    JOIN pms_room r ON b.room_id = r.room_id
    JOIN pms_room_type rt ON r.room_type_id = rt.room_type_id
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// GET one booking by ID
router.get('/:id', (req, res) => {
  const sql = `
    SELECT b.*, 
           g.first_name || ' ' || g.last_name AS guest_name,
           u.name AS user_name,
           r.room_number,
           rt.room_category,
           rt.price AS room_price,
           rt.no_guest,
           rt.additional_guest_price
    FROM pms_booking b
    JOIN pms_guest g ON b.guest_id = g.guest_id
    JOIN pms_user u ON b.user_id = u.user_id
    JOIN pms_room r ON b.room_id = r.room_id
    JOIN pms_room_type rt ON r.room_type_id = rt.room_type_id
    WHERE b.booking_id = ?
  `;

  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'Booking not found' });
    res.json(row);
  });
});


// Create new booking (basic data only)
router.post('/', (req, res) => {
  const {
    guest_id,
    room_id,
    user_id,
    status,
    check_in,
    check_out,
    no_days,
    guest_count,
    additional_guest,
    special_request,
    original_bill,
    total_bill,
    discount,
    payment_method
  } = req.body;

  const sql = `
    INSERT INTO pms_booking (
      guest_id, room_id, user_id, status, check_in, check_out,
      no_days, guest_count, additional_guest, special_request,
      original_bill, total_bill, discount, payment_method
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const values = [
    guest_id, room_id, user_id, status, check_in, check_out,
    no_days, guest_count, additional_guest, special_request,
    original_bill, total_bill, discount, payment_method
  ];

  db.run(sql, values, function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Booking created', booking_id: this.lastID });
  });
});

// Update booking 
router.put('/:id', (req, res) => {
  const {
    guest_id,
    room_id,
    user_id,
    status,
    check_in,
    check_out,
    no_days,
    guest_count,
    additional_guest,
    special_request,
    original_bill,
    total_bill,
    discount,
    payment_method
  } = req.body;

  const sql = `
    UPDATE pms_booking
    SET guest_id = ?, room_id = ?, user_id = ?, status = ?, check_in = ?, check_out = ?,
        no_days = ?, guest_count = ?, additional_guest = ?, special_request = ?,
        original_bill = ?, total_bill = ?, discount = ?, payment_method = ?
    WHERE booking_id = ?
  `;

  const values = [
    guest_id, room_id, user_id, status, check_in, check_out,
    no_days, guest_count, additional_guest, special_request,
    original_bill, total_bill, discount, payment_method, req.params.id
  ];

  db.run(sql, values, function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Booking not found' });
    res.json({ message: 'Booking updated successfully' });
  });
});

// Delete booking
router.delete('/:id', (req, res) => {
  const sql = 'DELETE FROM pms_booking WHERE booking_id = ?';
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'Booking not found' });
    res.json({ message: 'Booking deleted successfully' });
  });
});

module.exports = router;