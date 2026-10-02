const http = require('http');
const url = require('url');
const fs = require('fs');
const path = require('path');
const db = require('./db');

const PORT = process.env.PORT || 3000;

// Helper function to parse request body
function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        resolve(JSON.parse(body));
      } catch (e) {
        resolve({});
      }
    });
    req.on('error', reject);
  });
}

// Helper function to send JSON response
function sendJSON(res, statusCode, data) {
  res.writeHead(statusCode, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

// API: Create a new poll
function createPoll(req, res) {
  parseBody(req).then(data => {
    const { title, options } = data;
    
    if (!title || !options || !Array.isArray(options) || options.length < 2) {
      return sendJSON(res, 400, { error: 'Poll must have a title and at least 2 options' });
    }

    try {
      const insertPoll = db.prepare('INSERT INTO polls (title) VALUES (?)');
      const insertOption = db.prepare('INSERT INTO poll_options (poll_id, option_text) VALUES (?, ?)');
      
      const transaction = db.transaction((title, options) => {
        const result = insertPoll.run(title);
        const pollId = result.lastInsertRowid;
        
        for (const option of options) {
          insertOption.run(pollId, option);
        }
        
        return pollId;
      });
      
      const pollId = transaction(title, options);
      
      sendJSON(res, 201, { id: pollId, title, options });
    } catch (error) {
      console.error('Error creating poll:', error);
      sendJSON(res, 500, { error: 'Failed to create poll' });
    }
  });
}

// API: Get poll details with results
function getPoll(req, res, pollId) {
  try {
    const poll = db.prepare('SELECT * FROM polls WHERE id = ?').get(pollId);
    
    if (!poll) {
      return sendJSON(res, 404, { error: 'Poll not found' });
    }
    
    const options = db.prepare(`
      SELECT 
        po.id,
        po.option_text,
        COUNT(v.id) as vote_count
      FROM poll_options po
      LEFT JOIN votes v ON po.id = v.option_id
      WHERE po.poll_id = ?
      GROUP BY po.id
    `).all(pollId);
    
    const totalVotes = options.reduce((sum, opt) => sum + opt.vote_count, 0);
    
    sendJSON(res, 200, {
      id: poll.id,
      title: poll.title,
      created_at: poll.created_at,
      options: options.map(opt => ({
        id: opt.id,
        text: opt.option_text,
        votes: opt.vote_count,
        percentage: totalVotes > 0 ? Math.round((opt.vote_count / totalVotes) * 100) : 0
      })),
      total_votes: totalVotes
    });
  } catch (error) {
    console.error('Error fetching poll:', error);
    sendJSON(res, 500, { error: 'Failed to fetch poll' });
  }
}

// API: Vote on a poll
function castVote(req, res, pollId) {
  parseBody(req).then(data => {
    const { option_id } = data;
    
    if (!option_id) {
      return sendJSON(res, 400, { error: 'option_id is required' });
    }

    try {
      // Verify option belongs to this poll
      const option = db.prepare(`
        SELECT id FROM poll_options 
        WHERE id = ? AND poll_id = ?
      `).get(option_id, pollId);
      
      if (!option) {
        return sendJSON(res, 404, { error: 'Invalid option for this poll' });
      }
      
      // Insert vote
      const insert = db.prepare('INSERT INTO votes (poll_id, option_id) VALUES (?, ?)');
      insert.run(pollId, option_id);
      
      sendJSON(res, 201, { message: 'Vote recorded', poll_id: pollId, option_id });
    } catch (error) {
      console.error('Error casting vote:', error);
      sendJSON(res, 500, { error: 'Failed to cast vote' });
    }
  });
}

// Serve static files
function serveStatic(res, filePath) {
  const extname = path.extname(filePath);
  const contentTypes = {
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'text/javascript',
  };
  
  const contentType = contentTypes[extname] || 'text/plain';
  
  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(404);
      res.end('Not found');
      return;
    }
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(content);
  });
}

// Main request handler
const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const pathname = parsedUrl.pathname;
  
  // Enable CORS for development
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }
  
  // API routes
  if (pathname === '/polls' && req.method === 'POST') {
    return createPoll(req, res);
  }
  
  const pollMatch = pathname.match(/^\/polls\/(\d+)$/);
  if (pollMatch && req.method === 'GET') {
    return getPoll(req, res, pollMatch[1]);
  }
  
  const voteMatch = pathname.match(/^\/polls\/(\d+)\/votes$/);
  if (voteMatch && req.method === 'POST') {
    return castVote(req, res, voteMatch[1]);
  }
  
  // Static files
  if (pathname === '/' || pathname === '/index.html') {
    return serveStatic(res, path.join(__dirname, 'public', 'index.html'));
  }
  
  if (pathname.startsWith('/public/')) {
    return serveStatic(res, path.join(__dirname, pathname));
  }
  
  // 404
  res.writeHead(404);
  res.end('Not found');
});

server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

module.exports = server;
