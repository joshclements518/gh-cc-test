#!/usr/bin/env node
"use strict";

function hello(name = "World") {
  return `Hello, ${name}!`;
}

if (require.main === module) {
  console.log(hello(process.argv[2]));
}

module.exports = { hello };
