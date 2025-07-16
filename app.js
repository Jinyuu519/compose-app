const { Client } = require('pg');
const express = require('express');
const app = express();

const client = new Client({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: parseInt(process.env.PGPORT) || 3306,
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: "OK",
    time: new Date(),
    db: "connected"
  });
});

client.connect()
  .then(() => console.log('Connected to DB'))
  .catch(err => console.error('DB connection failed:', err));


app.get('/', async (req, res) => {
  const result = await client.query('SELECT NOW()');
  res.send(`<h1>Connected to PostgreSQL @ ${result.rows[0].now}</h1>`);
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.listen(3000, () => {
  console.log('App listening on port 3000');
});

