# 📐 System Architecture (C4 Model)

The **C4 Model** (Context & Container Levels) maps the architectural boundaries of the software ecosystem.

---

## 1. C4 Context Level Diagram

This diagram illustrates how human personas interact with the overall edge and backend infrastructure.

```mermaid
C4Context
    title System Context Diagram — Master Ecosystem Architecture

    Person(client, "Enterprise Client / User", "Accesses SaaS portals, e-commerce stores, and 3D experiences.")
    Person(fieldOp, "Field Operations Agent", "Uses mobile apps and dispatch dashboards for field tasks.")
    Person(admin, "System Administrator (Mohamed Osama)", "Monitors cluster health, manages tenant isolation, and reviews security audit logs.")

    System(ecosystem, "Master Ecosystem Architecture", "Distributed multi-tenant platforms, API gateways, real-time dispatch, and 3D engines.")

    System_Ext(googleCloud, "Google Cloud Platform", "Hosting Vertex AI, Cloud Storage, and BigQuery analytics.")
    System_Ext(stripe, "Stripe Payments", "Processes multi-vendor payment checkouts and recurring subscriptions.")
    System_Ext(github, "GitHub Actions CI/CD", "Automated linting, type-checking, CodeQL security scanning, and deployments.")

    Rel(client, ecosystem, "Interacts via Web Browsers & PWAs", "HTTPS / WSS")
    Rel(fieldOp, ecosystem, "Submits job updates & field reports", "REST / Mobile SDK")
    Rel(admin, ecosystem, "Configures tenants & inspects logs", "HTTPS / Admin API")

    Rel(ecosystem, googleCloud, "Invokes AI models & stores media", "gRPC / REST")
    Rel(ecosystem, stripe, "Executes payment transactions & webhooks", "HTTPS REST")
    Rel(github, ecosystem, "Runs build pipeline & pushes release tags", "Git / SSH")
```

---

## 2. C4 Container Level Diagram

This diagram decomposes the ecosystem into runtime containers: Web PWAs, API Gateways, Microservices, Async Job Stores, Caches, and Databases.

```mermaid
graph TB
    subgraph ClientSpace ["📱 Client & Browser Containers"]
        WebPWA["React 19 / Next.js 15 Web PWA<br/><i>(Client-Side Rendering + Service Worker)</i>"]
        MobileApp["Android Ops Application<br/><i>(Kotlin + Firebase SDK)</i>"]
        WebGLComp["3D WebGL Canvas<br/><i>(Three.js + R3F + MediaPipe Vision)</i>"]
    end

    subgraph EdgeSpace ["🌐 Edge & Routing Containers"]
        NGINX["Caddy 2 / Nginx Reverse Proxy<br/><i>(Rate Limiting & SSL Renewal)</i>"]
        GatewayContainer["Bagback Gateway Router<br/><i>(Express.js + JWT Validation)</i>"]
    end

    subgraph ServiceSpace ["⚡ Microservice Containers"]
        APIServerContainer["ELITK API Server<br/><i>(Express + TypeScript + SSE)</i>"]
        VunoContainer["Vuno Foundation Engine<br/><i>(Python + Vertex AI SDK)</i>"]
        MailWorkerContainer["Bagback Webmail Worker<br/><i>(Node.js + IMAPFlow + Mailparser)</i>"]
    end

    subgraph DataSpace ["💾 Persistence & Cache Containers"]
        RedisCache[("Redis In-Memory Job Store & Cache<br/><i>(Pub/Sub + Task Queues)</i>")]
        PostgresDB[("PostgreSQL Multi-Tenant Database<br/><i>(Drizzle ORM + Connection Pool)</i>")]
        VectorStore[("Vector DB Embeddings Store<br/><i>(HNSW Vector Index)</i>")]
        GCS[("Google Cloud Storage & Media Cache")]
    end

    %% Routing
    WebPWA --> NGINX
    MobileApp --> NGINX
    WebGLComp --> NGINX

    NGINX --> GatewayContainer
    GatewayContainer --> APIServerContainer

    %% Internal Service Calls
    APIServerContainer --> VunoContainer
    APIServerContainer --> MailWorkerContainer

    %% Data Connections
    APIServerContainer --> RedisCache
    APIServerContainer --> PostgresDB
    VunoContainer --> VectorStore
    VunoContainer --> GCS
```

---

## 3. Container Responsibilities Breakdown

| Container | Tech Stack | Architectural Responsibilities |
| :--- | :--- | :--- |
| **Web PWA** | Next.js 15, React 19, TailwindCSS | SSR/ISR page rendering, offline asset caching via Service Worker, UI state management. |
| **Reverse Proxy** | Caddy 2, Certbot SSL | TLS termination, DDoS rate-limiting, static file serving, and upstream load balancing. |
| **API Gateway** | Express.js, TypeScript | Request deduplication, JWT authentication header verification, API rate-limit enforcement. |
| **API Server** | Express.js, Node.js, SSE | Core business logic, SSE streaming endpoint, database transaction management. |
| **In-Memory Job Store** | Redis 7.2 | Async task queue, job status pub/sub, real-time session caching. |
| **PostgreSQL Database** | PostgreSQL 16, Drizzle ORM | Persistent relational data, multi-tenant row-level isolation policies. |
| **Vector DB Store** | pgvector / HNSW | High-dimensional embedding storage for semantic document search. |
