const request = require('supertest');
const app = require('./server');
const Database = require('./database');

describe('Friday Snack Vote API', () => {
  let db;
  let testShareToken;

  beforeAll(() => {
    db = new Database(':memory:');
  });

  afterAll(() => {
    if (db) db.close();
  });

  describe('POST /api/polls', () => {
    it('should create a new poll with valid data', async () => {
      const response = await request(app)
        .post('/api/polls')
        .send({
          title: 'What snack for Friday?',
          options: ['Pizza', 'Tacos', 'Sushi'],
          closesAt: new Date(Date.now() + 86400000).toISOString()
        });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.shareToken).toBeDefined();
      expect(response.body.shareUrl).toContain('/vote/');
      
      testShareToken = response.body.shareToken;
    });

    it('should return 400 if title is missing', async () => {
      const response = await request(app)
        .post('/api/polls')
        .send({
          options: ['Pizza', 'Tacos'],
          closesAt: new Date(Date.now() + 86400000).toISOString()
        });

      expect(response.status).toBe(400);
      expect(response.body.error).toBeDefined();
    });

    it('should return 400 if less than 2 options', async () => {
      const response = await request(app)
        .post('/api/polls')
        .send({
          title: 'Test Poll',
          options: ['Pizza'],
          closesAt: new Date(Date.now() + 86400000).toISOString()
        });

      expect(response.status).toBe(400);
      expect(response.body.error).toContain('at least 2 options');
    });

    it('should return 400 if closesAt is missing', async () => {
      const response = await request(app)
        .post('/api/polls')
        .send({
          title: 'Test Poll',
          options: ['Pizza', 'Tacos']
        });

      expect(response.status).toBe(400);
      expect(response.body.error).toContain('closesAt');
    });
  });

  describe('GET /api/polls/:shareToken', () => {
    it('should return poll data for valid token', async () => {
      const response = await request(app)
        .get(`/api/polls/${testShareToken}`);

      expect(response.status).toBe(200);
      expect(response.body.title).toBe('What snack for Friday?');
      expect(response.body.options).toHaveLength(3);
      expect(response.body.options[0].text).toBe('Pizza');
    });

    it('should return 404 for invalid token', async () => {
      const response = await request(app)
        .get('/api/polls/invalid-token-123');

      expect(response.status).toBe(404);
      expect(response.body.error).toBe('Poll not found');
    });
  });

  describe('POST /api/polls/:shareToken/vote', () => {
    let pollOptions;

    beforeAll(async () => {
      const response = await request(app)
        .get(`/api/polls/${testShareToken}`);
      pollOptions = response.body.options;
    });

    it('should submit a vote successfully', async () => {
      const response = await request(app)
        .post(`/api/polls/${testShareToken}/vote`)
        .send({ optionId: pollOptions[0].id });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.voteId).toBeDefined();
    });

    it('should return 400 if optionId is missing', async () => {
      const response = await request(app)
        .post(`/api/polls/${testShareToken}/vote`)
        .send({});

      expect(response.status).toBe(400);
      expect(response.body.error).toContain('optionId');
    });

    it('should return error for closed poll', async () => {
      // Create a poll that's already closed
      const closedPollResponse = await request(app)
        .post('/api/polls')
        .send({
          title: 'Closed Poll',
          options: ['Option 1', 'Option 2'],
          closesAt: new Date(Date.now() - 1000).toISOString()
        });

      const closedToken = closedPollResponse.body.shareToken;
      const pollData = await request(app).get(`/api/polls/${closedToken}`);

      const voteResponse = await request(app)
        .post(`/api/polls/${closedToken}/vote`)
        .send({ optionId: pollData.body.options[0].id });

      expect(voteResponse.status).toBe(400);
      expect(voteResponse.body.error).toContain('closed');
    });
  });

  describe('GET /api/polls/:shareToken/results', () => {
    it('should return poll results', async () => {
      const response = await request(app)
        .get(`/api/polls/${testShareToken}/results`);

      expect(response.status).toBe(200);
      expect(response.body.poll).toBeDefined();
      expect(response.body.results).toBeDefined();
      expect(Array.isArray(response.body.results)).toBe(true);
      expect(response.body.results[0].voteCount).toBeGreaterThanOrEqual(0);
    });
  });
});
