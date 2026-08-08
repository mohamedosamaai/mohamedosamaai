/**
 * Event Bus, SSE & WebSocket Protocol Payload Contracts
 * Mohamed Osama — Digital Transformation Architect & Founder @ Bagback Digital Solutions
 */

export type EventType = 'JOB_QUEUED' | 'JOB_PROGRESS' | 'JOB_COMPLETED' | 'JOB_FAILED' | 'DISPATCH_PING';

export interface SseEventPayload<T = unknown> {
  eventId: string;
  eventType: EventType;
  jobId: string;
  progressPercentage: number;
  data: T;
  timestamp: string;
}

export interface WebSocketMessage<T = unknown> {
  action: string;
  tenantId: string;
  payload: T;
  signature: string;
}
