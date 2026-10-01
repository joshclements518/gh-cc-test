"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");
const { hello } = require("./index");

test("greets the world by default", () => {
  assert.equal(hello(), "Hello, World!");
});

test("greets by name", () => {
  assert.equal(hello("Alice"), "Hello, Alice!");
});
