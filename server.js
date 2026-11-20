const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
  const urlPath = req.url.split('?')[0];
  const filePath = path.join(__dirname, 'preview', urlPath === '/' ? 'index.html' : urlPath);
  
  const ext = path.extname(filePath);
  const contentTypes = {
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'text/javascript',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.svg': 'image/svg+xml'
  };

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not Found');
    } else {
      res.writeHead(200, { 'Content-Type': contentTypes[ext] || 'application/octet-stream' });
      res.end(data);
    }
  });
});

server.listen(8080, () => {
  console.log('Server running on port 8080');
});
