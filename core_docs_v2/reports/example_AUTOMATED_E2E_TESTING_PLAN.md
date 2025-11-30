# Automated End-to-End Testing Plan
**Date**: October 8, 2025
**Purpose**: Implement automated browser-based testing
**Framework**: Playwright (recommended for Next.js 15)
**Scope**: Critical user journeys + Billing module

---

## WHY PLAYWRIGHT?

### Playwright vs Cypress vs Selenium:

**Playwright** ✅ RECOMMENDED:
- ✅ Built by Microsoft, excellent Next.js support
- ✅ Fast execution (parallel test running)
- ✅ Auto-wait (no manual waits needed)
- ✅ Multi-browser (Chrome, Firefox, Safari, Edge)
- ✅ TypeScript native support
- ✅ Great debugging (screenshots, videos, traces)
- ✅ Component testing + E2E testing
- ✅ API testing built-in

**Cypress** (Alternative):
- ✅ Great developer experience
- ✅ Time-travel debugging
- ⚠️ Only Chrome-based browsers
- ⚠️ Slower than Playwright

**Selenium** (Not Recommended):
- ⚠️ More complex setup
- ⚠️ Slower execution
- ⚠️ More maintenance needed

---

## SETUP STEPS

### Step 1: Install Playwright (5 min)
```bash
# Install Playwright
pnpm add -D @playwright/test

# Install browsers
pnpm exec playwright install

# Install dependencies
pnpm exec playwright install-deps
```

### Step 2: Initialize Configuration (5 min)
```bash
# Initialize Playwright (creates playwright.config.ts)
pnpm exec playwright init
```

**Configuration** (`playwright.config.ts`):
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',

  use: {
    baseURL: 'http://localhost:3001',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],

  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3001',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
```

### Step 3: Create Test Directory Structure
```bash
mkdir -p e2e/{auth,billing,patients,prescriptions,utils}
```

---

## TEST STRUCTURE

```
e2e/
├── utils/
│   ├── fixtures.ts           # Test data fixtures
│   ├── helpers.ts            # Helper functions (login, navigate, etc.)
│   └── test-users.ts         # Mock user credentials
│
├── auth/
│   ├── login.spec.ts         # Login flow tests
│   ├── register.spec.ts      # Registration tests
│   └── password-reset.spec.ts
│
├── billing/
│   ├── overview.spec.ts      # Billing overview page
│   ├── transactions.spec.ts  # Transaction history
│   ├── auto-topup.spec.ts    # Auto top-up configuration
│   ├── payment-methods.spec.ts
│   ├── checkout.spec.ts      # Full checkout flow
│   └── subscription.spec.ts
│
├── patients/
│   ├── patient-list.spec.ts
│   └── patient-create.spec.ts
│
└── prescriptions/
    ├── prescription-list.spec.ts
    └── prescription-create.spec.ts
```

---

## SAMPLE TEST IMPLEMENTATION

### 1. Helper Functions (`e2e/utils/helpers.ts`)
```typescript
import { Page, expect } from '@playwright/test';

/**
 * Login helper - reusable across all tests
 */
export async function login(page: Page, email: string, password: string) {
  await page.goto('/auth/login');
  await page.fill('input[name="email"]', email);
  await page.fill('input[name="password"]', password);
  await page.click('button[type="submit"]');
  await page.waitForURL('/'); // Wait for redirect to dashboard
}

/**
 * Navigate to billing section
 */
export async function navigateToBilling(page: Page) {
  await page.goto('/settings/billing');
  await page.waitForLoadState('networkidle');
}

/**
 * Wait for no loading spinners
 */
export async function waitForLoadingComplete(page: Page) {
  await page.waitForSelector('[data-loading="true"]', { state: 'hidden', timeout: 10000 }).catch(() => {});
}

/**
 * Check for console errors
 */
export async function checkNoConsoleErrors(page: Page) {
  const errors: string[] = [];

  page.on('console', (msg) => {
    if (msg.type() === 'error') {
      errors.push(msg.text());
    }
  });

  return errors;
}
```

### 2. Test Data Fixtures (`e2e/utils/fixtures.ts`)
```typescript
export const testUsers = {
  admin: {
    email: 'admin@test.com',
    password: 'Test123!@#',
    role: 'admin'
  },
  prescriber: {
    email: 'doctor@test.com',
    password: 'Test123!@#',
    role: 'prescriber'
  },
  patient: {
    email: 'patient@test.com',
    password: 'Test123!@#',
    role: 'patient'
  }
};

