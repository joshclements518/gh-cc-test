const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');
const crypto = require('crypto');

// In-memory database (in a real app, use a proper database)
const db = {
  polls: new Map(),
  votes: new Map()
};

const PORT = process.env.PORT || 3000;

// Generate a share token
function generateToken() {
  return crypto.randomBytes(16).toString('hex');
}

// Request handler
function handleRequest(req, res) {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;
  const method = req.method;

  // CORS headers for local development
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  // Serve static files
  if (pathname === '/' || pathname === '/index.html') {
    serveFile(res, 'public/index.html', 'text/html');
  } else if (pathname === '/vote.html') {
    serveFile(res, 'public/vote.html', 'text/html');
  } else if (pathname === '/success.html') {
    serveFile(res, 'public/success.html', 'text/html');
  } else if (pathname === '/styles.css') {
    serveFile(res, 'public/styles.css', 'text/css');
  }
  // API endpoints
  else if (pathname === '/api/poll' && method === 'POST') {
    handleCreatePoll(req, res);
  } else if (pathname.startsWith('/api/poll/') && method === 'GET') {
    handleGetPoll(req, res, pathname);
  } else if (pathname === '/api/vote' && method === 'POST') {
    handleVote(req, res);
  } else if (pathname.startsWith('/api/results/') && method === 'GET') {
    handleGetResults(req, res, pathname);
  } else {
    res.writeHead(404);
    res.end('Not Found');
  }
}

// Serve static files
function serveFile(res, filePath, contentType) {
  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('File not found');
      return;
    }
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
}

// Create a new poll
function handleCreatePoll(req, res) {
  let body = '';
  req.on('data', chunk => {
    body += chunk.toString();
  });
  req.on('end', () => {
    try {
      const data = JSON.parse(body);
      const { title, options, closesAt } = data;

      if (!title || !options || !Array.isArray(options) || options.length < 2) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Invalid poll data' }));
        return;
      }

      const shareToken = generateToken();
      const poll = {
        id: Date.now().toString(),
        title,
        options: options.map((opt, idx) => ({
          id: idx,
          text: opt,
          votes: 0
        })),
        closesAt: closesAt ? new Date(closesAt) : null,
        shareToken,
        createdAt: new Date()
      };

      db.polls.set(shareToken, poll);
      db.votes.set(shareToken, new Set());

      res.writeHead(201, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        shareToken,
        shareUrl: `http://localhost:${PORT}/vote.html?token=${shareToken}`
      }));
    } catch (error) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Invalid JSON' }));
    }
  });
}

// Get poll by share token
function handleGetPoll(req, res, pathname) {
  const token = pathname.split('/').pop();
  const poll = db.polls.get(token);

  if (!poll) {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Poll not found' }));
    return;
  }

  // Check if poll is closed
  if (poll.closesAt && new Date() > poll.closesAt) {
    res.writeHead(403, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Poll is closed' }));
    return;
  }

  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    title: poll.title,
    options: poll.options.map(opt => ({ id: opt.id, text: opt.text })),
    closesAt: poll.closesAt
  }));
}

// Submit a vote
function handleVote(req, res) {
  let body = '';
  req.on('data', chunk => {
    body += chunk.toString();
  });
  req.on('end', () => {
    try {
      const data = JSON.parse(body);
      const { token, optionId, voterId } = data;

      const poll = db.polls.get(token);
      if (!poll) {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Poll not found' }));
        return;
      }

      // Check if poll is closed
      if (poll.closesAt && new Date() > poll.closesAt) {
        res.writeHead(403, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Poll is closed' }));
        return;
      }

      // Check if already voted (simple check using voterId)
      const voters = db.votes.get(token);
      if (voters.has(voterId)) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Already voted' }));
        return;
      }

      // Record vote
      const option = poll.options.find(opt => opt.id === optionId);
      if (!option) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Invalid option' }));
        return;
      }

      option.votes++;
      voters.add(voterId);

      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ success: true }));
    } catch (error) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Invalid JSON' }));
    }
  });
}

// Get poll results
function handleGetResults(req, res, pathname) {
  const token = pathname.split('/').pop();
  const poll = db.polls.get(token);

  if (!poll) {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Poll not found' }));
    return;
  }

  // Find winner
  const sortedOptions = [...poll.options].sort((a, b) => b.votes - a.votes);
  const winner = sortedOptions[0];

  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    title: poll.title,
    options: poll.options,
    winner: winner.votes > 0 ? winner : null,
    totalVotes: poll.options.reduce((sum, opt) => sum + opt.votes, 0)
  }));
}

// Create server
const server = http.createServer(handleRequest);

// Only start server if this file is run directly
if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`Friday Snack Vote server running on http://localhost:${PORT}`);
  });
} else {
  // For testing, start server but allow it to be controlled
  module.exports = {
    server,
    start: (callback) => {
      server.listen(PORT, callback);
      return server;
    },
    stop: (callback) => {
      server.close(callback);
    }
  };
}
