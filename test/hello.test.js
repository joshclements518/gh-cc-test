import test from "node:test";
import assert from "node:assert/strict";

import { hello } from "../src/hello.js";

test("greets the world by default", () => {
  assert.equal(hello(), "Hello, World!");
});

test("greets a given name", () => {
  assert.equal(hello("Alice"), "Hello, Alice!");
});