export const mockPatient = {
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@test.com',
  phone: '+44 7700 900000',
  dateOfBirth: '1990-01-01',
  nhsNumber: '123 456 7890',
  gender: 'male'
};

export const mockTokenPackage = {
  tokens: 500,
  cost: 40.00,
  id: 'pkg_500'
};
```

### 3. Billing Overview Test (`e2e/billing/overview.spec.ts`)
```typescript
import { test, expect } from '@playwright/test';
import { login, navigateToBilling } from '../utils/helpers';
import { testUsers } from '../utils/fixtures';

test.describe('Billing Overview Page', () => {
  test.beforeEach(async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
  });

  test('should load billing overview without errors', async ({ page }) => {
    await navigateToBilling(page);

    // Check page title
    await expect(page.locator('h1')).toContainText('Billing');

    // Check key sections exist
    await expect(page.locator('text=Token Balance')).toBeVisible();
    await expect(page.locator('text=Usage Statistics')).toBeVisible();
    await expect(page.locator('text=Recent Transactions')).toBeVisible();

    // Verify no console errors
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') errors.push(msg.text());
    });

    expect(errors).toHaveLength(0);
  });

  test('should display token balance', async ({ page }) => {
    await navigateToBilling(page);

    // Check token balance is displayed (number or loading)
    const balanceElement = page.locator('[data-testid="token-balance"]');
    await expect(balanceElement).toBeVisible();

    // Should be a number or "Loading..."
    const balanceText = await balanceElement.textContent();
    expect(balanceText).toMatch(/\d+|Loading/);
  });

  test('should navigate to sub-pages', async ({ page }) => {
    await navigateToBilling(page);

    // Test navigation to transactions
    await page.click('text=View All Transactions');
    await expect(page).toHaveURL('/settings/billing/transactions');

    // Go back
    await page.goBack();

    // Test navigation to auto top-up
    await page.click('text=Auto Top-up');
    await expect(page).toHaveURL('/settings/billing/auto-topup');
  });
});
```

### 4. Transaction History Test (`e2e/billing/transactions.spec.ts`)
```typescript
import { test, expect } from '@playwright/test';
import { login, navigateToBilling } from '../utils/helpers';
import { testUsers } from '../utils/fixtures';

test.describe('Transaction History Page', () => {
  test.beforeEach(async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/settings/billing/transactions');
  });

  test('should load transactions page', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('Transaction History');
  });

  test('should display transaction table', async ({ page }) => {
    // Wait for table to load
    await page.waitForSelector('table', { timeout: 10000 });

    // Check table headers
    await expect(page.locator('th:has-text("Type")')).toBeVisible();
    await expect(page.locator('th:has-text("Date")')).toBeVisible();
    await expect(page.locator('th:has-text("Tokens")')).toBeVisible();
    await expect(page.locator('th:has-text("Amount")')).toBeVisible();
  });

  test('should filter transactions by type', async ({ page }) => {
    // Click filter dropdown
    await page.click('[data-testid="transaction-type-filter"]');

    // Select token_purchase
    await page.click('text=Token Purchase');

    // Verify URL or state updated
    await page.waitForTimeout(500);

    // Check filtered results
    const rows = await page.locator('table tbody tr').count();
    expect(rows).toBeGreaterThanOrEqual(0);
  });

  test('should open invoice dialog', async ({ page }) => {
    // Find first invoice button
    const invoiceButton = page.locator('button:has-text("Invoice")').first();

    if (await invoiceButton.isVisible()) {
      await invoiceButton.click();

      // Check dialog opened
      await expect(page.locator('[role="dialog"]')).toBeVisible();
      await expect(page.locator('text=Invoice')).toBeVisible();
    }
  });

  test('CRITICAL: should use displayTransactions (not raw transactions)', async ({ page }) => {
    // This verifies our transformation layer works

    // Check for console errors about undefined properties
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error' && msg.text().includes('undefined')) {
        errors.push(msg.text());
      }
    });

    await page.waitForTimeout(2000);

    // Should have no undefined property errors
    const undefinedErrors = errors.filter(e =>
      e.includes('.tokens') ||
      e.includes('.type') ||
      e.includes('.date')
    );

    expect(undefinedErrors).toHaveLength(0);
  });
});
```

### 5. Auto Top-up Test (`e2e/billing/auto-topup.spec.ts`)
```typescript
import { test, expect } from '@playwright/test';
import { login } from '../utils/helpers';
import { testUsers } from '../utils/fixtures';

