const express = require('express')

//app configuration
const app = express();
const port = 3000;

//middleware configuration
app.use(express.json());

//API routes


//listners
app.listen(port , ()=>{
    console.log("listening on port ${port}");
})