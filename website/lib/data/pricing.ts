export interface PricingTier {
  id: string;
  name: string;
  tagline: string;
  badge?: string;
  priceMonthly: number;
  priceAnnual: number;
  currency: string;
  billingText: string;
  targetUser: string;
  popular?: boolean;
  features: string[];
  notIncluded?: string[];
  ctaText: string;
  ctaHref: string;
  isQuoteOnly?: boolean;
}

export const pricingTiers: PricingTier[] = [
  {
    id: "tier-free",
    name: "Student Starter",
    tagline: "Essential NCERT learning and core practice for independent students.",
    priceMonthly: 0,
    priceAnnual: 0,
    currency: "INR",
    billingText: "Free forever",
    targetUser: "Individual students exploring self-paced study",
    features: [
      "Access to all NCERT Class 6–10 textbook summaries",
      "5 AI doubt-solving sessions per day",
      "Standard chapter practice quizzes",
      "Daily study streak & XP tracking",
      "Android mobile app access",
    ],
    notIncluded: [
      "Unlimited AI tutor explanations",
      "Advanced LAM misconception diagnosis",
      "Offline lesson download & SQLite outbox sync",
      "School homework & teacher class linking",
    ],
    ctaText: "Start Learning Free",
    ctaHref: "/demo",
  },
  {
    id: "tier-pro",
    name: "Student Pro",
    tagline: "Full access to 24/7 AI tutoring, deep LAM personalized revision, and exam prep.",
    badge: "Most Popular",
    popular: true,
    priceMonthly: 499,
    priceAnnual: 4490, // ~25% annual savings
    currency: "INR",
    billingText: "Billed monthly or annually",
    targetUser: "Dedicated students preparing for CBSE/ICSE board exams",
    features: [
      "Unlimited 24/7 step-by-step AI tutor assistance",
      "Deep LAM cognitive mastery tracking across all topics",
      "Spaced retrieval revision alerts before forgetting occurs",
      "Symbolic math error verification and instant feedback",
      "Offline lesson downloads with background sync",
      "Full NCERT Classes 6–12 Science, Math & English",
      "Priority customer and academic support",
    ],
    ctaText: "Get Student Pro",
    ctaHref: "/checkout?product=qrie-student-app",
  },
  {
    id: "tier-school",
    name: "School Essential",
    tagline: "Connected digital software for schools: Teacher App, Student App, and Admin Portal.",
    badge: "Institutions",
    priceMonthly: 85,
    priceAnnual: 850,
    currency: "INR",
    billingText: "per student / year (min 150 students)",
    targetUser: "CBSE & State Board schools modernizing their academic delivery",
    isQuoteOnly: true,
    features: [
      "Full Student Android App access for all enrolled students",
      "Teacher Android App & Web Portal with class rosters",
      "Automated digital homework distribution & correction",
      "Real-time student struggle heatmaps and early alerts",
      "School branding (school crest, colors & motto in app)",
      "Dedicated school onboarding & teacher training session",
      "Strict multi-tenant Row-Level Security (RLS) data protection",
    ],
    ctaText: "Request School Proposal",
    ctaHref: "/get-a-quote?product=qrie-school-platform",
  },
  {
    id: "tier-enterprise",
    name: "School Enterprise",
    tagline: "Customized institutional deployment for school chains, trusts, and state boards.",
    priceMonthly: 0,
    priceAnnual: 0,
    currency: "INR",
    billingText: "Custom quotation",
    targetUser: "Large educational trusts (2,000+ students) & multi-branch schools",
    isQuoteOnly: true,
    features: [
      "Everything in School Essential",
      "Custom Single Sign-On (SAML 2.0, Google Workspace, Entra ID)",
      "Direct API access to LAM cognitive state engine",
      "Dedicated PostgreSQL instance with independent VPC peering",
      "Custom curriculum mapping for school-specific textbooks",
      "Dedicated Technical Account Manager & 99.9% uptime SLA",
      "Quarterly executive academic reviews and impact reports",
    ],
    ctaText: "Talk to Enterprise Sales",
    ctaHref: "/contact/sales",
  },
];

export interface FeatureComparisonCategory {
  category: string;
  items: {
    feature: string;
    starter: boolean | string;
    pro: boolean | string;
    school: boolean | string;
    enterprise: boolean | string;
  }[];
}

export const featureComparisonMatrix: FeatureComparisonCategory[] = [
  {
    category: "Student Experience & AI Tutor",
    items: [
      {
        feature: "NCERT Curriculum Coverage",
        starter: "Classes 6–10",
        pro: "Classes 6–12",
        school: "Classes 6–12 Full",
        enterprise: "Custom + Classes 6–12",
      },
      {
        feature: "AI Doubt Solving Questions",
        starter: "5 / day",
        pro: "Unlimited",
        school: "Unlimited",
        enterprise: "Unlimited",
      },
      {
        feature: "Multi-Step Explanation Escalation",
        starter: "Basic",
        pro: "Full 9-Level",
        school: "Full 9-Level",
        enterprise: "Full 9-Level",
      },
      {
        feature: "Offline Lesson Caching (SQLite)",
        starter: false,
        pro: true,
        school: true,
        enterprise: true,
      },
      {
        feature: "Gamified Badges & Streaks",
        starter: true,
        pro: true,
        school: true,
        enterprise: true,
      },
    ],
  },
  {
    category: "Learning Adaptation Model (LAM)",
    items: [
      {
        feature: "Bayesian Knowledge Tracing (BKT)",
        starter: "Standard",
        pro: "Advanced",
        school: "Full Institutional",
        enterprise: "Custom Parameters",
      },
      {
        feature: "Misconception Diagnosis",
        starter: false,
        pro: true,
        school: true,
        enterprise: true,
      },
      {
        feature: "Spaced Retention Revision Engine",
        starter: false,
        pro: true,
        school: true,
        enterprise: true,
      },
      {
        feature: "Direct API Access to LAM State",
        starter: false,
        pro: false,
        school: false,
        enterprise: true,
      },
    ],
  },
  {
    category: "Teacher & School Tools",
    items: [
      {
        feature: "Teacher Android Client",
        starter: false,
        pro: false,
        school: true,
        enterprise: true,
      },
      {
        feature: "Teacher & Admin Web Portal",
        starter: false,
        pro: false,
        school: true,
        enterprise: true,
      },
      {
        feature: "Homework Distribution & Grading",
        starter: false,
        pro: false,
        school: true,
        enterprise: true,
      },
      {
        feature: "Class Mastery Heatmaps & Struggle Alerts",
        starter: false,
        pro: false,
        school: true,
        enterprise: true,
      },
      {
        feature: "School Branding & Custom App Splash",
        starter: false,
        pro: false,
        school: true,
        enterprise: true,
      },
    ],
  },
  {
    category: "Security, Governance & Support",
    items: [
      {
        feature: "Data Residency & Multi-Tenancy",
        starter: "Shared",
        pro: "Shared Cloud",
        school: "Tenant-Isolated (RLS)",
        enterprise: "Dedicated VPC / DB",
      },
      {
        feature: "India DPDP Act 2023 Compliance",
        starter: true,
        pro: true,
        school: true,
        enterprise: true,
      },
      {
        feature: "Single Sign-On (Google/SAML)",
        starter: false,
        pro: false,
        school: "Optional Add-on",
        enterprise: true,
      },
      {
        feature: "Support SLA",
        starter: "Community",
        pro: "Standard Email (24h)",
        school: "Priority Desk (4h)",
        enterprise: "1-Hour Critical 24/7",
      },
    ],
  },
];
