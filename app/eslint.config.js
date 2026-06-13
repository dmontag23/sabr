// https://docs.expo.dev/guides/using-eslint/
const { defineConfig } = require("eslint/config");
const expoConfig = require("eslint-config-expo/flat");
const eslintPluginPrettierRecommended = require("eslint-plugin-prettier/recommended");

module.exports = defineConfig([
  expoConfig,
  eslintPluginPrettierRecommended,
  {
    ignores: ["dist/**"],
  },
  {
    files: [".maestro/scripts/**/*.js"],
    languageOptions: {
      sourceType: "script",
      globals: {
        output: "writable",
        http: "readonly",
        maestro: "readonly",
        faker: "readonly",
        json: "readonly",
      },
    },
  },
]);
