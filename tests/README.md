# E2E Tests

End-to-end tests for Collabolatte using Playwright.

## Running Tests

```bash
# From root directory
pnpm test:e2e

# Run in UI mode
pnpm exec playwright test --ui

# Run specific test file
pnpm exec playwright test tests/e2e/home.spec.ts

# Debug tests
pnpm exec playwright test --debug
```

## Writing Tests

Tests are organized by feature/page:
- `home.spec.ts` - Home page tests
- `auth.spec.ts` - Authentication flow tests
- `workspace.spec.ts` - Workspace functionality tests

## Test Data

Store test fixtures in `tests/e2e/fixtures/` directory.

## CI/CD

Tests run automatically on PRs via `.github/workflows/e2e.yml`.
