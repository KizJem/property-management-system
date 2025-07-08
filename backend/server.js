// server.js

require('dotenv').config();
const express = require('express');
const path = require('path');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Static file for testing HTML form (optional)
app.use(express.static(path.join(__dirname, 'public')));

// Route imports
const userRoutes = require('./routes/users');

// Route usage
app.use('/api/users', userRoutes);

// Default route
app.get('/', (req, res) => {
  res.send('PMS Backend API is running.');
});

// Start server
app.listen(PORT, () => {
  console.log(`✅ Server is running at http://localhost:${PORT}`);
});
