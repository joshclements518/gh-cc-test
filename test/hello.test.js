const test = require("node:test");
const assert = require("node:assert");
const { execFileSync } = require("node:child_process");
const path = require("node:path");

const { hello } = require("../src/hello.js");

const HELLO_SCRIPT = path.join(__dirname, "..", "src", "hello.js");

function runCli(args) {
  return execFileSync(process.execPath, [HELLO_SCRIPT, ...args], {
    encoding: "utf8",
  }).trim();
}

test("greets the world by default", () => {
  assert.strictEqual(hello(), "Hello, World!");
});

test("greets a given name", () => {
  assert.strictEqual(hello("Node"), "Hello, Node!");
});

test("CLI greets the world with no args", () => {
  assert.strictEqual(runCli([]), "Hello, World!");
});

test("CLI greets by name when args are passed", () => {
  assert.strictEqual(runCli(["Alice"]), "Hello, Alice!");
});

test("CLI joins multiple args into the greeting name", () => {
  assert.strictEqual(runCli(["Alice", "Smith"]), "Hello, Alice Smith!");
});

test("CLI ignores blank args", () => {
  assert.strictEqual(runCli(["  ", "Bob"]), "Hello, Bob!");
});
