import { defineConfig, devices } from '@playwright/test';

/**
 * See https://playwright.dev/docs/test-configuration
 */
export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'web',
      testMatch: /web\/.*\.spec\.ts/,
      use: {
        ...devices['Desktop Chrome'],
        baseURL: process.env.PLAYWRIGHT_WEB_BASE_URL ?? 'http://localhost:3000',
      },
      webServer: process.env.CI
        ? undefined
        : {
            command: 'pnpm --filter @collabolatte/web dev',
            url: process.env.PLAYWRIGHT_WEB_BASE_URL ?? 'http://localhost:3000',
            reuseExistingServer: true,
          },
    },
    {
      name: 'marketing',
      testMatch: /marketing\/.*\.spec\.ts/,
      use: {
        ...devices['Desktop Chrome'],
        baseURL:
          process.env.PLAYWRIGHT_MARKETING_BASE_URL ?? 'http://localhost:8080',
      },
      webServer: process.env.CI
        ? undefined
        : {
            command: 'pnpm --filter @collabolatte/marketing dev',
            url:
              process.env.PLAYWRIGHT_MARKETING_BASE_URL ??
              'http://localhost:8080',
            reuseExistingServer: true,
          },
    },
  ],
});
