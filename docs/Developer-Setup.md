# 💻 Developer Setup & Workspace Playbook

This playbook details local environment setup, prerequisites, configuration variables, and command execution for engineers working on the platforms.

---

## 🛠️ System Prerequisites

Ensure the following runtimes and CLI tools are installed on your workstation:

- **Node.js**: `v20.x` or `v22.x` (LTS)
- **Package Manager**: `npm` `v10+` (or `pnpm` `v9+`)
- **TypeScript**: `v5.5+`
- **Git**: `v2.40+`
- **GitHub CLI**: `gh` `v2.50+`
- **Docker & Docker Compose**: `v24+` (Optional for containerized database execution)

---

## ⚙️ Environment Configuration (`.env.example`)

Copy `.env.example` to `.env` in individual microservice repositories before starting dev servers:

```env
# Master Environment Mode
NODE_ENV=development
PORT=3000

# Database Configuration
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mohamedosamaai_db
REDIS_URL=redis://localhost:6379

# Multi-Tenant & Security Secrets
JWT_SECRET=super_secret_rsa_key_change_in_production
JWT_EXPIRES_IN=1h
ENCRYPTION_KEY=32_byte_hex_string_for_payload_encryption

# Offline Mock Layer
NEXT_PUBLIC_ENABLE_MOCK=true
VITE_USE_MOCK_LAYER=true

# AI Infrastructure Keys
VERTEX_AI_PROJECT_ID=bagbacktech-ai-prod
GEMINI_API_KEY=your_gemini_api_key_here
```

---

## 🚀 Execution Script Commands

Execute the following commands from the root directory of the ecosystem hub:

| Script Command | Command Line | Description |
| :--- | :--- | :--- |
| **Type Check** | `npm run check-types` | Runs `tsc --noEmit` to verify zero TypeScript errors. |
| **Build Packages** | `npm run build` | Compiles TypeScript declarations and outputs to `dist/`. |
| **Docker Compose Up** | `docker-compose up -d` | Starts local PostgreSQL and Redis container dependencies. |

---

## 🧪 Testing & Code Hygiene

Before creating pull requests or pushing commits to repositories:

```bash
# 1. Verify TypeScript strict compilation
npm run check-types

# 2. Build packages and verify outputs
npm run build

# 3. Check Git status for clean branch state
git status
```
