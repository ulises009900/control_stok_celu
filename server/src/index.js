const express = require('express');
const cors = require('cors');
const config = require('./config');
const authRoutes = require('./routes/auth');
const usersRoutes = require('./routes/users');
const syncRoutes = require('./routes/sync');
const healthRoutes = require('./routes/health');

const app = express();
app.use(cors());
app.use(express.json({ limit: '5mb' }));

app.use('/health', healthRoutes);
app.use('/auth', authRoutes);
app.use('/users', usersRoutes);
app.use('/sync', syncRoutes);

app.use((req, res) => {
  res.status(404).json({ error: 'Recurso no encontrado.' });
});

// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Error interno del servidor.' });
});

app.listen(config.apiPort, () => {
  console.log(`Control Stok Celu API escuchando en el puerto ${config.apiPort}`);
});
