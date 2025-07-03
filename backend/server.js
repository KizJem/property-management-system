const express = require('express')

//app configuration
const app = express();
const port = 3000;

//middleware configuration
app.use(express.json());

//API routes
app.get('/api/v1/items', (req, res) =>{});
app.post('/api/v1/items', (req, res) =>{});
app.put('/api/v1/items/:id', (req, res) =>{});
app.delete('/api/v1/items/:id', (req, res) =>{});

//listners
app.listen(port , ()=>{
    console.log("listening on port ${port}");
})