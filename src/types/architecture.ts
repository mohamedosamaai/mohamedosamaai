/**
 * Portfolio Architecture & Microservice Classification Contracts
 * Mohamed Osama — Digital Transformation Architect & Founder @ Bagback Digital Solutions
 */

export type ArchitectureTier = 'Core Platform' | 'Developer Infrastructure' | 'Enterprise & Client Solution';

export interface ServiceModule {
  id: string;
  name: string;
  tier: ArchitectureTier;
  primaryStack: string[];
  description: string;
  productionUrl?: string;
  isPublicShowcase: boolean;
}

export interface EcosystemOverview {
  architect: string;
  organization: string;
  primaryLanguage: 'TypeScript';
  architectureStyle: 'Event-Driven Clean Microservices';
  activePlatformsCount: number;
}

export const ecosystemSummary: EcosystemOverview = {
  architect: 'Mohamed Osama',
  organization: 'Bagback Digital Solutions',
  primaryLanguage: 'TypeScript',
  architectureStyle: 'Event-Driven Clean Microservices',
  activePlatformsCount: 17
};
