const { WebSocketServer } = require('ws');
const jwt = require('jsonwebtoken');
const config = require('./config');

const clients = new Set();

function attachRealtime(httpServer) {
  const wss = new WebSocketServer({ server: httpServer, path: '/ws' });
  wss.on('connection', (socket, req) => {
    try {
      const url = new URL(req.url, 'http://localhost');
      const token = url.searchParams.get('token');
      if (!token) {
        socket.close(4401, 'Falta token');
        return;
      }
      const payload = jwt.verify(token, config.jwtSecret);
      socket.user = {
        id: payload.sub,
        username: payload.username,
        role: payload.role,
        displayName: payload.displayName,
      };
      socket.deviceId = url.searchParams.get('deviceId') || '';
      clients.add(socket);
      socket.on('close', () => clients.delete(socket));
    } catch (err) {
      socket.close(4401, 'Token inválido');
    }
  });
}

function broadcastChange(event) {
  const payload = JSON.stringify(event);
  for (const socket of clients) {
    if (socket.readyState !== 1) continue;
    if (event.deviceId && socket.deviceId === event.deviceId) continue;
    socket.send(payload);
  }
}

module.exports = { attachRealtime, broadcastChange };
