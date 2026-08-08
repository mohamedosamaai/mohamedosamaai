# 🔌 API & Integrations Specification

This specification documents core RESTful API endpoints, request deduplication architecture, and Server-Sent Events (SSE) stream contracts across the ecosystem.

---

## 🌐 Standard RESTful API Endpoints

### 1. Job Creation & Media Analysis

#### `POST /api/v1/jobs/analyze`
Submits a target URL or media asset payload for format analysis and processing.

- **Headers**:
  ```http
  Authorization: Bearer <JWT_TOKEN>
  Content-Type: application/json
  X-Tenant-ID: t_102
  ```

- **Request Body**:
  ```json
  {
    "url": "https://example.com/media/stream-1080p.mp4",
    "requestedFormats": ["mp4", "webm", "audio_aac"],
    "quality": "high",
    "webhookUrl": "https://client.app/api/webhooks/job-complete"
  }
  ```

- **Response (202 Accepted / 200 OK)**:
  ```json
  {
    "success": true,
    "jobId": "job_984f-2026x8",
    "status": "QUEUED",
    "deduplicated": false,
    "createdAt": "2026-08-08T07:24:00Z",
    "streamUrl": "/api/v1/jobs/job_984f-2026x8/stream"
  }
  ```

---

### 2. Request Deduplication Logic

To prevent redundant processing of identical concurrent HTTP requests:
1. The API Server generates an MD5/SHA256 hash of the normalized request body.
2. The server attempts an atomic `SETNX` key operation in Redis:
   `dedup:req:<hash>` with a 30-second TTL.
3. If `SETNX` returns `0`, the request is currently in-flight; the API Server returns the existing `jobId` immediately without enqueueing a duplicate job.

---

### 3. Server-Sent Events (SSE) Streaming Endpoint

#### `GET /api/v1/jobs/:jobId/stream`
Establishes a persistent uni-directional event stream to push real-time status updates to the client.

- **Headers**:
  ```http
  Accept: text/event-stream
  Cache-Control: no-cache
  Connection: keep-alive
  ```

- **Event Stream Protocol Payload Examples**:

  - **Connected Event**:
    ```http
    event: connected
    data: {"jobId":"job_984f-2026x8","timestamp":1786164240000}

    ```

  - **Progress Event**:
    ```http
    event: progress
    data: {"jobId":"job_984f-2026x8","progress":45,"step":"Extracting Audio Channels","bitrate":"320kbps"}

    ```

  - **Complete Event**:
    ```http
    event: complete
    data: {"jobId":"job_984f-2026x8","progress":100,"status":"COMPLETED","outputUrl":"https://storage.bagbacktech.com/output/job_984f-2026x8.mp4"}

    ```

  - **Error Event**:
    ```http
    event: error
    data: {"jobId":"job_984f-2026x8","code":"ERR_FORMAT_UNSUPPORTED","message":"Target media stream codec is invalid."}

    ```

---

## 🛡️ Error Code Matrix

| Error Code | HTTP Status | Description | Action Required |
| :--- | :--- | :--- | :--- |
| `ERR_AUTH_MISSING` | `401 Unauthorized` | Missing or expired JWT token header. | Refresh bearer token and retry. |
| `ERR_TENANT_FORBIDDEN` | `403 Forbidden` | User lacks access privileges to target tenant resource. | Request tenant role elevation. |
| `ERR_DEDUPLICATION_LOCK` | `429 Too Many Requests` | Rapid burst duplicate requests detected. | Wait for in-flight job stream. |
| `ERR_WORKER_TIMEOUT` | `504 Gateway Timeout` | Background worker failed to report heartbeat within SLA. | Retry job creation. |
