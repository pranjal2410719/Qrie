export interface ResourceArticle {
  slug: string;
  title: string;
  excerpt: string;
  category: "learning-science" | "ai-education" | "teacher-guide" | "study-strategy";
  readTime: string;
  publishedAt: string;
  author: {
    name: string;
    role: string;
  };
  content: string[];
  tags: string[];
}

export const resourcesData: ResourceArticle[] = [
  {
    slug: "understanding-bayesian-knowledge-tracing-in-lam",
    title: "Understanding Bayesian Knowledge Tracing: The Core Math of Qrie's LAM",
    excerpt:
      "A deep dive into how Qrie calculates probability of concept mastery without relying on naive percentage scores or opaque neural net predictions.",
    category: "learning-science",
    readTime: "7 min read",
    publishedAt: "2026-09-15",
    author: {
      name: "Pranjal Sharma",
      role: "Lead Architect, Qrie AI",
    },
    tags: ["LAM", "BKT", "Cognitive Modeling", "Algorithms"],
    content: [
      "In modern education technology, most platforms rely on simple percentage scores: if a student answers 8 out of 10 questions correctly, they receive an 80%. But learning science tells us that an 80% tells almost nothing about what the student actually understands.",
      "Did the student guess the difficult question correctly? Did they understand the underlying principle, or did they simply make an arithmetic slip on a question they had already mastered? To answer these questions, Qrie utilizes the Learning Adaptation Model (LAM), anchored in Bayesian Knowledge Tracing (BKT).",
      "BKT models the latent cognitive state of a student across four fundamental parameters: L0 (prior knowledge before practicing), T (the probability of learning the skill during a learning opportunity), G (the guess parameter, representing the likelihood of answering correctly without mastery), and S (the slip parameter, representing the likelihood of making an error despite possessing mastery).",
      "Whenever a student submits an answer in the Qrie Student App, the event is recorded immutably into our PostgreSQL state ledger. LAM computes the posterior probability of mastery using Bayes' theorem: P(Ln | Correct) = (P(Ln-1) * (1 - S)) / (P(Ln-1)*(1 - S) + (1 - P(Ln-1))*G).",
      "Because LAM calculates this at the atomic concept level rather than the coarse chapter level, teachers immediately see whether a class struggles with algebraic signs or the concept of distributive factoring. This precision is what transforms educational technology from a passive digital textbook into an active cognitive co-pilot.",
    ],
  },
  {
    slug: "why-passive-chatbots-fail-in-school-education",
    title: "Why Generic Chatbots Fail in K-12 Education: The Need for Pedagogy",
    excerpt:
      "Why conversational LLMs without assistance escalation often rob students of the critical struggle required for deep learning.",
    category: "ai-education",
    readTime: "6 min read",
    publishedAt: "2026-08-28",
    author: {
      name: "Dr. Ananya Roy",
      role: "Educational Pedagogy Advisor",
    },
    tags: ["AI in Education", "Pedagogy", "Socratic Method", "Tutor"],
    content: [
      "When generative AI first entered classrooms, the default approach was to connect a chat prompt to a commercial language model. While impressive in demonstrations, educators quickly discovered a severe flaw: chatbots frequently give away the answer immediately.",
      "Educational psychologists have long documented the concept of 'productive struggle'—the cognitive effort required to synthesize prior knowledge and formulate an answer. When an AI tutor provides an immediate solution, it short-circuits this learning process. The student experiences an illusion of competence: they read the solution, understand the steps, and believe they have learned it, only to fail when presented with an independent examination.",
      "In Qrie, the AI Tutor is governed by a Nine-Level Assistance Escalation Matrix. When a student asks for help, the tutor first prompts with a Socratic question or conceptual hint. Only when repeated independent attempts show persistent confusion does the assistance escalate to worked examples, step-by-step scaffolding, and finally full conceptual deconstruction.",
      "By placing cognitive guardrails between generative models and student interactions, Qrie ensures that the technology builds genuine problem-solving grit rather than dependency.",
    ],
  },
  {
    slug: "spaced-retrieval-ebbinghaus-forgetting-curve",
    title: "Combating the Forgetting Curve: How Spaced Retrieval Protects Retention",
    excerpt:
      "How Qrie's automated revision scheduling ensures topics learned in July are still retained during February final examinations.",
    category: "study-strategy",
    readTime: "5 min read",
    publishedAt: "2026-07-14",
    author: {
      name: "Vikramaditya Sen",
      role: "Cognitive Science Researcher",
    },
    tags: ["Spaced Repetition", "Revision", "NCERT", "Memory"],
    content: [
      "Hermann Ebbinghaus first demonstrated that humans forget over 50% of newly learned material within 48 hours unless active rehearsal occurs. In traditional school calendars, a topic taught in July is rarely reassessed until midterm exams in October, by which point students must re-learn everything from scratch.",
      "Qrie's Learning Adaptation Model (LAM) continuously evaluates the decaying half-life of each mastered concept. Rather than waiting for the student or teacher to remember to revise, LAM calculates an optimal review window.",
      "When a concept's estimated retrieval probability dips below 70%, the student app smoothly injects a quick two-question 'Daily Micro-Check' into the student's morning routine. If the student demonstrates retention, the decay curve flattens and the next review is scheduled weeks later.",
      "This systematic spaced retrieval ensures that students enter final examinations with durable, consolidated memory rather than cramming anxiety.",
    ],
  },
  {
    slug: "how-teachers-use-ai-struggle-heatmaps-for-targeted-teaching",
    title: "How Teachers Use AI Struggle Heatmaps for Targeted Classroom Teaching",
    excerpt:
      "Transforming 45-minute class periods from generic lecturing into high-impact, data-informed intervention sessions.",
    category: "teacher-guide",
    readTime: "8 min read",
    publishedAt: "2026-06-20",
    author: {
      name: "Siddharth Sen",
      role: "Head of Academic Partnerships",
    },
    tags: ["Teacher Tools", "Classroom Analytics", "DPS Case Study", "CBSE"],
    content: [
      "In a typical classroom of 40 students, a teacher faces a daunting challenge: five students are bored because they already understand the topic, twenty-five are following at standard pace, and ten are quietly falling behind. Traditional paper homework cannot surface these patterns until days after the lesson has concluded.",
      "With the Qrie Teacher Portal and Android Client, homework correction is automated through the Diagnostic Assessment Engine. Before walking into the classroom the next morning, the teacher opens the 'Class Mastery Heatmap.'",
      "The heatmap immediately surfaces actionable insights: '82% of Section 9-B successfully factored quadratic trinomials, but 64% failed when the constant term was negative.'",
      "Armed with this precise diagnostic, the teacher avoids repeating the entire 45-minute lecture. Instead, they spend the first 7 minutes directly addressing the negative constant misconception, then split the class into peer-learning pairs. Teachers report saving over 5 hours per week on grading while dramatically increasing student engagement.",
    ],
  },
];
