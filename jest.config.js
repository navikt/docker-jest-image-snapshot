module.exports = {
    bail: false,
    testMatch: ["<rootDir>/tests/**/*.js"],
    setupFiles: ["<rootDir>/jest.setup.js"],
    setupTestFrameworkScriptFile: "<rootDir>/jest.setupTestFramework.js",
    reporters: ["default", "<rootDir>/html-image-reporter.js"]
};
