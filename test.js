const http = require('http');
const assert = require('assert');

// Start the server
const serverModule = require('./server');
const PORT = process.env.PORT || 3000;

// Helper function to make HTTP requests
function makeRequest(method, path, data = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: PORT,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          const parsed = body ? JSON.parse(body) : {};
          resolve({ status: res.statusCode, data: parsed });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });

    req.on('error', reject);
    
    if (data) {
      req.write(JSON.stringify(data));
    }
    
    req.end();
  });
}

// Run tests
async function runTests() {
  console.log('Running Friday Snack Vote tests...\n');
  
  let testsPassed = 0;
  let testsFailed = 0;

  try {
    // Test 1: Create a poll
    console.log('Test 1: Creating a poll...');
    const createPollResponse = await makeRequest('POST', '/api/poll', {
      title: 'Friday Snacks',
      options: ['Chips', 'Cookies', 'Fruit'],
      closesAt: null
    });
    
    assert.strictEqual(createPollResponse.status, 201, 'Poll creation should return 201');
    assert.ok(createPollResponse.data.shareToken, 'Should return a share token');
    assert.ok(createPollResponse.data.shareUrl, 'Should return a share URL');
    console.log('✓ Poll created successfully');
    testsPassed++;

    const shareToken = createPollResponse.data.shareToken;

    // Test 2: Get poll by token
    console.log('\nTest 2: Getting poll by token...');
    const getPollResponse = await makeRequest('GET', `/api/poll/${shareToken}`);
    
    assert.strictEqual(getPollResponse.status, 200, 'Get poll should return 200');
    assert.strictEqual(getPollResponse.data.title, 'Friday Snacks', 'Poll title should match');
    assert.strictEqual(getPollResponse.data.options.length, 3, 'Should have 3 options');
    console.log('✓ Poll retrieved successfully');
    testsPassed++;

    // Test 3: Vote on a poll
    console.log('\nTest 3: Casting a vote...');
    const voteResponse = await makeRequest('POST', '/api/vote', {
      token: shareToken,
      optionId: 0,
      voterId: 'test-voter-1'
    });
    
    assert.strictEqual(voteResponse.status, 200, 'Vote should return 200');
    assert.strictEqual(voteResponse.data.success, true, 'Vote should be successful');
    console.log('✓ Vote cast successfully');
    testsPassed++;

    // Test 4: Try to vote again (should fail)
    console.log('\nTest 4: Attempting duplicate vote...');
    const duplicateVoteResponse = await makeRequest('POST', '/api/vote', {
      token: shareToken,
      optionId: 1,
      voterId: 'test-voter-1'
    });
    
    assert.strictEqual(duplicateVoteResponse.status, 400, 'Duplicate vote should return 400');
    console.log('✓ Duplicate vote prevented');
    testsPassed++;

    // Test 5: Get results
    console.log('\nTest 5: Getting poll results...');
    const resultsResponse = await makeRequest('GET', `/api/results/${shareToken}`);
    
    assert.strictEqual(resultsResponse.status, 200, 'Get results should return 200');
    assert.strictEqual(resultsResponse.data.totalVotes, 1, 'Should have 1 vote');
    assert.strictEqual(resultsResponse.data.winner.id, 0, 'Winner should be option 0');
    console.log('✓ Results retrieved successfully');
    testsPassed++;

    // Test 6: Invalid poll creation (missing data)
    console.log('\nTest 6: Testing invalid poll creation...');
    const invalidPollResponse = await makeRequest('POST', '/api/poll', {
      title: 'Invalid',
      options: ['Only one option']
    });
    
    assert.strictEqual(invalidPollResponse.status, 400, 'Invalid poll should return 400');
    console.log('✓ Invalid poll rejected');
    testsPassed++;

    // Test 7: Get non-existent poll
    console.log('\nTest 7: Testing non-existent poll...');
    const notFoundResponse = await makeRequest('GET', '/api/poll/invalid-token');
    
    assert.strictEqual(notFoundResponse.status, 404, 'Non-existent poll should return 404');
    console.log('✓ Non-existent poll handled correctly');
    testsPassed++;

  } catch (error) {
    console.error('✗ Test failed:', error.message);
    testsFailed++;
  }

  // Summary
  console.log('\n' + '='.repeat(50));
  console.log(`Tests passed: ${testsPassed}`);
  console.log(`Tests failed: ${testsFailed}`);
  console.log('='.repeat(50));

  // Close server and exit
  serverModule.stop(() => {
    process.exit(testsFailed > 0 ? 1 : 0);
  });
}

// Start server and run tests
serverModule.start(() => {
  console.log('Test server started on port ' + PORT);
  setTimeout(runTests, 500);
});