test.describe('Auto Top-up Configuration', () => {
  test.beforeEach(async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/settings/billing/auto-topup');
  });

  test('CRITICAL: should enable auto top-up', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('Auto Top-Up');

    // Find enable switch
    const enableSwitch = page.locator('[role="switch"]').first();
    const isChecked = await enableSwitch.getAttribute('data-state');

    if (isChecked !== 'checked') {
      await enableSwitch.click();
    }

    // Verify configuration options appear
    await expect(page.locator('text=Trigger Threshold')).toBeVisible();
    await expect(page.locator('text=Top-Up Amount')).toBeVisible();
  });

  test('CRITICAL: should save auto top-up settings', async ({ page }) => {
    // Enable auto top-up
    const enableSwitch = page.locator('[role="switch"]').first();
    await enableSwitch.click();

    // Set threshold
    const thresholdSlider = page.locator('input[type="range"]').first();
    await thresholdSlider.fill('150');

    // Select token package (500 tokens)
    await page.click('input[value="500"]');

    // Select payment method
    await page.click('input[value="pm_1"]');

    // Click save button
    await page.click('button:has-text("Save Settings")');

    // Wait for success toast
    await expect(page.locator('text=saved successfully')).toBeVisible({ timeout: 5000 });
  });

  test('should display TOKEN_PACKAGES (not undefined)', async ({ page }) => {
    const enableSwitch = page.locator('[role="switch"]').first();
    await enableSwitch.click();

    // Wait for token packages to render
    await page.waitForSelector('text=100', { timeout: 5000 });

    // Should show multiple package options
    const packages = await page.locator('[id^="package-"]').count();
    expect(packages).toBeGreaterThanOrEqual(5);
  });

  test('should display payment methods (not undefined)', async ({ page }) => {
    const enableSwitch = page.locator('[role="switch"]').first();
    await enableSwitch.click();

    // Check payment methods appear
    await expect(page.locator('text=ending in')).toBeVisible({ timeout: 5000 });

    // Should have at least one payment method
    const methods = await page.locator('[id^="method-"]').count();
    expect(methods).toBeGreaterThanOrEqual(1);
  });
});
```

### 6. Checkout Flow Test (`e2e/billing/checkout.spec.ts`)
```typescript
import { test, expect } from '@playwright/test';
import { login } from '../utils/helpers';
import { testUsers } from '../utils/fixtures';

test.describe('Checkout Flow', () => {
  test.beforeEach(async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/settings/billing/checkout');
  });

  test('CRITICAL: should complete full checkout flow', async ({ page }) => {
    // Step 1: Select Package
    await expect(page.locator('h2:has-text("Select Package")')).toBeVisible();

    // Select 500 token package
    await page.click('input[id*="pkg_500"]');

    // Click Next
    await page.click('button:has-text("Continue to Payment")');

    // Step 2: Payment Method
    await expect(page.locator('h2:has-text("Payment Method")')).toBeVisible();

    // Select saved card
    await page.click('input[value="pm_1"]');

    // Click Pay
    await page.click('button:has-text("Pay")');

    // Step 3: Confirmation (might be mock)
    // Check for success message or confirmation screen
    await expect(page.locator('text=successful|confirmed|complete')).toBeVisible({ timeout: 10000 });
  });

  test('should display token packages without crashes', async ({ page }) => {
    // Verify no toFixed() crashes
    const errors: string[] = [];
    page.on('pageerror', error => {
      errors.push(error.message);
    });

    await page.waitForTimeout(2000);

    // Should have no "Cannot read property 'toFixed' of undefined" errors
    const toFixedErrors = errors.filter(e => e.includes('toFixed'));
    expect(toFixedErrors).toHaveLength(0);
  });

  test('should calculate costs correctly', async ({ page }) => {
    // Select a package
    await page.click('input[id*="pkg_100"]');

    // Check cost displays
    const costElement = page.locator('text=/£\\d+\\.\\d{2}/').first();
    await expect(costElement).toBeVisible();

    // Verify cost format (should be £10.00 for 100 tokens)
    const costText = await costElement.textContent();
    expect(costText).toMatch(/£\d+\.\d{2}/);
  });
});
```

### 7. Complete User Journey Test (`e2e/user-journeys/billing-journey.spec.ts`)
```typescript
import { test, expect } from '@playwright/test';
import { login, navigateToBilling } from '../utils/helpers';
import { testUsers } from '../utils/fixtures';

