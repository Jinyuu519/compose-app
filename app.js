const { Client } = require('pg');
const express = require('express');
const app = express();

const client = new Client({
  user: 'demo',
  host: 'db',
  database: 'demo',
  password: 'demo',
  port: 5432,
});

client.connect();

app.get('/', async (req, res) => {
  const result = await client.query('SELECT NOW()');
  res.send(`<h1>Connected to PostgreSQL @ ${result.rows[0].now}</h1>`);
});

app.listen(3000, () => {
  console.log('App listening on port 3000');
});