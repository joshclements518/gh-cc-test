"use strict";

function hello(name = "World") {
  const trimmed = String(name ?? "").trim();
  const target = trimmed === "" ? "World" : trimmed;
  return `Hello, ${target}!`;
}

module.exports = { hello };
