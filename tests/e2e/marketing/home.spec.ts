import { test, expect } from '@playwright/test';

test.describe('Marketing Home', () => {
  test('should load the marketing home page', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');

    await expect(page).toHaveTitle(/Collabolatte/);
    await expect(page.getByRole('heading', { name: 'Collabolatte' })).toBeVisible();
  });
});
