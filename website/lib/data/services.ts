export interface ServiceOffering {
  id: string;
  slug: string;
  name: string;
  tagline: string;
  badge?: string;
  category: "implementation" | "curriculum" | "training" | "enterprise";
  targetAudience: string;
  description: string;
  scopeAndDeliverables: string[];
  timeline: string;
  customerResponsibilities: string[];
  pricingModel: string;
  startingEstimate?: string;
  ctaText: string;
}

export const servicesData: ServiceOffering[] = [
  {
    id: "srv-onboarding",
    slug: "school-onboarding-implementation",
    name: "School Onboarding & SIS Deployment",
    tagline: "Turnkey digital infrastructure rollout for K-12 institutions and school chains.",
    badge: "Core Service",
    category: "implementation",
    targetAudience: "School Principals, IT Administrators & Trust Managements",
    description:
      "A guided, white-glove onboarding package where Qrie implementation specialists configure your school tenancy, migrate student/teacher rosters from your existing ERP/SIS, verify device compatibility, and conduct pre-launch dry runs.",
    scopeAndDeliverables: [
      "School tenant creation in Qrie multi-tenant cluster with dedicated cryptographic realm",
      "Automated roster import & validation for students, teachers, sections, and subjects",
      "School branding setup (school logo, colors, motto, and custom Android app splash configuration)",
      "Wi-Fi and edge connectivity audit for low-bandwidth school computer labs and devices",
      "Admin portal walk-through and institutional governance sign-off",
    ],
    timeline: "2 to 3 weeks depending on student roll size",
    customerResponsibilities: [
      "Providing clean CSV/Excel student rosters with verified class section allocations",
      "Designating an internal School IT Point of Contact",
      "Ensuring teacher attendance for scheduled setup sessions",
    ],
    pricingModel: "One-time institutional setup fee based on student population",
    startingEstimate: "₹25,000 one-time",
    ctaText: "Request Implementation Quote",
  },
  {
    id: "srv-curriculum",
    slug: "curriculum-custom-mapping",
    name: "Curriculum & Custom Content Mapping",
    tagline: "Customizing topic hierarchies, worksheets, and textbooks to your school's unique academic calendar.",
    category: "curriculum",
    targetAudience: "Academic Directors, Subject Department Heads & Publishing Partners",
    description:
      "While Qrie natively supports CBSE and NCERT Class 6–12 frameworks, many schools follow proprietary term plans or state board modifications. Our curriculum specialists digitize your school's lesson order, map custom question sets to LAM concept tags, and establish topic prerequisites.",
    scopeAndDeliverables: [
      "Alignment of existing school worksheets with LAM Bayesian concept graphs",
      "Digital conversion and verification of term test blueprints and question papers",
      "Prerequisite concept mapping to enable precise automated misconception alerts",
      "Custom tagging for regional language or State Board syllabus variations",
    ],
    timeline: "3 to 4 weeks per subject department",
    customerResponsibilities: [
      "Providing authorized syllabus documents and proprietary question banks in editable format",
      "Review and sign-off by Subject Department Heads",
    ],
    pricingModel: "Per-subject or per-grade curriculum digitization quotation",
    startingEstimate: "Custom Quote",
    ctaText: "Consult Curriculum Team",
  },
  {
    id: "srv-teacher-training",
    slug: "teacher-ai-enablement",
    name: "Teacher Pedagogy & AI Co-Pilot Workshops",
    tagline: "Hands-on certification for educators to maximize classroom impact using AI diagnostics.",
    badge: "Recommended",
    category: "training",
    targetAudience: "Classroom Teachers, Section In-Charges & Academic Coordinators",
    description:
      "Educational AI succeeds only when teachers are empowered, not replaced. This hybrid workshop program trains educators to interpret LAM struggle heatmaps, assign targeted homework, conduct data-driven micro-interventions, and save 5+ hours weekly on grading.",
    scopeAndDeliverables: [
      "Interactive 2-day on-campus or virtual workshop series",
      "Teacher mobile app and web portal hands-on training (homework, rosters, grading)",
      "Interpreting cognitive BKT mastery scores and misconception diagnostic alerts",
      "Classroom case studies: turning data alerts into 5-minute remedial interventions",
      "Official 'Qrie Certified AI-Enabled Educator' completion certificates",
    ],
    timeline: "2-day intensive with 30-day ongoing mentorship",
    customerResponsibilities: [
      "Allocating 4 hours of uninterrupted workshop time for participating faculty",
      "Teachers equipped with Android mobile phones or laptops",
    ],
    pricingModel: "Flat institutional workshop fee (up to 35 teachers per batch)",
    startingEstimate: "₹15,000 per cohort",
    ctaText: "Book Teacher Workshop",
  },
  {
    id: "srv-enterprise-sla",
    slug: "enterprise-integration-sla",
    name: "Enterprise Integration & Dedicated SLA",
    tagline: "Custom SSO, existing LMS bridges, dedicated server clusters, and 99.9% uptime guarantees.",
    category: "enterprise",
    targetAudience: "Large Educational Foundations, School Chains (20+ Branches) & State Initiatives",
    description:
      "For large school foundations and state educational boards requiring custom SAML/OAuth single sign-on, integration with existing Google Classroom or Microsoft Teams infrastructure, and prioritized 24/7 technical support.",
    scopeAndDeliverables: [
      "Custom Single Sign-On (Google Workspace, Microsoft Entra, SAML 2.0)",
      "Direct API access to LAM state engine with custom webhooks",
      "Dedicated PostgreSQL instance with independent VPC peering and automated daily backups",
      "Contractual 99.9% uptime Service Level Agreement (SLA) with 1-hour critical response",
      "Dedicated Technical Account Manager and quarterly executive reviews",
    ],
    timeline: "4 to 6 weeks for custom integration",
    customerResponsibilities: [
      "Access to enterprise identity provider directory for SSO configuration",
      "Regular quarterly technical review coordination",
    ],
    pricingModel: "Annual enterprise contract with dedicated support retainer",
    startingEstimate: "Custom Enterprise Quote",
    ctaText: "Contact Enterprise Sales",
  },
];
