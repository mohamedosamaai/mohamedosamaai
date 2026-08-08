/**
 * Multi-Tenant Data Isolation & Security Policy Specs
 * Mohamed Osama — Digital Transformation Architect & Founder @ Bagback Digital Solutions
 */

export interface TenantContext {
  tenantId: string;
  organizationName: string;
  isolationLevel: 'ROW_LEVEL' | 'SCHEMA_ISOLATED';
  activeRole: 'ADMIN' | 'OPERATOR' | 'VIEWER';
}

export interface JwtSecurityClaims {
  sub: string;
  tenant_id: string;
  role: string;
  iat: number;
  exp: number;
  iss: string;
}

export interface TenantIsolatedRecord {
  id: string;
  tenantId: string;
  createdAt: Date;
  updatedAt: Date;
}
