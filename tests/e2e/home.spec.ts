import { test, expect } from '@playwright/test';

test.describe('Home Page', () => {
  test('should load the home page', async ({ page }) => {
    await page.goto('/');
    
    // Wait for the page to load
    await page.waitForLoadState('networkidle');
    
    // Check that the page title is correct
    await expect(page).toHaveTitle(/Collabolatte/);
  });

  test('should have navigation elements', async ({ page }) => {
    await page.goto('/');
    
    // Check for common navigation elements
    // Update these selectors based on your actual implementation
    const header = page.locator('header');
    await expect(header).toBeVisible();
  });
});
