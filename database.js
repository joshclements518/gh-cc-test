const sqlite3 = require('sqlite3').verbose();
const { v4: uuidv4 } = require('uuid');

class Database {
  constructor(dbPath = './snack-vote.db') {
    this.db = new sqlite3.Database(dbPath);
    this.init();
  }

  init() {
    this.db.serialize(() => {
      // Create polls table
      this.db.run(`
        CREATE TABLE IF NOT EXISTS polls (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          shareToken TEXT UNIQUE NOT NULL,
          closesAt TEXT NOT NULL,
          createdAt TEXT DEFAULT CURRENT_TIMESTAMP
        )
      `);

      // Create options table
      this.db.run(`
        CREATE TABLE IF NOT EXISTS options (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          pollId INTEGER NOT NULL,
          text TEXT NOT NULL,
          FOREIGN KEY (pollId) REFERENCES polls(id)
        )
      `);

      // Create votes table
      this.db.run(`
        CREATE TABLE IF NOT EXISTS votes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          pollId INTEGER NOT NULL,
          optionId INTEGER NOT NULL,
          votedAt TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (pollId) REFERENCES polls(id),
          FOREIGN KEY (optionId) REFERENCES options(id)
        )
      `);
    });
  }

  createPoll(title, options, closesAt, callback) {
    const shareToken = uuidv4();
    
    this.db.run(
      'INSERT INTO polls (title, shareToken, closesAt) VALUES (?, ?, ?)',
      [title, shareToken, closesAt],
      function(err) {
        if (err) return callback(err);
        
        const pollId = this.lastID;
        const optionInserts = options.map(opt => 
          new Promise((resolve, reject) => {
            this.db.run(
              'INSERT INTO options (pollId, text) VALUES (?, ?)',
              [pollId, opt],
              (err) => err ? reject(err) : resolve()
            );
          })
        );
        
        Promise.all(optionInserts)
          .then(() => callback(null, { pollId, shareToken }))
          .catch(callback);
      }.bind(this)
    );
  }

  getPollByToken(shareToken, callback) {
    this.db.get(
      'SELECT * FROM polls WHERE shareToken = ?',
      [shareToken],
      (err, poll) => {
        if (err) return callback(err);
        if (!poll) return callback(null, null);
        
        this.db.all(
          'SELECT * FROM options WHERE pollId = ?',
          [poll.id],
          (err, options) => {
            if (err) return callback(err);
            callback(null, { ...poll, options });
          }
        );
      }
    );
  }

  vote(shareToken, optionId, callback) {
    this.getPollByToken(shareToken, (err, poll) => {
      if (err) return callback(err);
      if (!poll) return callback(new Error('Poll not found'));
      
      // Check if poll is still open
      if (new Date(poll.closesAt) < new Date()) {
        return callback(new Error('Poll is closed'));
      }
      
      this.db.run(
        'INSERT INTO votes (pollId, optionId) VALUES (?, ?)',
        [poll.id, optionId],
        function(err) {
          if (err) return callback(err);
          callback(null, { voteId: this.lastID });
        }
      );
    });
  }

  getResults(shareToken, callback) {
    this.getPollByToken(shareToken, (err, poll) => {
      if (err) return callback(err);
      if (!poll) return callback(new Error('Poll not found'));
      
      this.db.all(
        `SELECT o.id, o.text, COUNT(v.id) as voteCount
         FROM options o
         LEFT JOIN votes v ON o.id = v.optionId
         WHERE o.pollId = ?
         GROUP BY o.id
         ORDER BY voteCount DESC`,
        [poll.id],
        (err, results) => {
          if (err) return callback(err);
          callback(null, { poll, results });
        }
      );
    });
  }

  close() {
    this.db.close();
  }
}

module.exports = Database;
