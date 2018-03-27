var express = require('express')
var app = express()
var jobProcessor = require('./jobProcessor');
var exec = require('exec');
const bodyParser = require('body-parser')

app.use(bodyParser.json())

app.get('/dbi/_healthcheck',(req, res) => {
  res.json({ uptime: process.uptime() });
});


app.post('/dbi/startBuild',(req, res) => {
  jobProcessor.startBuild(req,res);
});


app.listen(8083, function () {
  console.log('Example app listening on port 8083!')
})


