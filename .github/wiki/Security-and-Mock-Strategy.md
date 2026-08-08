# 🔒 My Security Architecture & Multi-Tenant Isolation Strategy

In my software ecosystem, I enforce strict security controls, multi-tenant data isolation patterns, and a type-safe offline mock architecture.

---

## 🛡️ My Multi-Tenant Data Isolation Strategy

To guarantee zero cross-tenant data leakage in my multi-tenant SaaS environments (e.g., `elitk-saas-web`, `elitk-api-server`), I enforce a 3-layer security isolation boundary:

```
+-------------------------------------------------------------------+
| LAYER 1: JWT & HEADER ISOLATION                                   |
| My API Gateway verifies JWT `tenant_id` claim against headers.    |
+---------------------------------+---------------------------------+
                                  |
                                  v
+---------------------------------+---------------------------------+
| LAYER 2: ORM ROW-LEVEL POLICIES                                   |
| My Drizzle ORM automatically injects `where(eq(table.tenantId))`  |
+---------------------------------+---------------------------------+
                                  |
                                  v
+---------------------------------+---------------------------------+
| LAYER 3: POSTGRES RLS & DB SCHEMAS                                |
| My PostgreSQL Row Level Security policies reject cross-tenant SQL.|
+-------------------------------------------------------------------+
```

### My Drizzle ORM Schema Tenant Scoping Pattern

```typescript
import { pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';

export const tenantResources = pgTable('tenant_resources', {
  id: uuid('id').defaultRandom().primaryKey(),
  tenantId: text('tenant_id').notNull(), // My mandatory tenant isolation key
  resourceName: text('resource_name').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});
```

---

## 🔑 My JWT Authentication & Token Lifecycle

- **Signing Algorithm**: RS256 (RSA Signature with SHA-256)
- **Token Claims Payload**:
  ```json
  {
    "sub": "usr_90210",
    "tenant_id": "t_102",
    "role": "TENANT_ADMIN",
    "iat": 1786164240,
    "exp": 1786167840
  }
  ```
- **Secret Management**: I store API keys and RSA private keys strictly in secret managers (GCP Secret Manager) and never commit them to my code repositories.

---

## 🛠️ My Type-Safe Offline Mock Services Strategy

To facilitate deterministic local development, offline manual testing, and CI pipeline execution without requiring live database connections or paid third-party API keys:

1. **Mock Service Worker (MSW) & Adapter Layer**:
   All my frontend PWAs and Node.js microservices incorporate a type-safe mock adapter layer (`src/mocks/`).
2. **Deterministic Data Generators**:
   Faker-driven seed factories generate schema-compliant mock objects that exactly mirror my production Drizzle ORM types.
3. **Environment Toggle**:
   Setting `VITE_USE_MOCK_LAYER=true` or `NEXT_PUBLIC_ENABLE_MOCK=true` seamlessly intercepts network requests and routes them to my offline mock handlers.

```typescript
// My type-safe offline mock response generator example
export interface MockJobResponse {
  jobId: string;
  status: 'QUEUED' | 'PROCESSING' | 'COMPLETED';
  progress: number;
}

export const generateMockJob = (overrides?: Partial<MockJobResponse>): MockJobResponse => ({
  jobId: `mock_${Math.random().toString(36).substring(7)}`,
  status: 'PROCESSING',
  progress: 45,
  ...overrides
});
```
