# 🔄 Data Flow and Sequence Diagrams

Inter-service communication sequences are designed around asynchronous job execution, real-time Server-Sent Events (SSE) streaming, and high-performance WebSocket event buses.

---

## 1. Asynchronous Job Execution Sequence

```mermaid
sequenceDiagram
    autonumber
    actor Client as Client App (PWA / Mobile)
    participant Gateway as API Gateway / Router
    participant API as ELITK API Server
    participant Redis as Redis Job Queue & Cache
    participant Worker as Background Task Worker
    participant DB as PostgreSQL Database

    Client->>Gateway: POST /api/v1/jobs/analyze (URL Payload)
    Gateway->>API: Validate JWT & Deduplicate Request
    
    alt Request Already Cached / In-Progress
        API-->>Gateway: Return Existing Job ID (Request Deduplicated)
        Gateway-->>Client: HTTP 200 OK { jobId, cached: true }
    else New Request
        API->>DB: Insert Initial Job Status (status: "QUEUED")
        API->>Redis: RPUSH jobQueue { jobId, payload, tenantId }
        API-->>Gateway: HTTP 202 Accepted { jobId, status: "QUEUED" }
        Gateway-->>Client: Return Job ID for Tracking
    end

    Redis->>Worker: LPOP jobQueue Task Payload
    Worker->>Worker: Execute Heavy Format Analysis / Media Processing
    Worker->>Redis: PUBLISH job_updates { jobId, progress: 50 }
    Worker->>DB: UPDATE jobs SET progress=100, status="COMPLETED"
    Worker->>Redis: SETEX job_result:jobId 3600 (Serialized Result)
```

---

## 2. Real-Time Server-Sent Events (SSE) Streaming Sequence

```mermaid
sequenceDiagram
    autonumber
    actor Client as Browser Client (React PWA)
    participant API as ELITK API Server (SSE Handler)
    participant Redis as Redis Pub/Sub Bus
    participant Worker as Background Worker

    Client->>API: GET /api/v1/jobs/:jobId/stream (Accept: text/event-stream)
    API->>API: Set Headers: Content-Type text/event-stream, Connection keep-alive
    API->>Redis: SUBSCRIBE job_channel:jobId
    API-->>Client: event: connected\ndata: {"status": "SUBSCRIBED"}\n\n

    loop Async Job Execution Updates
        Worker->>Redis: PUBLISH job_channel:jobId {"progress": 25, "step": "parsing"}
        Redis->>API: Message Payload
        API-->>Client: event: progress\ndata: {"progress": 25, "step": "parsing"}\n\n
        
        Worker->>Redis: PUBLISH job_channel:jobId {"progress": 75, "step": "encoding"}
        Redis->>API: Message Payload
        API-->>Client: event: progress\ndata: {"progress": 75, "step": "encoding"}\n\n
    end

    Worker->>Redis: PUBLISH job_channel:jobId {"progress": 100, "status": "COMPLETED"}
    Redis->>API: Message Payload
    API-->>Client: event: complete\ndata: {"resultUrl": "https://..."}\n\n
    API->>Client: Close SSE Stream Connection
```

---

## 3. WebSocket Event Bus Communication

```mermaid
sequenceDiagram
    autonumber
    actor Client as Desktop / Mobile Client
    participant WSS as WebSocket Server
    participant Auth as Auth & Token Verifier
    participant Bus as Internal Event Bus

    Client->>WSS: WSS Connect (wss://ops.bagbacktech.com/ws?token=JWT)
    WSS->>Auth: Verify JWT & Tenant Permissions
    Auth-->>WSS: Token Valid (tenantId: "t_102")
    WSS-->>Client: Connection Established (Session ACK)

    Client->>WSS: Send Action Message { action: "PING_LOCATION", lat: 25.2, lng: 55.27 }
    WSS->>Bus: Dispatch Event (type: "FIELD_AGENT_MOVED")
    Bus-->>WSS: Broadcast Updated Agent Positions
    WSS-->>Client: Broadcast Message { type: "DISPATCH_UPDATE", agents: [...] }
```

---

## 🔑 Key Engineering Patterns

- **Connection Cleanup**: SSE and WebSocket handlers implement strict heartbeat timeouts and client disconnect listeners to prevent socket memory leaks.
- **Request Deduplication**: In-flight HTTP POST analyze requests are keyed in Redis by SHA-256 payload hashes (`dedup:sha256`), preventing redundant worker processing in the cluster.