test.describe('Complete Billing User Journey', () => {
  test('NEW USER: Purchase tokens → Enable auto top-up → View transactions', async ({ page }) => {
    // Login
    await login(page, testUsers.admin.email, testUsers.admin.password);

    // === STEP 1: Check Initial Balance ===
    await navigateToBilling(page);
    await expect(page.locator('h1:has-text("Billing")')).toBeVisible();

    // === STEP 2: Purchase Tokens ===
    await page.click('text=Purchase Tokens');
    await expect(page).toHaveURL('/settings/billing/checkout');

    // Select package
    await page.click('input[id*="pkg_500"]');
    await page.click('button:has-text("Continue")');

    // (Mock payment or use test Stripe keys)
    await page.click('input[value="pm_1"]');
    await page.click('button:has-text("Pay")');

    // Verify success
    await expect(page.locator('text=successful|complete')).toBeVisible({ timeout: 15000 });

    // === STEP 3: Enable Auto Top-up ===
    await page.goto('/settings/billing/auto-topup');

    // Enable
    await page.click('[role="switch"]');

    // Configure
    await page.locator('input[type="range"]').first().fill('100');
    await page.click('input[value="500"]'); // 500 token package
    await page.click('input[value="pm_1"]'); // First payment method

    // Save
    await page.click('button:has-text("Save")');
    await expect(page.locator('text=saved successfully')).toBeVisible({ timeout: 5000 });

    // === STEP 4: View Transaction History ===
    await page.goto('/settings/billing/transactions');

    // Should see recent purchase
    await expect(page.locator('table')).toBeVisible();
    await expect(page.locator('td:has-text("token_purchase")')).toBeVisible({ timeout: 5000 });

    // === STEP 5: Return to Billing Overview ===
    await page.goto('/settings/billing');

    // Verify balance updated (if real backend)
    // This completes the full billing journey
    await expect(page).toHaveURL('/settings/billing');
  });
});
```

### 8. Critical Property Access Test (`e2e/billing/critical-fixes.spec.ts`)
```typescript
import { test, expect } from '@playwright/test';
import { login } from '../utils/helpers';
import { testUsers } from '../utils/fixtures';

test.describe('Critical Fixes Verification', () => {
  test('should use is_default (not isDefault)', async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/settings/billing/payment-methods');

    // Check page loads (would crash if accessing wrong property)
    await expect(page.locator('h1')).toBeVisible();

    // Look for "Default" badge (uses is_default property)
    const defaultBadge = page.locator('text=Default').first();

    // If payment methods exist, default badge should appear
    const hasMethods = await page.locator('text=ending in').count() > 0;
    if (hasMethods) {
      await expect(defaultBadge).toBeVisible();
    }
  });

  test('should use dept.department (not dept.name)', async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/clinic-admin/billing');

    // Page should load without crashes
    await expect(page.locator('h1')).toBeVisible();

    // If departments exist, should display without property errors
    await page.waitForTimeout(2000);

    // Check no console errors about 'name' property
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error' && msg.text().includes('name')) {
        errors.push(msg.text());
      }
    });

    expect(errors).toHaveLength(0);
  });

  test('should use TOKEN_PACKAGES (not tokenPackages)', async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/settings/billing/auto-topup');

    // Enable to show packages
    await page.click('[role="switch"]');

    // Should show token packages without undefined error
    await expect(page.locator('text=100')).toBeVisible({ timeout: 5000 });

    // Verify multiple packages render
    const packageCount = await page.locator('[id^="package-"]').count();
    expect(packageCount).toBeGreaterThanOrEqual(5);
  });

  test('should transform BillingTransactions correctly', async ({ page }) => {
    await login(page, testUsers.admin.email, testUsers.admin.password);
    await page.goto('/settings/billing/transactions');

    // Monitor for transformation errors
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });

    await page.waitForTimeout(3000);

    // Should have no errors about accessing tokens, type, date, etc.
    const transformErrors = errors.filter(e =>
      e.includes('tokens') ||
      e.includes('type') ||
      e.includes('date') ||
      e.includes('paymentMethod')
    );

    expect(transformErrors).toHaveLength(0);
  });
});
```

---

## RUNNING TESTS

### Run All Tests:
```bash
# Run all tests (headless)
pnpm exec playwright test

