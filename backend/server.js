const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('./db/connection'); // Import your SQLite connection

const app = express();
const port = 3000;
const SECRET_KEY = 'your-secret-key-here';

app.use(express.json());

// Login endpoint
app.post('/api/v1/login', async (req, res) => {
  const { username, password, name } = req.body;

  if (!username || !password || !name) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Check if credentials match the default admin account
    if (username !== 'admin@example.com' || password !== 'admin') {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Check if user exists in database
    db.get(
      'SELECT * FROM pms_user WHERE user_email = ?',
      [username],
      async (err, user) => {
        if (err) {
          return res.status(500).json({ message: 'Database error' });
        }

        // Update name if changed (only for the admin account)
        if (user && user.name !== name) {
          db.run(
            'UPDATE pms_user SET name = ? WHERE user_email = ?',
            [name, username]
          );
        }

        const token = jwt.sign({ userId: user ? user.user_id : 1 }, SECRET_KEY, { expiresIn: '1h' });
        
        return res.json({ 
          message: 'Login successful',
          token,
          user: { id: user ? user.user_id : 1, name: name }
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
