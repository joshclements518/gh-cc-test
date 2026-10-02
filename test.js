const { test } = require('node:test');
const assert = require('node:assert');
const http = require('http');

const PORT = 3001;
process.env.PORT = PORT;

// Start server
const server = require('./server');

// Helper function to make HTTP requests
function request(method, path, body = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: PORT,
      path,
      method,
      headers: body ? { 'Content-Type': 'application/json' } : {}
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          resolve({
            statusCode: res.statusCode,
            body: data ? JSON.parse(data) : {}
          });
        } catch (e) {
          resolve({ statusCode: res.statusCode, body: data });
        }
      });
    });

    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

test('API Endpoints', async (t) => {
  await t.test('POST /polls - creates a new poll', async () => {
    const res = await request('POST', '/polls', {
      title: 'Test Poll',
      options: ['Option A', 'Option B', 'Option C']
    });

    assert.strictEqual(res.statusCode, 201);
    assert.ok(res.body.id);
    assert.strictEqual(res.body.title, 'Test Poll');
  });

  await t.test('POST /polls - validates required fields', async () => {
    const res = await request('POST', '/polls', {
      title: 'Test Poll'
    });

    assert.strictEqual(res.statusCode, 400);
    assert.ok(res.body.error);
  });

  await t.test('GET /polls/:id - retrieves poll with results', async () => {
    // First create a poll
    const createRes = await request('POST', '/polls', {
      title: 'Test Poll 2',
      options: ['A', 'B']
    });

    const pollId = createRes.body.id;

    // Then retrieve it
    const res = await request('GET', `/polls/${pollId}`);

    assert.strictEqual(res.statusCode, 200);
    assert.strictEqual(res.body.title, 'Test Poll 2');
    assert.strictEqual(res.body.options.length, 2);
    assert.strictEqual(res.body.total_votes, 0);
  });

  await t.test('POST /polls/:id/votes - casts a vote', async () => {
    // Create a poll
    const createRes = await request('POST', '/polls', {
      title: 'Vote Test',
      options: ['Yes', 'No']
    });

    const pollId = createRes.body.id;

    // Get poll to find option IDs
    const pollRes = await request('GET', `/polls/${pollId}`);
    const optionId = pollRes.body.options[0].id;

    // Cast a vote
    const voteRes = await request('POST', `/polls/${pollId}/votes`, {
      option_id: optionId
    });

    assert.strictEqual(voteRes.statusCode, 201);

    // Verify vote was recorded
    const updatedPoll = await request('GET', `/polls/${pollId}`);
    assert.strictEqual(updatedPoll.body.total_votes, 1);
    assert.strictEqual(updatedPoll.body.options[0].votes, 1);
  });

  await t.test('POST /polls/:id/votes - validates option_id', async () => {
    const res = await request('POST', '/polls/1/votes', {});

    assert.strictEqual(res.statusCode, 400);
    assert.ok(res.body.error);
  });

  await t.test('GET /polls/:id - returns 404 for non-existent poll', async () => {
    const res = await request('GET', '/polls/99999');

    assert.strictEqual(res.statusCode, 404);
    assert.ok(res.body.error);
  });
});

// Close server after tests
test.after(() => {
  server.close();
});