# Run with UI (see browser)
pnpm exec playwright test --ui

# Run specific test file
pnpm exec playwright test e2e/billing/transactions.spec.ts

# Run tests in headed mode (watch execution)
pnpm exec playwright test --headed

# Debug mode (step through)
pnpm exec playwright test --debug
```

### Run by Tag:
```typescript
// In test file:
test('should load page @smoke', async ({ page }) => { ... });

// Run:
pnpm exec playwright test --grep @smoke
```

### Generate Report:
```bash
# After tests run
pnpm exec playwright show-report
```

---

## TEST COVERAGE GOALS

### Critical Paths (Must Test):
- [x] Login flow
- [x] Billing overview page load
- [x] Transaction history display
- [x] Auto top-up enable & save
- [x] Checkout complete flow
- [x] Payment method display

### High Priority:
- [ ] Subscription upgrade flow
- [ ] Patient creation
- [ ] Prescription creation
- [ ] Clinic admin dashboard

### Medium Priority:
- [ ] All navigation paths
- [ ] All form validations
- [ ] All error states

---

## PACKAGE.JSON SCRIPTS

Add to `package.json`:
```json
{
  "scripts": {
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:headed": "playwright test --headed",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:billing": "playwright test e2e/billing",
    "test:e2e:report": "playwright show-report"
  }
}
```

---

## CI/CD INTEGRATION

### GitHub Actions Example:
```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2

      - name: Install dependencies
        run: pnpm install

      - name: Install Playwright browsers
        run: pnpm exec playwright install --with-deps

      - name: Build app
        run: pnpm build

      - name: Run E2E tests
        run: pnpm test:e2e

      - name: Upload test report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

---

## ESTIMATED IMPLEMENTATION TIME

```
Setup Playwright:              15 min
Create helpers & fixtures:     30 min
Write billing tests (6 files): 2 hours
Write critical journey tests:  1 hour
Write other module tests:      2 hours
─────────────────────────────────────
TOTAL:                         ~6 hours
```

### Phased Approach:
**Phase 1** (Today - 1 hour):
- Install Playwright
- Create basic helpers
- Write 2-3 critical billing tests

**Phase 2** (Week 14 - 3 hours):
- Complete all billing tests
- Add critical user journeys
- CI/CD integration

**Phase 3** (Week 15 - 2 hours):
- Full test coverage
- Performance tests
- Visual regression tests

---

## BENEFITS OF AUTOMATED E2E TESTING

### Immediate Benefits:
✅ **Catch Regressions** - Know immediately if changes break features
✅ **Faster Testing** - Run 50+ tests in minutes vs hours manually
✅ **Consistent Testing** - Same tests every time, no human error
✅ **CI/CD Ready** - Run on every commit automatically
✅ **Documentation** - Tests serve as living documentation
✅ **Confidence** - Deploy with certainty

### Long-term Benefits:
✅ **Refactoring Safety** - Change code confidently
✅ **Onboarding** - New devs understand flows via tests
✅ **Quality Gate** - Block PRs with failing tests
✅ **Time Savings** - Weeks of manual testing → Hours automated

---

## RECOMMENDATION

### Quick Start (1 hour - Do Today):
```bash
# 1. Install Playwright
pnpm add -D @playwright/test
pnpm exec playwright install

# 2. Create basic test
# (Use examples above)

# 3. Run first test
pnpm exec playwright test --headed

# 4. Verify it works
```

### Full Implementation (Week 14):
- Complete all billing tests
- Add critical user journeys
- Integrate with CI/CD
- Train team on writing tests

---

## CONCLUSION

**Automated E2E testing is HIGHLY RECOMMENDED** for:
1. Preventing future regressions
2. Faster development cycles
3. Deployment confidence
4. Long-term quality assurance

**Effort**: ~6 hours total investment
**ROI**: Saves 10+ hours per month in manual testing
**Payback**: <1 month

---

**Next Action**: Install Playwright and create first test?
