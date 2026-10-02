const express = require('express');
const path = require('path');
const Database = require('./database');

const app = express();
const db = new Database();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

// API Endpoints

// Create a new poll
app.post('/api/polls', (req, res) => {
  const { title, options, closesAt } = req.body;
  
  if (!title || !options || !Array.isArray(options) || options.length < 2) {
    return res.status(400).json({ error: 'Title and at least 2 options are required' });
  }
  
  if (!closesAt) {
    return res.status(400).json({ error: 'closesAt date is required' });
  }
  
  db.createPoll(title, options, closesAt, (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Failed to create poll' });
    }
    
    res.json({
      success: true,
      pollId: result.pollId,
      shareToken: result.shareToken,
      shareUrl: `${req.protocol}://${req.get('host')}/vote/${result.shareToken}`
    });
  });
});

// Get poll by token
app.get('/api/polls/:shareToken', (req, res) => {
  const { shareToken } = req.params;
  
  db.getPollByToken(shareToken, (err, poll) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Failed to fetch poll' });
    }
    
    if (!poll) {
      return res.status(404).json({ error: 'Poll not found' });
    }
    
    res.json(poll);
  });
});

// Submit a vote
app.post('/api/polls/:shareToken/vote', (req, res) => {
  const { shareToken } = req.params;
  const { optionId } = req.body;
  
  if (!optionId) {
    return res.status(400).json({ error: 'optionId is required' });
  }
  
  db.vote(shareToken, optionId, (err, result) => {
    if (err) {
      console.error(err);
      return res.status(400).json({ error: err.message });
    }
    
    res.json({ success: true, voteId: result.voteId });
  });
});

// Get poll results
app.get('/api/polls/:shareToken/results', (req, res) => {
  const { shareToken } = req.params;
  
  db.getResults(shareToken, (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Failed to fetch results' });
    }
    
    res.json(data);
  });
});

// Serve HTML pages
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});

app.get('/vote/:shareToken', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'vote.html'));
});

// Start server
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Friday Snack Vote app running on port ${PORT}`);
  });
}

module.exports = app;
