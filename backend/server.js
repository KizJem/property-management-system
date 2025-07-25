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
    // Check if credentials match the default admin account
    if (username.trim() !== 'frontdesk' || password.trim() !== 'frontdeskpms') {
  return res.status(401).json({ message: 'Invalid credentials' });
}

    // Check if user with this name already exists
    db.get(
      'SELECT * FROM pms_user WHERE name = ?',
      [name],
      async (err, existingUser) => {
        if (err) {
          return res.status(500).json({ message: 'Database error' });
        }

        let userId;
        
        if (existingUser) {
          // User exists, use existing ID
          userId = existingUser.user_id;
        } else {
          // Insert new user with default credentials but new name
          const result = await new Promise((resolve, reject) => {
            db.run(
              'INSERT INTO pms_user (user_email, password, name) VALUES (?, ?, ?)',
              [username, password, name],
              function(err) {
                if (err) reject(err);
                else resolve(this.lastID);
              }
            );
          });
          userId = result;
        }

        // Generate token
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
    'SELECT user_id as id, user_email as username, name FROM pms_user WHERE user_id = ?',
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
