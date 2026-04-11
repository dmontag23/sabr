import type { Configuration } from "lint-staged";

const config = {
  "*.{js,jsx,ts,tsx}": "pnpm lint:fix",
} satisfies Configuration;

export default config;
