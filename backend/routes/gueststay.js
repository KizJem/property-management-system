const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// GET all guest stay summaries
router.get('/', (req, res) => {
  const sql = `
    SELECT 
      g.guest_id,
      g.first_name || ' ' || g.last_name AS guest_name,
      COUNT(b.booking_id) AS total_bookings,
      SUM(b.no_days) AS total_nights,
      (
        SELECT r.room_number
        FROM pms_booking b2
        JOIN pms_room r ON r.room_id = b2.room_id
        WHERE b2.guest_id = g.guest_id
        GROUP BY r.room_number
        ORDER BY COUNT(*) DESC
        LIMIT 1
      ) AS most_used_room
    FROM pms_guest g
    LEFT JOIN pms_booking b ON g.guest_id = b.guest_id
    GROUP BY g.guest_id
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// GET detailed guest stay record by guest_id
router.get('/:guest_id', (req, res) => {
  const guest_id = req.params.guest_id;

  const guestQuery = `SELECT first_name || ' ' || last_name AS guest_name FROM pms_guest WHERE guest_id = ?`;
  const summaryQuery = `SELECT COUNT(*) AS total_bookings, SUM(no_days) AS total_nights FROM pms_booking WHERE guest_id = ?`;
  const mostUsedRoomQuery = `
    SELECT r.room_number, COUNT(*) AS times_used
    FROM pms_booking b
    JOIN pms_room r ON b.room_id = r.room_id
    WHERE b.guest_id = ?
    GROUP BY r.room_number
    ORDER BY times_used DESC
    LIMIT 1
  `;
  const historyQuery = `
    SELECT b.booking_id, r.room_number, b.check_in, b.check_out
    FROM pms_booking b
    JOIN pms_room r ON b.room_id = r.room_id
    WHERE b.guest_id = ?
    ORDER BY b.check_in DESC
  `;

  db.get(guestQuery, [guest_id], (err, guest) => {
    if (err || !guest) return res.status(404).json({ error: 'Guest not found' });

    db.get(summaryQuery, [guest_id], (err, summary) => {
      if (err) return res.status(500).json({ error: err.message });

      db.get(mostUsedRoomQuery, [guest_id], (err, mostUsed) => {
        if (err) return res.status(500).json({ error: err.message });

        db.all(historyQuery, [guest_id], (err, history) => {
          if (err) return res.status(500).json({ error: err.message });

          res.json({
            guest_name: guest.guest_name,
            total_bookings: summary.total_bookings || 0,
            total_nights: summary.total_nights || 0,
            most_used_room: mostUsed?.room_number || null,
            booking_history: history
          });
        });
      });
    });
  });
});

// GET guest stay record in a date range
router.get('/:guest_id/range', (req, res) => {
  const guest_id = req.params.guest_id;
  const { from, to } = req.query;

  if (!from || !to) {
    return res.status(400).json({ error: "Missing 'from' or 'to' date in query." });
  }

  const rangeSummaryQuery = `
    SELECT 
      COUNT(*) AS total_bookings,
      SUM(no_days) AS total_nights
    FROM pms_booking
    WHERE guest_id = ? AND check_in >= ? AND check_out <= ?
  `;

  const rangeHistoryQuery = `
    SELECT booking_id, check_in, check_out, room_id
    FROM pms_booking
    WHERE guest_id = ? AND check_in >= ? AND check_out <= ?
    ORDER BY check_in DESC
  `;

  db.get(rangeSummaryQuery, [guest_id, from, to], (err, summary) => {
    if (err) return res.status(500).json({ error: err.message });

    db.all(rangeHistoryQuery, [guest_id, from, to], (err, history) => {
      if (err) return res.status(500).json({ error: err.message });

      res.json({
        guest_id,
        range: { from, to },
        total_bookings: summary.total_bookings || 0,
        total_nights: summary.total_nights || 0,
        booking_history: history
      });
    });
  });
});

module.exports = router;
