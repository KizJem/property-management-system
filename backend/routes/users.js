// routes/users.js

const express = require('express');
const router = express.Router();
const db = require('../db/connection');

// GET all users
router.get('/', (req, res) => {
  const sql = 'SELECT * FROM pms_user';
  db.all(sql, [], (err, rows) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(rows);
  });
});

// GET one user by ID
router.get('/:id', (req, res) => {
  const sql = 'SELECT * FROM pms_user WHERE user_id = ?';
  db.get(sql, [req.params.id], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (!row) return res.status(404).json({ message: 'User not found' });
    res.json(row);
  });
});

// POST new user
router.post('/', (req, res) => {
  const { user_email, password, name } = req.body;
  const sql = `INSERT INTO pms_user (user_email, password, name) VALUES (?, ?, ?)`;
  db.run(sql, [user_email, password, name], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ user_id: this.lastID, user_email, name });
  });
});

// PUT update user
router.put('/:id', (req, res) => {
  const { user_email, password, name } = req.body;
  const sql = `
    UPDATE pms_user 
    SET user_email = ?, password = ?, name = ?
    WHERE user_id = ?
  `;
  db.run(sql, [user_email, password, name, req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'User not found' });
    res.json({ message: 'User updated successfully' });
  });
});

// DELETE user
router.delete('/:id', (req, res) => {
  const sql = 'DELETE FROM pms_user WHERE user_id = ?';
  db.run(sql, [req.params.id], function (err) {
    if (err) return res.status(500).json({ error: err.message });
    if (this.changes === 0) return res.status(404).json({ message: 'User not found' });
    res.json({ message: 'User deleted successfully' });
  });
});

module.exports = router;
