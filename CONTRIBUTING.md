# Contributing Guidelines

Thank you for your interest in contributing to Mohamed Osama's master software ecosystem.

## 📐 Engineering Standards

All contributions, feature pull requests, and codebase modifications must comply with our four core principles:

1. **Zero-Trust Type Safety**: Strict TypeScript (`tsc --noEmit`), Python (`mypy --strict`), and Kotlin compilation with zero untyped `any` signatures.
2. **Multi-Tenant Data Isolation**: Database queries and ORM calls must include explicit `tenant_id` scoping or row-level security policies.
3. **Asynchronous Architecture**: Heavy computational tasks must be dispatched to background workers (Redis Pub/Sub, IMAP parsing queues) rather than blocking the HTTP loop.
4. **Clean Branch Hygiene**: Temporary feature branches must be merged cleanly into `main` without pushing unmerged draft branches to remote showcase repositories.

## 🧪 Verification Protocol

Before submitting a pull request:
```bash
# 1. Verify strict TypeScript compilation
npm run type-check

# 2. Execute local showcase generator script
powershell -ExecutionPolicy Bypass -File ./tools/showcase-generator.ps1
```

## 📬 Security Concerns

If you discover a potential security vulnerability, please refer to our [Security Policy](SECURITY.md) or email `hello@bagbacktech.com` directly.
