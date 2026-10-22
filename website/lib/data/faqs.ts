export interface FaqItem {
  id: string;
  category: "product" | "lam" | "schools" | "curriculum" | "privacy" | "pricing";
  question: string;
  answer: string;
}

export const faqsData: FaqItem[] = [
  {
    id: "faq-what-is-qrie",
    category: "product",
    question: "What is Qrie AI and who is it designed for?",
    answer:
      "Qrie AI is an adaptive, school-ready educational platform designed specifically for Indian school students (NCERT/CBSE Classes 6–12), their teachers, and school administrators. It combines an offline-capable student Android app with a 24/7 Socratic AI tutor, automated teacher assessment tools, and a proprietary cognitive engine called LAM (Learning Adaptation Model).",
  },
  {
    id: "faq-what-is-lam",
    category: "lam",
    question: "What is the Learning Adaptation Model (LAM) and how is it different from a chatbot?",
    answer:
      "LAM is not a generic conversational chatbot. It is a specialized, mathematical learning intelligence engine built on Bayesian Knowledge Tracing (BKT) and cognitive decay modeling. While a chatbot generates text based on language statistics, LAM maintains an immutable state ledger of a student's concept mastery, tracks assistance levels, diagnoses specific conceptual misconceptions, and schedules spaced retrieval before forgetting occurs.",
  },
  {
    id: "faq-curriculum-supported",
    category: "curriculum",
    question: "Which curriculums and subjects does Qrie currently support?",
    answer:
      "Qrie natively covers the official NCERT curriculum for Classes 6 through 12 across Science (Physics, Chemistry, Biology), Mathematics, and English. We also support customized curriculum mapping for State Educational Boards and ICSE institutions through our enterprise curriculum digitization service.",
  },
  {
    id: "faq-offline-connectivity",
    category: "product",
    question: "Can students use Qrie without continuous internet access?",
    answer:
      "Yes. The Qrie Student Android App is engineered with an offline-first SQLite outbox queue. Students can download chapters, read structured lesson content, and attempt practice quizzes completely offline. Once a mobile data or Wi-Fi connection is detected, their answers and learning evidence sync automatically in the background.",
  },
  {
    id: "faq-school-deployment",
    category: "schools",
    question: "How do schools onboard and deploy Qrie?",
    answer:
      "School onboarding typically takes 2 to 3 weeks. Our implementation team creates an isolated institutional tenant in our cloud cluster, imports student and teacher rosters from your school ERP or CSV spreadsheets, configures custom school branding (crests, colors, mottos), and conducts a dedicated 2-day teacher enablement workshop.",
  },
  {
    id: "faq-teacher-role",
    category: "schools",
    question: "Does Qrie replace classroom teachers?",
    answer:
      "No. Qrie is built as a pedagogical co-pilot that strengthens the teacher-student relationship. It eliminates repetitive administrative burdens—such as correcting homework, creating practice worksheets, and manual gradebook entry—while providing teachers with class struggle heatmaps so they know exactly which concepts require intervention.",
  },
  {
    id: "faq-student-privacy",
    category: "privacy",
    question: "How does Qrie protect student privacy and data security?",
    answer:
      "Qrie is designed in full compliance with India's Digital Personal Data Protection (DPDP) Act 2023. We utilize strict Row-Level Security (RLS) in PostgreSQL, ensuring that data from one school is completely inaccessible to another. Student data is never sold, shared with advertising networks, or used to train public third-party foundational models.",
  },
  {
    id: "faq-pricing-models",
    category: "pricing",
    question: "How is Qrie priced for students versus institutions?",
    answer:
      "Individual students can use our free starter tier or upgrade to Student Pro for ₹499/month (or ₹4,490/year). For schools and institutional partners, we provide per-student annual licensing (starting around ₹85/student/month in bulk) which includes teacher apps, administrative portals, and onboarding workshops.",
  },
  {
    id: "faq-demo-evaluation",
    category: "product",
    question: "Can school principals and teachers evaluate a live demo before committing?",
    answer:
      "Absolutely. You can experience our interactive web demo at /demo or request a live guided institutional demonstration and 30-day pilot program for your school through /school-demo.",
  },
];
