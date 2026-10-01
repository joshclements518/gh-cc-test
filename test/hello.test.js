const test = require("node:test");
const assert = require("node:assert");

const { hello } = require("../src/hello.js");

test("greets the world by default", () => {
  assert.strictEqual(hello(), "Hello, World!");
});

test("greets the given name", () => {
  assert.strictEqual(hello("Control Plane"), "Hello, Control Plane!");
});
