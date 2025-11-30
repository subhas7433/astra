# Backend API Documentation - E-Prescription Platform

**Unified Reference for Frontend Development**

This document serves as a central index to all backend API documentation for the E-Prescription platform billing and token management system.

---

## Quick Navigation

| Document | Purpose | Audience |
|----------|---------|----------|
| [Billing Quick Reference](#quick-reference) | Fast lookup for common operations | All Developers |
| [Token Management API](#token-management-api) | Complete token operations guide | Frontend Developers |
| [Billing Process API](#billing-process-api) | Payment processing integration | Frontend Developers |
| [Integration Guide](#integration-guide) | End-to-end workflows | Frontend/Full-Stack |

---

## Document Locations

### Frontend API Documentation

#### Quick Reference
**Path:** `/Users/Coding Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md`

**Contains:**
- Function IDs and quick setup
- Common operations (copy-paste ready)
- Token costs and packages
- Error codes reference
- React hooks snippets
- Stripe integration patterns
- Environment variables

**Use When:** You need quick answers or code snippets

---

#### Token Management Frontend API
**Path:** `/Users/Coding Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md`

**Contains:**
- Complete TypeScript type definitions
- TokenManagementClient API class
- Individual practitioner workflows
- Clinic admin/member workflows
- Token balance checking
- Token consumption
- Usage analytics
- Auto-topup configuration
- React hooks examples
- Error handling patterns

**Use When:** Implementing token balance, consumption, or analytics features

---

#### Billing Process Frontend API
**Path:** `/Users/Coding Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md`

**Contains:**
- Complete TypeScript type definitions
- BillingProcessClient API class
- Stripe payment integration
- Stripe Elements examples
- Token purchase workflows
- Prescription billing
- Subscription management
- Auto-topup setup
- Webhook reference (backend)
- Complete React components
- Security best practices

**Use When:** Implementing payment flows, token purchases, or Stripe integration

---

#### Complete Integration Guide
**Path:** `/Users/Coding Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md`

**Contains:**
- System architecture overview
- Module responsibilities
- Unified BillingSystemClient
- Complete end-to-end workflows:
  - New user onboarding
  - Prescription creation with billing
  - Clinic admin token purchase
  - Auto-topup handling
- Full React component examples
- Testing strategy
- Deployment checklist
- Security checklist

**Use When:** Starting integration or implementing complex workflows

---

### Backend Comprehensive Documentation

#### Token Management Module
**Path:** `/Users/Coding Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/README_COMPREHENSIVE.md`

**Contains:**
- Module overview and architecture
- Feature breakdown (10 core features)
- Appwrite setup requirements
- Database schema details
- Environment variables
- API reference (backend perspective)
- Local development guide
- Production deployment
- Troubleshooting

**Use When:** Understanding backend architecture or deploying functions

---

#### Billing Process Module
**Path:** `/Users/Coding Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/README_COMPREHENSIVE.md`

**Contains:**
- Module overview and architecture
- Payment processing features
- Stripe integration details
- Webhook security
- Rate limiting
- Database schema
- Environment configuration
- Deployment guide
- Security considerations

**Use When:** Understanding payment processing or configuring Stripe

---

## Function IDs

```typescript
export const FUNCTION_IDS = {
  TOKEN_MANAGEMENT: '68d390a200073e889ea4',
  BILLING_PROCESS: '68ca8701002e7af73cba'
} as const;
```

---

## Base URLs

```typescript
export const API_ENDPOINTS = {
  APPWRITE: 'https://fra.cloud.appwrite.io/v1',
  PROJECT_ID: '687a0e4e002af7cec716',
  TOKEN_MANAGEMENT: 'https://fra.cloud.appwrite.io/v1/functions/68d390a200073e889ea4/executions',
  BILLING_PROCESS: 'https://fra.cloud.appwrite.io/v1/functions/68ca8701002e7af73cba/executions'
} as const;
```

---

## Quick Start Guide

### 1. Installation

```bash
npm install appwrite @stripe/stripe-js
```

### 2. Initialize Clients

```typescript
import { Client, Functions } from 'appwrite';
import { loadStripe } from '@stripe/stripe-js';

// Appwrite Client
const client = new Client()
  .setEndpoint('https://fra.cloud.appwrite.io/v1')
  .setProject('687a0e4e002af7cec716');

// Stripe Client
const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLIC_KEY!);
```

### 3. Import API Clients

```typescript
import { TokenManagementClient } from '@/lib/billing/tokenManagement';
import { BillingProcessClient } from '@/lib/billing/billingProcess';
import { BillingSystemClient } from '@/lib/billing';

// Create unified client
const billingSystem = new BillingSystemClient(client);

// Or use individual clients
const tokenClient = new TokenManagementClient(client);
const billingClient = new BillingProcessClient(client);
```

---

## Common Operations Reference

### Check Token Balance

```typescript
// Individual Practitioner
const response = await billingSystem.tokens.checkBalance('user_123');

// Clinic Balance
const response = await billingSystem.tokens.checkClinicBalance('user_123', 'clinic_456');
```

**Documentation:** [Token Management Frontend API - Workflow 1](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#1-individual-practitioner-check-token-balance)

---

### Purchase Tokens

```typescript
// Individual Purchase
const result = await billingSystem.purchaseTokensComplete(
  'user_123',
  null, // no clinic
  100,  // tokens
  15.00, // price
  'pm_stripe_card'
);

// Clinic Purchase
const result = await billingSystem.purchaseTokensComplete(
  'admin_123',
  'clinic_456',
  500,
  75.00,
  'pm_clinic_card'
);
```

**Documentation:** [Billing Process Frontend API - Workflow 1](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#1-individual-practitioner-purchase-tokens-with-stripe)

---

### Consume Tokens

```typescript
const response = await billingSystem.tokens.consumeTokens({
  user_id: 'user_123',
  clinic_id: null, // or 'clinic_456' for clinic
  amount: 2,
  operation_type: 'prescription_creation',
  operation_id: 'rx_789'
});
```

**Documentation:** [Token Management Frontend API - Workflow 4](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#4-consume-tokens-individual-or-clinic)

---

### Bill Prescription

```typescript
const response = await billingSystem.billing.billPrescription(
  'user_123',
  'clinic_456',
  {
    prescription_id: 'rx_789',
    prescription_type: 'standard',
    medication_count: 3,
    is_repeat: false
  }
);
```

**Documentation:** [Billing Process Frontend API - Workflow 4](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#4-bill-prescription)

---

### Setup Auto-Topup

```typescript
const response = await billingSystem.tokens.setupAutoTopup('user_123', {
  enabled: true,
  threshold: 20,
  topup_amount: 100,
  payment_method_id: 'pm_default_card',
  max_frequency: 'daily'
});
```

**Documentation:** [Token Management Frontend API - Workflow 6](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#6-setup-auto-topup)

---

## Token Costs Quick Reference

| Operation | Tokens | Documentation |
|-----------|--------|---------------|
| Prescription Creation | 2 | [Token Costs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#token-cost-reference) |
| Prescription Signing | 3 | [Token Costs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#token-cost-reference) |
| Prescription Dispensing | 1 | [Token Costs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#token-cost-reference) |
| Email Notification | 1 | [Token Costs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#token-cost-reference) |
| SMS Notification | 2 | [Token Costs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#token-cost-reference) |

**Full Reference:** [Quick Reference - Token Costs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md#token-costs)

---

## Token Packages

| Package | Tokens | Price (GBP) | Bonus | Discount |
|---------|--------|-------------|-------|----------|
| Starter | 50 | £10.00 | 0 | 0% |
| Professional | 200 | £35.00 | 20 | 12.5% |
| Enterprise | 500 | £80.00 | 75 | 20% |

**Full Reference:** [Quick Reference - Token Packages](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md#token-packages)

---

## Error Handling Reference

### Common Error Codes

```typescript
enum ErrorType {
  VALIDATION_ERROR = 'validation_error',
  AUTHENTICATION_ERROR = 'authentication_error',
  AUTHORIZATION_ERROR = 'authorization_error',
  INSUFFICIENT_TOKENS = 'insufficient_tokens',
  BALANCE_NOT_FOUND = 'balance_not_found',
  PAYMENT_ERROR = 'payment_error',
  RATE_LIMITED = 'rate_limited',
  INTERNAL_SERVER_ERROR = 'internal_server_error'
}
```

**Documentation:**
- [Token Management - Error Handling](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#error-handling)
- [Billing Process - Error Handling](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#error-handling)
- [Quick Reference - Error Codes](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md#error-codes)

---

## Billing Models

### Individual Practitioner
```typescript
{
  user_id: 'user_123',
  clinic_id: null // Important: null for individual
}
```

### Clinic Admin
```typescript
{
  user_id: 'admin_123',
  clinic_id: 'clinic_456'
  // User must have billing_management permission
}
```

### Clinic Member
```typescript
{
  user_id: 'doctor_123',
  clinic_id: 'clinic_456'
  // Can consume, cannot purchase
}
```

**Full Documentation:** [Integration Guide - Module Responsibilities](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#module-responsibilities)

---

## Complete Workflows

### 1. New User Onboarding
**Documentation:** [Integration Guide - Workflow 1](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#workflow-1-new-user-onboarding)

**Steps:**
1. Create subscription
2. Purchase initial tokens
3. Setup auto-topup
4. Load dashboard data

---

### 2. Prescription Creation with Billing
**Documentation:** [Integration Guide - Workflow 2](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#workflow-2-prescription-creation-with-billing)

**Steps:**
1. Calculate prescription cost
2. Bill prescription (consume tokens)
3. Create prescription
4. Update consumption with actual ID

---

### 3. Clinic Admin Token Purchase
**Documentation:** [Integration Guide - Workflow 3](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#workflow-3-clinic-admin-token-purchase)

**Steps:**
1. Verify admin permissions
2. Select token package
3. Process payment
4. Update clinic balance
5. Load usage analytics

---

### 4. Stripe Payment Flow
**Documentation:** [Billing Process - Stripe Elements Integration](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#2-stripe-elements-integration-react)

**Steps:**
1. Create payment method with Stripe Elements
2. Initiate token purchase
3. Receive client secret
4. Confirm payment with Stripe
5. Wait for webhook to credit tokens

---

## React Component Examples

### Token Balance Display
**Full Code:** [Token Management - React Hooks Example](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#react-hooks-example)

### Token Purchase with Stripe
**Full Code:** [Billing Process - Stripe Elements Integration](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#2-stripe-elements-integration-react)

### Billing Dashboard
**Full Code:** [Integration Guide - Billing Dashboard Component](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#billing-dashboard-component)

---

## TypeScript Type Definitions

### All Type Definitions
**Token Management Types:** [Token Management - TypeScript Types](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md#typescript-type-definitions)

**Billing Process Types:** [Billing Process - TypeScript Types](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#typescript-type-definitions)

### Key Types

```typescript
// Token Balance
interface TokenBalance {
  current_balance: number;
  reserved_balance: number;
  available_balance: number;
  auto_topup_enabled: boolean;
  auto_topup_threshold: number | null;
  last_updated: string;
}

// Token Package
interface TokenPackage {
  token_amount: number;
  price: number;
  currency: 'GBP' | 'USD' | 'EUR';
  package_type: 'standard' | 'professional' | 'enterprise';
}

// Purchase Response
interface PurchaseResponse {
  success: boolean;
  transaction_id: string;
  payment_intent_id?: string;
  client_secret?: string;
  billing_model: BillingEntityType;
  tokens_purchased?: number;
  new_token_balance: number;
  test_mode?: boolean;
  timestamp: string;
}
```

---

## Environment Variables

```env
# Appwrite Configuration
NEXT_PUBLIC_APPWRITE_ENDPOINT=https://fra.cloud.appwrite.io/v1
NEXT_PUBLIC_APPWRITE_PROJECT_ID=687a0e4e002af7cec716

# Stripe Configuration
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...  # Backend only

# Function IDs
NEXT_PUBLIC_TOKEN_MANAGEMENT_FUNCTION_ID=68d390a200073e889ea4
NEXT_PUBLIC_BILLING_PROCESS_FUNCTION_ID=68ca8701002e7af73cba

# Environment
NEXT_PUBLIC_ENVIRONMENT=development
```

**Full Reference:** [Integration Guide - Environment Variables](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#environment-variables)

---

## Testing

### Test Mode
**Documentation:** [Quick Reference - Testing](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md#testing)

### Test Payment Tokens
```typescript
export const TEST_PAYMENT_TOKENS = {
  SUCCESS: 'pm_card_visa',
  INVALID: 'invalid_token',
  INSUFFICIENT_FUNDS: 'insufficient_funds',
  EXPIRED_CARD: 'expired_card'
} as const;
```

**Full Documentation:** [Billing Process - Testing Scenarios](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#testing-scenarios)

---

## Security Best Practices

**Complete Checklist:** [Integration Guide - Security Checklist](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#security-checklist)

### Key Points
- Never expose Stripe secret keys on frontend
- Use HTTPS for all API requests
- Validate user authentication before operations
- Implement rate limiting
- Use Stripe Elements for PCI compliance
- Sanitize all user input

---

## Deployment Checklist

**Complete Checklist:** [Integration Guide - Deployment Checklist](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#deployment-checklist)

### Critical Steps
- [ ] Test all workflows in development mode
- [ ] Verify Stripe test mode integration
- [ ] Test with real Stripe API
- [ ] Verify webhook processing
- [ ] Test auto-topup triggers
- [ ] Verify balance updates after payments
- [ ] Test clinic vs individual billing
- [ ] Load test payment flows

---

## Troubleshooting

### Common Issues

**"Balance not found"**
- **Documentation:** [Token Management - Troubleshooting](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/README_COMPREHENSIVE.md#troubleshooting)
- **Solution:** Ensure user has active subscription

**"Insufficient tokens"**
- **Documentation:** [Quick Reference - Error Codes](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md#error-codes)
- **Solution:** Purchase tokens or enable auto-topup

**"Permission denied"**
- **Documentation:** [Billing Process - Troubleshooting](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/README_COMPREHENSIVE.md#troubleshooting)
- **Solution:** Check user role in clinic_memberships

**"Payment Intent creation failed"**
- **Documentation:** [Billing Process - Common Issues](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md#support--troubleshooting)
- **Solution:** Verify payment method validity

---

## Support Resources

### Documentation Links
- **Token Management Frontend API:** [FRONTEND_API.md](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md)
- **Billing Process Frontend API:** [FRONTEND_API.md](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/billing_process/FRONTEND_API.md)
- **Complete Integration Guide:** [BILLING_INTEGRATION_GUIDE.md](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md)
- **Quick Reference:** [BILLING_QUICK_REFERENCE.md](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md)

### External Resources
- **Stripe Documentation:** https://stripe.com/docs
- **Appwrite Functions:** https://appwrite.io/docs/functions
- **Stripe Elements:** https://stripe.com/docs/stripe-js

---

## Architecture Overview

```
Frontend Application
       ì
Token Management Client êí Billing Process Client
       ì                            ì
Token Management Function êí Billing Process Function
       ì                            ì
           í Shared Database ê     
                    ì
              Stripe Gateway
```

**Full Architecture:** [Integration Guide - System Architecture](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md#system-architecture)

---

## Version Information

- **Token Management Version:** 2.0.0
- **Billing Process Version:** 2.0.0
- **Documentation Version:** 2.0.0
- **Last Updated:** October 8, 2025

---

## Getting Help

1. **Quick Answers:** Check [Quick Reference](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_QUICK_REFERENCE.md)
2. **API Details:** Review module-specific [Frontend API docs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/FRONTEND_API.md)
3. **Workflows:** See [Integration Guide](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/docs/BILLING_INTEGRATION_GUIDE.md)
4. **Architecture:** Consult [Comprehensive READMEs](file:///Users/Coding%20Work/Freelancing/InsightsTap/ai-saas-dev/ad0046-e-prescription/src/functions/token_management/README_COMPREHENSIVE.md)

---

**Maintained By:** E-Prescription Platform Team
**Documentation Path:** `/Volumes/T7 Shield/Workspace/Work/Freelance/Insightstap/AD0046-e-prescription/ad0046-e-prescription-frontend/core_docs/reference/backend_documentation.md`
