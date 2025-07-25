const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('./db/connection'); // Import your SQLite connection

const app = express();
const port = 3000;
const SECRET_KEY = 'your-secret-key-here';

app.use(express.json());

// Updated login endpoint
app.post('/api/v1/login', async (req, res) => {
  const { username, password, name } = req.body;

  if (!username || !password || !name) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Validate default credentials
    if (username !== 'frontdesk' || password !== 'frontdeskpms') {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Check if user with the same name already exists
    db.get(
      'SELECT * FROM pms_user WHERE name = ? AND username = ? AND password = ?',
      [name, username, password],
      async (err, existingUser) => {
        if (err) {
          console.error('Database error:', err.message);
          return res.status(500).json({ message: 'Database error' });
        }

        let userId;

        if (existingUser) {
          // User already exists, use existing ID
          userId = existingUser.user_id;
        } else {
          // Insert new user with the default credentials
          db.run(
            'INSERT INTO pms_user (username, password, name) VALUES (?, ?, ?)',
            [username, password, name],
            function (err) {
              if (err) {
                console.error('Insert error:', err.message);
                return res.status(500).json({ message: 'Insert failed' });
              }

              userId = this.lastID;

              const token = jwt.sign({ userId }, SECRET_KEY, { expiresIn: '1h' });

              return res.json({
                message: 'Login successful',
                token,
                user: { id: userId, name }
              });
            }
          );
          return;
        }

        // If existing user found, return success
        const token = jwt.sign({ userId }, SECRET_KEY, { expiresIn: '1h' });

        return res.json({
          message: 'Login successful',
          token,
          user: { id: userId, name }
        });
      }
    );
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});


// Protected route example
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

// Middleware to authenticate JWT token
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
