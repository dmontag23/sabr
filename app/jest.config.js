/** @type {import('jest').Config} */

const project = {
  resetMocks: true, // clears mock implementations and call history before each test
  setupFiles: ["./jest.setup.ts"],
};

module.exports = {
  collectCoverage: true,
  coverageReporters: ["text"],
  projects: [
    { preset: "jest-expo/ios", ...project },
    { preset: "jest-expo/android", ...project },
  ],
};
