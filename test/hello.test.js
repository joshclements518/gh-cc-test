"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");

const { hello } = require("../hello");

test("greets the world by default", () => {
  assert.equal(hello(), "Hello, World!");
});

test("greets a given name", () => {
  assert.equal(hello("Alice"), "Hello, Alice!");
});

test("trims surrounding whitespace", () => {
  assert.equal(hello("  Bob  "), "Hello, Bob!");
});

test("falls back to World for an empty or nullish name", () => {
  assert.equal(hello("   "), "Hello, World!");
  assert.equal(hello(null), "Hello, World!");
  assert.equal(hello(undefined), "Hello, World!");
});
