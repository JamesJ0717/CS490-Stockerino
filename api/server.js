const http = require('http');
const app = require('./app');

const port = process.env.port || 3000;

const server = http.createServer(app.app);
console.log('Server listening on port', port);
server.listen(port);
