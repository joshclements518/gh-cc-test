// In-memory database implementation (compatible with better-sqlite3 API)
class InMemoryDB {
  constructor() {
    this.polls = [];
    this.pollOptions = [];
    this.votes = [];
    this.pollIdCounter = 1;
    this.optionIdCounter = 1;
    this.voteIdCounter = 1;
  }

  prepare(sql) {
    const self = this;
    
    return {
      run(...params) {
        // INSERT INTO polls
        if (sql.includes('INSERT INTO polls')) {
          const id = self.pollIdCounter++;
          self.polls.push({
            id,
            title: params[0],
            created_at: new Date().toISOString()
          });
          return { lastInsertRowid: id };
        }
        
        // INSERT INTO poll_options
        if (sql.includes('INSERT INTO poll_options')) {
          const id = self.optionIdCounter++;
          self.pollOptions.push({
            id,
            poll_id: params[0],
            option_text: params[1]
          });
          return { lastInsertRowid: id };
        }
        
        // INSERT INTO votes
        if (sql.includes('INSERT INTO votes')) {
          const id = self.voteIdCounter++;
          self.votes.push({
            id,
            poll_id: params[0],
            option_id: params[1],
            created_at: new Date().toISOString()
          });
          return { lastInsertRowid: id };
        }
      },
      
      get(...params) {
        // SELECT poll by id
        if (sql.includes('SELECT * FROM polls WHERE id')) {
          return self.polls.find(p => p.id == params[0]);
        }
        
        // SELECT option by id and poll_id
        if (sql.includes('FROM poll_options') && sql.includes('WHERE id = ? AND poll_id')) {
          return self.pollOptions.find(o => o.id == params[0] && o.poll_id == params[1]);
        }
      },
      
      all(...params) {
        // SELECT options with vote counts
        if (sql.includes('FROM poll_options po') && sql.includes('LEFT JOIN votes')) {
          const pollId = params[0];
          const options = self.pollOptions.filter(o => o.poll_id == pollId);
          
          return options.map(opt => {
            const voteCount = self.votes.filter(v => v.option_id == opt.id).length;
            return {
              id: opt.id,
              option_text: opt.option_text,
              vote_count: voteCount
            };
          });
        }
      }
    };
  }

  transaction(fn) {
    return (...args) => fn(...args);
  }
}

const db = new InMemoryDB();

module.exports = db;
