const express = require('express')

//app configuration
const app = express();
const port = 3000;

//middleware configuration
app.use(express.json());

//API routes
//CRUD Operation
app.get('/api/v1/items', (req, res) => {});
app.get('/api/v1/items', (req, res) => {});

//listners
app.listen(port , ()=>{
    console.log("listening on port ${port}");
})