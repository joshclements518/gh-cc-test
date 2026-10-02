# gh-cc-test

Playground repository driven end-to-end by the AI control plane POC.

- Stages are triggered by `stage:<phase>:ready` labels.
- `.github/workflows/control-plane-doorbell.yml` is the only workflow: it forwards events to the control plane.
- All stage logic lives in the control plane state machine, not in YAML.

## Friday Snack Vote

A simple poll application for voting on Friday snacks.

### Features

- **Admin Poll Creation**: Create polls with a title, multiple options, and optional closing time
- **Share Link Voting**: Vote via a unique shared link without login
- **Vote Tracking**: Prevents duplicate votes using browser-based voter ID
- **Results**: View poll results and winner

### Running the Application

```bash
# Install dependencies (none required - uses Node.js built-in modules)
npm install

# Start the server
npm start

# Run tests
npm test
```

The server will start on `http://localhost:3000`.

### Usage

1. **Create a Poll**: Visit `http://localhost:3000` to create a new poll
2. **Share the Link**: Copy the generated share URL and send it to voters
3. **Vote**: Voters click the link and select their preferred option
4. **View Results**: Use the API endpoint `/api/results/{shareToken}` to see results

### API Endpoints

- `POST /api/poll` - Create a new poll
- `GET /api/poll/{token}` - Get poll details
- `POST /api/vote` - Submit a vote
- `GET /api/results/{token}` - Get poll results

### Architecture

- **Backend**: Simple Node.js HTTP server
- **Frontend**: Vanilla HTML, CSS, and JavaScript
- **Storage**: In-memory (Map-based) for simplicity
- **Authentication**: Browser-based voter ID using localStorage
