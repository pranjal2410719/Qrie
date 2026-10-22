export interface NavItem {
  title: string;
  href: string;
  description?: string;
  badge?: string;
  children?: NavItem[];
}

export const siteConfig = {
  name: "Qrie AI",
  legalName: "Qrie Learning Technologies",
  description:
    "Adaptive, school-ready AI learning platform powered by the Learning Adaptation Model (LAM). Personalized NCERT lessons, continuous mastery tracking, and connected apps for students, teachers, and schools.",
  url: "https://qrie.ai",
  ogImage: "https://qrie.ai/Q_logo.png",
  domain: "qrie.ai",
  contactEmail: "support@qrie.ai",
  salesEmail: "sales@qrie.ai",
  phone: "+91 80 4567 8900",
  address: {
    street: "Outer Ring Road, Bellandur",
    city: "Bengaluru",
    state: "Karnataka",
    postalCode: "560103",
    country: "India",
  },
  social: {
    twitter: "https://twitter.com/qrieai",
    github: "https://github.com/pranjal2410719/Qrie",
    linkedin: "https://linkedin.com/company/qrie-ai",
    youtube: "https://youtube.com/@qrieai",
  },
  mainNav: [
    {
      title: "Platform",
      href: "/platform",
      children: [
        {
          title: "Platform Overview",
          href: "/platform",
          description: "Complete ecosystem connecting students, teachers, and school administrators.",
        },
        {
          title: "How Qrie Works",
          href: "/how-it-works",
          description: "The 8-step cycle of assessment, targeted teaching, testing, and spaced retention.",
        },
        {
          title: "AI Tutor",
          href: "/ai-tutor",
          description: "24/7 student-facing tutor with step-by-step NCERT explanations and doubt solver.",
        },
        {
          title: "Product Demo",
          href: "/demo",
          description: "Interactive preview of the student dashboard and personalized study flow.",
        },
      ],
    },
    {
      title: "LAM (AI Engine)",
      href: "/lam",
      description: "Our proprietary Learning Adaptation Model powered by Bayesian Knowledge Tracing.",
    },
    {
      title: "For Schools",
      href: "/schools",
      children: [
        {
          title: "School Software & Apps",
          href: "/schools",
          description: "Dual Android apps (Student & Teacher/Admin) and institutional web portal.",
        },
        {
          title: "Request a School Demo",
          href: "/school-demo",
          description: "Schedule a guided consultation and institutional pilot for your school.",
          badge: "Institutions",
        },
        {
          title: "For Teachers",
          href: "/teachers",
          description: "Class rosters, homework assignment, real-time struggle alerts, and co-pilot tools.",
        },
        {
          title: "For Parents",
          href: "/parents",
          description: "Transparent visibility into learning progress, consistency, and topic mastery.",
        },
        {
          title: "For Students",
          href: "/students",
          description: "Self-paced NCERT learning, gamified streak badges, and instant doubt resolution.",
        },
      ],
    },
    {
      title: "Products & Services",
      href: "/products",
      children: [
        {
          title: "Products Catalogue",
          href: "/products",
          description: "Explore the Qrie AI Tutor, LAM Engine, School Software, and Assessment Engine.",
        },
        {
          title: "Services & Implementation",
          href: "/services",
          description: "School onboarding, curriculum mapping, teacher workshops, and enterprise SLA.",
        },
        {
          title: "Pricing & Plans",
          href: "/pricing",
          description: "Transparent subscription tiers, per-student licensing, and plan comparisons.",
        },
        {
          title: "Get a Custom Quote",
          href: "/get-a-quote",
          description: "Institutional proposals with customized rollout schedules and volume discounts.",
          badge: "Popular",
        },
      ],
    },
    {
      title: "Resources",
      href: "/resources",
      children: [
        {
          title: "Articles & Knowledge Hub",
          href: "/resources",
          description: "Insights on learning science, Bayesian knowledge tracing, and educational AI.",
        },
        {
          title: "Frequently Asked Questions",
          href: "/faq",
          description: "Detailed answers regarding security, CBSE/NCERT curriculum, and deployment.",
        },
        {
          title: "About Qrie AI",
          href: "/about",
          description: "Our mission to bridge educational learning gaps across Indian classrooms.",
        },
      ],
    },
    {
      title: "Contact",
      href: "/contact",
    },
  ],
};
