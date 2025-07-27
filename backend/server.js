const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('./db/connection'); // SQLite connection

const app = express();
const port = 3000;
const SECRET_KEY = 'your-secret-key-here';

app.use(express.json());

// ---------------- USER LOGIN ----------------
app.post('/api/v1/login', async (req, res) => {
  const { username, password, name } = req.body;

  if (!username || !password || !name) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    if (username !== 'frontdesk' || password !== 'frontdeskpms') {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    db.get(
      'SELECT * FROM pms_user WHERE name = ? AND username = ? AND password = ?',
      [name, username, password],
      (err, existingUser) => {
        if (err) {
          console.error('Database error:', err.message);
          return res.status(500).json({ message: 'Database error' });
        }

        if (existingUser) {
          const token = jwt.sign({ userId: existingUser.user_id }, SECRET_KEY, { expiresIn: '1h' });
          return res.json({
            message: 'Login successful',
            token,
            user: { id: existingUser.user_id, name },
          });
        }

        // Insert new user
        db.run(
          'INSERT INTO pms_user (username, password, name) VALUES (?, ?, ?)',
          [username, password, name],
          function (err) {
            if (err) {
              console.error('Insert error:', err.message);
              return res.status(500).json({ message: 'Insert failed' });
            }

            const token = jwt.sign({ userId: this.lastID }, SECRET_KEY, { expiresIn: '1h' });

            return res.json({
              message: 'Login successful',
              token,
              user: { id: this.lastID, name },
            });
          }
        );
      }
    );
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// ---------------- ADMIN LOGIN ----------------
app.post('/api/v1/admin-login', (req, res) => {
  const { username, password, name } = req.body;

  if (!username || !password || !name) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  if (username !== 'admin' || password !== 'adminpms') {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  db.get(
    'SELECT * FROM pms_admin WHERE name = ? AND admin_username = ? AND admin_password = ?',
    [name, username, password],
    (err, existingAdmin) => {
      if (err) {
        console.error('Database error:', err.message);
        return res.status(500).json({ message: 'Database error' });
      }

      if (existingAdmin) {
        return res.json({
          message: 'Login successful',
          user: { id: existingAdmin.admin_id, name },
        });
      }

      // Insert new admin name
      db.run(
        'INSERT INTO pms_admin (admin_username, admin_password, name) VALUES (?, ?, ?)',
        [username, password, name],
        function (err) {
          if (err) {
            console.error('Insert error:', err.message);
            return res.status(500).json({ message: 'Insert failed' });
          }

          return res.json({
            message: 'Login successful',
            user: { id: this.lastID, name },
          });
        }
      );
    }
  );
});

// ---------------- USER PROFILE (Protected) ----------------
app.get('/api/v1/profile', authenticateToken, (req, res) => {
  db.get(
    'SELECT user_id as id, username as username, name FROM pms_user WHERE user_id = ?',
    [req.user.userId],
    (err, user) => {
      if (err || !user) {
        return res.status(404).json({ message: 'User not found' });
      }
      res.json(user);
    }
  );
});

// ---------------- AUTH MIDDLEWARE ----------------
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401);

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
