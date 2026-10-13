import { createServer } from 'node:http'
import { readFileSync, existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const port = Number(process.env.PORT || 8080)
const sha = (process.env.AICP_GIT_SHA || 'unknown').slice(0, 12)

function readText(rel) {
  const p = resolve(__dirname, rel)
  return existsSync(p) ? readFileSync(p, 'utf8') : ''
}

const readme = readText('README.md')
const pubspec = readText('app/pubspec.yaml')
const brand =
  /Harborline/.test(readme) || /harborline/i.test(pubspec)
    ? 'Harborline Navigator'
    : 'gh-cc-test UI'

const server = createServer((req, res) => {
  const url = new URL(req.url ?? '/', 'http://localhost')
  if (req.method === 'GET' && (url.pathname === '/healthz' || url.pathname === '/')) {
    const body = {
      ok: true,
      service: 'harborline-navigator',
      brand,
      repo: 'joshclements518/gh-cc-test',
      sha,
    }
    if (url.pathname === '/') {
      res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' })
      res.end(`<!doctype html><html><head><title>${brand}</title></head>
<body style="font-family:system-ui;background:#0b111b;color:#e2e8f0;padding:2rem">
<h1>${brand}</h1>
<p>Demo UI surface from <code>joshclements518/gh-cc-test</code> @ <code>${sha}</code></p>
<p>Flutter app sources live under <code>app/</code> in this repo.</p>
<pre>${JSON.stringify(body, null, 2)}</pre>
</body></html>`)
      return
    }
    res.writeHead(200, { 'content-type': 'application/json' })
    res.end(JSON.stringify(body))
    return
  }
  res.writeHead(404)
  res.end('not found')
})

server.listen(port, () => console.log(`${brand} web on :${port} sha=${sha}`))
