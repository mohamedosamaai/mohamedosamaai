/**
 * RESTful API Specs & Request Deduplication Contract Interfaces
 * Mohamed Osama — Digital Transformation Architect & Founder @ Bagback Digital Solutions
 */

export interface ApiResponse<T = unknown> {
  success: boolean;
  statusCode: number;
  message: string;
  data?: T;
  error?: {
    code: string;
    details: string;
  };
}

export interface DeduplicationOptions {
  ttlSeconds: number;
  hashKey: string;
  bypassCache?: boolean;
}

export interface AsyncJobSubmission {
  jobId: string;
  status: 'QUEUED' | 'PROCESSING' | 'COMPLETED' | 'FAILED';
  deduplicated: boolean;
  streamUrl: string;
  createdAt: string;
}
