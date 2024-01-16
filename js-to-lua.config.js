module.exports = {
  lastSync: {
    ref: "54bfa48a5417a4cb588b24dec2685eaa3436fa69",
    conversionToolVersion: "58068bfb077b61f23dd128ad1ec2cecf77e2fe21",
  },
  upstream: {
    owner: "testing-library",
    repo: "dom-testing-library",
    primaryBranch: "main",
  },
  downstream: {
    owner: "roblox",
    repo: "dom-testing-library-lua-internal",
    primaryBranch: "main",
    patterns: ["**/*.lua"],
    ignorePatterns: ["Packages/**/*", "bin/**/*"],
  },
  renameFiles: [
    [
      (filename) => filename.endsWith("index.lua"),
      (filename) => filename.replace("index.lua", "init.lua"),
    ],
    [
      (filename) =>
        filename.includes("__test__") &&
        !filename.endsWith(".spec.lua") &&
        !filename.includes("src/__tests__/helpers/test-utils.js"),
      (filename) => filename.replace(/.lua$/, "spec.lua"),
    ],
  ],
};
