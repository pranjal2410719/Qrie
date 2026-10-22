export interface Product {
  id: string;
  slug: string;
  name: string;
  tagline: string;
  badge?: string;
  category: "mobile-app" | "ai-engine" | "school-platform" | "assessment";
  targetAudience: string;
  description: string;
  longDescription: string;
  highlights: string[];
  features: { title: string; description: string }[];
  technicalSpecs: { label: string; value: string }[];
  availability: "Available Now" | "Pilot Ready" | "Institutional Only";
  pricingType: "fixed" | "quote-only" | "subscription";
  startingPrice?: number; // In INR
  billingInterval?: "monthly" | "annually" | "one-time";
  canAddToCart: boolean;
  ctaText: string;
  ctaHref: string;
}

export const productsData: Product[] = [
  {
    id: "prod-student-app",
    slug: "qrie-student-app",
    name: "Qrie AI Student App",
    tagline: "Personalized NCERT learning, step-by-step AI tutor, and gamified progress for Android.",
    badge: "Most Popular",
    category: "mobile-app",
    targetAudience: "Students in CBSE/NCERT Classes 6–12 & Parents",
    description:
      "A lightweight, offline-first Flutter Android client designed for low-bandwidth environments. Features chapter-wise NCERT mastery, step-by-step doubt resolution, and spaced retention practice.",
    longDescription:
      "The Qrie AI Student App brings personalized educational tutoring directly to mobile devices. Built using Flutter for smooth 60fps performance on cost-effective Android hardware, it features an offline-first SQLite outbox architecture that synchronizes progress smoothly even on patchy cellular connectivity. Students work through NCERT curriculum concepts, practice questions with symbolic math validation, and receive 24/7 AI tutor guidance without leaving their flow.",
    highlights: [
      "Full NCERT Classes 6–12 Science, Math & English coverage",
      "Offline-first SQLite sync engine for low-bandwidth Indian environments",
      "24/7 step-by-step AI tutor with multi-step explanation escalation",
      "Gamified learning streaks, XP, gems, and topic mastery pills",
    ],
    features: [
      {
        title: "Bento Dashboard Architecture",
        description:
          "Pastel Bento & Onyx mobile design tokens providing clear daily goals, lecture records, and pending assignments at a glance.",
      },
      {
        title: "Step-by-Step Doubt Resolution",
        description:
          "Interactive chat assistant that provides Socratic hints rather than just giving away final answers, encouraging deep understanding.",
      },
      {
        title: "Adaptive Practice Quizzes",
        description:
          "Quizzes that dynamically adjust difficulty based on real-time evidence processed by the Learning Adaptation Model (LAM).",
      },
      {
        title: "School System Synchronization",
        description:
          "Seamless linking with institutional DPS and CBSE school codes to download teacher homework and official study notes.",
      },
    ],
    technicalSpecs: [
      { label: "Target Platform", value: "Android 8.0+ (ARM64 & ARMv7)" },
      { label: "Client Engine", value: "Flutter (Dart 3.x), Material 3 tokens" },
      { label: "Offline Storage", value: "SQLite outbox queue with idempotent sync" },
      { label: "Bandwidth Footprint", value: "Optimized for 2G/3G edge connections" },
      { label: "Security", value: "Android Keystore-backed AES session tokens" },
    ],
    availability: "Available Now",
    pricingType: "subscription",
    startingPrice: 499,
    billingInterval: "monthly",
    canAddToCart: true,
    ctaText: "Get Student Pro",
    ctaHref: "/checkout?product=qrie-student-app",
  },
  {
    id: "prod-lam-engine",
    slug: "qrie-lam-engine",
    name: "Learning Adaptation Model (LAM)",
    tagline: "Autonomous educational intelligence engine powered by Bayesian Knowledge Tracing.",
    badge: "Core Technology",
    category: "ai-engine",
    targetAudience: "EdTech Developers, Educational Institutions & Researchers",
    description:
      "Qrie's proprietary learning intelligence engine running in an isolated FastAPI service. Decouples application operations from adaptive cognitive models, BKT mastery probability, and spaced retrieval scheduling.",
    longDescription:
      "LAM (Learning Adaptation Model) is Qrie's core algorithmic differentiator. Unlike generic large language models that act as chatbots, LAM is a specialized cognitive state machine that estimates student concept mastery using Bayesian Knowledge Tracing (BKT parameters: L0 initial knowledge, T learning rate, G guess probability, S slip probability). LAM processes tamper-evident learning interaction ledgers to compute topic-level mastery, diagnose misconceptions, and schedule delayed retrieval interventions before forgetting occurs.",
    highlights: [
      "Mathematical Bayesian Knowledge Tracing (BKT) probability tracking",
      "Nine-level assistance escalation matrix (from Socratic nudge to full breakdown)",
      "Spaced retrieval scheduler with decaying half-life forgetting curves",
      "VPC-isolated server-to-server relay with tamper-evident event auditing",
    ],
    features: [
      {
        title: "Cognitive State Ledger",
        description:
          "Maintains an immutable append-only event stream of learning interactions, test submissions, and hint consumption.",
      },
      {
        title: "Misconception Diagnostic Graphs",
        description:
          "Discovers and flags underlying conceptual errors before they cascade into advanced prerequisite topics.",
      },
      {
        title: "Next-Best Action Recommender",
        description:
          "Algorithmic decision engine that chooses whether a student should read, practice, revise, or advance.",
      },
      {
        title: "Teacher Visibility Bridge",
        description:
          "Aggregates granular individual student data into class-level struggle alerts without exposing raw PII.",
      },
    ],
    technicalSpecs: [
      { label: "Core Runtime", value: "Python 3.12 / FastAPI / asyncpg" },
      { label: "Database", value: "Dedicated PostgreSQL event ledger" },
      { label: "Algorithmic Base", value: "Bayesian Knowledge Tracing (BKT) & Ebbinghaus Decay" },
      { label: "Interface", value: "Server-to-Server HMAC signed JSON REST API" },
      { label: "Throughput", value: "<15ms sub-second cognitive state inference" },
    ],
    availability: "Institutional Only",
    pricingType: "quote-only",
    canAddToCart: false,
    ctaText: "Request LAM Evaluation",
    ctaHref: "/get-a-quote?product=qrie-lam-engine",
  },
  {
    id: "prod-school-platform",
    slug: "qrie-school-platform",
    name: "Qrie School Platform",
    tagline: "End-to-end institutional software connecting administration, teachers, and classrooms.",
    badge: "For Schools",
    category: "school-platform",
    targetAudience: "School Principals, CBSE/ICSE Trustees & Academic Coordinators",
    description:
      "A complete institutional operating system comprising the Teacher Android App, Student Mobile App, and Web Administrative Portal with multi-tenant row-level security.",
    longDescription:
      "The Qrie School Platform equips educational institutions with modern digital infrastructure. Designed specifically for CBSE, ICSE, and State Board schools across India, it provides dual mobile applications alongside comprehensive web portals. Teachers distribute digital homework, review real-time struggle heatmaps, and monitor student comprehension. Administrators manage academic rosters, section allocations, and timetable compliance with strict tenant isolation.",
    highlights: [
      "Dual Android apps for school staff and students",
      "Teacher & Administrator Web Portals (Next.js App Router)",
      "Multi-tenant PostgreSQL architecture with strict row-level security (RLS)",
      "Automated homework distribution and diagnostic grading",
    ],
    features: [
      {
        title: "Teacher Mobile & Web Co-Pilot",
        description:
          "Empowers educators with automated homework creation, student struggle indicators, and mastery alerts.",
      },
      {
        title: "Class & Section Roster Management",
        description:
          "Easily manage multi-section classes, teacher allocations, and academic timetable scheduling.",
      },
      {
        title: "Institutional Mastery Heatmaps",
        description:
          "Visual topic-level analytics highlighting which curriculum concepts have class-wide learning gaps.",
      },
      {
        title: "DPDP 2023 Compliant Data Protection",
        description:
          "Strict school tenancy barriers ensuring institutional student data is never mixed or used to train third-party models.",
      },
    ],
    technicalSpecs: [
      { label: "Web Portal", value: "Next.js App Router (React Server Components)" },
      { label: "Teacher App", value: "Android Mobile Client (Class 6–12 Tools)" },
      { label: "Backend Core", value: "Fastify Node.js microservices + Supabase PostgreSQL" },
      { label: "Tenancy Model", value: "Row-Level Security (RLS) with UUID tenant tokens" },
      { label: "Compliance", value: "India DPDP Act 2023 & ISO 27001 readiness" },
    ],
    availability: "Pilot Ready",
    pricingType: "quote-only",
    canAddToCart: false,
    ctaText: "Book School Demonstration",
    ctaHref: "/school-demo",
  },
  {
    id: "prod-assessment-engine",
    slug: "qrie-assessment-engine",
    name: "Qrie Diagnostic & Assessment Engine",
    tagline: "Precision evaluation with symbolic math validation and mistake classification.",
    category: "assessment",
    targetAudience: "Schools, Coaching Institutes & Autonomous Assessment Centers",
    description:
      "An automated assessment pipeline that evaluates multi-step student answers, detects algebraic syntax errors, and validates conceptual understanding beyond simple multiple choice.",
    longDescription:
      "Traditional online quizzes rely on simple multiple choice where students can guess answers without understanding. The Qrie Diagnostic & Assessment Engine changes this by evaluating multi-step mathematical and scientific responses using symbolic expression analysis and structured question schemas. When a student makes an error, the engine diagnoses whether it was an arithmetic slip, a sign inversion, or a conceptual misconception.",
    highlights: [
      "Symbolic mathematics verification (handles fractions, exponents, equations)",
      "Fine-grained error tagging: slips vs systemic misconceptions",
      "Anti-guessing penalty algorithms connected with BKT parameters",
      "Instant feedback loops with step-specific remedial lessons",
    ],
    features: [
      {
        title: "Multi-Step Symbolic Math Evaluator",
        description:
          "Validates mathematical equivalence regardless of syntax variation (e.g. 2x+4 vs 2(x+2)).",
      },
      {
        title: "Misconception Tagging",
        description:
          "Maps incorrect answer choices to specific pre-identified cognitive pitfalls for immediate correction.",
      },
      {
        title: "Automated Homework Grading",
        description:
          "Saves teachers hours of manual correction while providing students with instant explanatory feedback.",
      },
      {
        title: "Curriculum Item Bank",
        description:
          "Over 25,000+ curriculum-aligned NCERT questions categorized by difficulty and cognitive depth.",
      },
    ],
    technicalSpecs: [
      { label: "Input Formats", value: "Symbolic LaTeX, MathJSON, Numerical & Structured Choice" },
      { label: "Response Latency", value: "<80ms instantaneous server evaluation" },
      { label: "Question Bank", value: "NCERT Classes 6–12 Physics, Chemistry, Biology, Math" },
      { label: "Export Formats", value: "CBSE question paper standard, PDF, CSV, JSON" },
    ],
    availability: "Available Now",
    pricingType: "subscription",
    startingPrice: 1999,
    billingInterval: "annually",
    canAddToCart: true,
    ctaText: "Order Assessment Kit",
    ctaHref: "/checkout?product=qrie-assessment-engine",
  },
];
