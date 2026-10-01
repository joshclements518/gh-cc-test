function hello(name = "World") {
  return `Hello, ${name}!`;
}

if (require.main === module) {
  const args = process.argv.slice(2).filter((arg) => arg.trim() !== "");
  console.log(args.length > 0 ? hello(args.join(" ")) : hello());
}

module.exports = { hello };
