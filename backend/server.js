const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// App configuration
const app = express();
const port = 3000;
const SECRET_KEY = 'your-secret-key-here'; // Replace with a real secret in production

// Middleware configuration
app.use(express.json());

// Mock database of users (in a real app, use a proper database)
let users = [
  {
    id: 1,
    username: 'student1',
    password: '$2b$10$examplehashedpassword', // Hashed "password123"
    name: 'John Doe'
  }
];

// API routes
app.post('/api/v1/login', async (req, res) => {
  const { username, password, name } = req.body;

  // Input validation
  if (!username || !password || !name) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // In a real app, you would look up the user in the database
    const user = users.find(u => u.username === username);
    
    if (!user) {
      // Create new user (for demo purposes - in real app, have separate registration)
      const hashedPassword = await bcrypt.hash(password, 10);
      const newUser = {
        id: users.length + 1,
        username,
        password: hashedPassword,
        name
      };
      users.push(newUser);
      
      // Generate token
      const token = jwt.sign({ userId: newUser.id }, SECRET_KEY, { expiresIn: '1h' });
      
      return res.status(201).json({ 
        message: 'User created and logged in',
        token,
        user: { id: newUser.id, name: newUser.name }
      });
    } else {
      // Verify password for existing user
      const passwordMatch = await bcrypt.compare(password, user.password);
      
      if (!passwordMatch) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }
      
      // Generate token
      const token = jwt.sign({ userId: user.id }, SECRET_KEY, { expiresIn: '1h' });
      
      return res.json({ 
        message: 'Login successful',
        token,
        user: { id: user.id, name: user.name }
      });
    }
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Protected route example
app.get('/api/v1/profile', authenticateToken, (req, res) => {
  const user = users.find(u => u.id === req.user.userId);
  if (!user) return res.status(404).json({ message: 'User not found' });
  
  res.json({ 
    id: user.id,
    username: user.username,
    name: user.name
  });
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

// Listener
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});