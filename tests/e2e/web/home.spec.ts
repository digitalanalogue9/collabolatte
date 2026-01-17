import { test, expect } from '@playwright/test';

test.describe('Home Page', () => {
  test('should load the home page', async ({ page }) => {
    // Capture console errors
    const consoleErrors: string[] = [];
    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        consoleErrors.push(msg.text());
      }
    });

    await page.goto('/');

    // Wait for the page to load
    await page.waitForLoadState('networkidle');

    // Check that the page title is correct
    await expect(page).toHaveTitle(/Collabolatte/);

    // Log any console errors
    if (consoleErrors.length > 0) {
      console.log('Console errors detected:', consoleErrors);
    }
  });

  test('should have navigation elements', async ({ page }) => {
    // Capture console errors
    const consoleErrors: string[] = [];
    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        consoleErrors.push(msg.text());
      }
    });

    // Capture page errors
    const pageErrors: Error[] = [];
    page.on('pageerror', (error) => {
      pageErrors.push(error);
    });

    await page.goto('/');
    await page.waitForLoadState('networkidle');

    // Log errors for debugging
    if (consoleErrors.length > 0) {
      console.log('Console errors:', consoleErrors);
    }
    if (pageErrors.length > 0) {
      console.log('Page errors:', pageErrors.map(e => e.message));
    }

    // Check for the main content area
    const main = page.locator('main');
    await expect(main).toBeVisible();

    // Check for the heading "Hello, World!"
    const heading = page.getByRole('heading', { name: /Hello, World/i });
    await expect(heading).toBeVisible();
  });
});
