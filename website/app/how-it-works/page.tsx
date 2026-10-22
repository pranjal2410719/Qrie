import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  ClipboardCheck,
  Search,
  BookOpen,
  HelpCircle,
  Cpu,
  Compass,
  RotateCcw,
  Award,
  ArrowRight,
} from "lucide-react";

export const metadata: Metadata = {
  title: "How Qrie Works — The 8-Step Adaptive Learning Journey",
  description:
    "Discover the complete student learning flow in Qrie AI: from initial diagnostic check to targeted lessons, Bayesian concept mastery updates, and spaced retention.",
  alternates: {
    canonical: "https://qrie.ai/how-it-works",
  },
};

export default function HowItWorksPage() {
  const steps = [
    {
      num: "1",
      title: "Initial Diagnostic Check",
      subtitle: "Pinpointing the Baseline",
      desc: "When a student starts a new chapter in the Qrie Android App, they complete a short 3-question diagnostic. Rather than testing trivia, each question tests a specific foundational concept to evaluate prior understanding.",
      icon: <ClipboardCheck className="w-6 h-6 text-sky-600" />,
    },
    {
      num: "2",
      title: "Granular Learning Gap Identification",
      subtitle: "Moving Beyond Percentages",
      desc: "LAM diagnoses atomic concept deficits rather than coarse chapter scores. If an algebra student fails a question, the system determines whether the mistake was an arithmetic slip or a misconception regarding negative sign distribution.",
      icon: <Search className="w-6 h-6 text-indigo-600" />,
    },
    {
      num: "3",
      title: "Targeted Bite-Sized Lesson Delivery",
      subtitle: "Assistance Escalation in Action",
      desc: "The student receives a micro-lesson focused exclusively on their missing prerequisite concept. The AI tutor begins with Socratic hints, escalating through 9 assistance levels if independent attempts require deeper scaffolding.",
      icon: <BookOpen className="w-6 h-6 text-emerald-600" />,
    },
    {
      num: "4",
      title: "Independent Problem Solving",
      subtitle: "Active Cognitive Struggle",
      desc: "Students practice with multi-step questions featuring symbolic mathematics validation. The platform checks algebraic equivalence, fractions, and units, requiring students to demonstrate active synthesis.",
      icon: <HelpCircle className="w-6 h-6 text-amber-600" />,
    },
    {
      num: "5",
      title: "Bayesian Knowledge Update",
      subtitle: "P(Mastery | Evidence)",
      desc: "Every interaction is logged immutably into the PostgreSQL event ledger. LAM updates the posterior probability of concept mastery using Bayesian Knowledge Tracing parameters (prior L0, learn rate T, guess G, slip S).",
      icon: <Cpu className="w-6 h-6 text-purple-600" />,
    },
    {
      num: "6",
      title: "Next-Best Action Recommendation",
      subtitle: "Algorithmic Routing",
      desc: "Based on the updated mastery score, LAM chooses the optimal next step: advance to the next curriculum topic, attempt another practice problem with faded scaffolding, or flag the concept for teacher review.",
      icon: <Compass className="w-6 h-6 text-cyan-600" />,
    },
    {
      num: "7",
      title: "Spaced Retention Micro-Checks",
      subtitle: "Beating the Ebbinghaus Forgetting Curve",
      desc: "Concepts naturally decay over time. When LAM estimates that retrieval probability is dipping near 70%, the mobile app automatically injects a quick 2-minute review into the student's daily routine.",
      icon: <RotateCcw className="w-6 h-6 text-rose-600" />,
    },
    {
      num: "8",
      title: "Durable Mastery & School Sync",
      subtitle: "Exam-Ready Confidence",
      desc: "Classroom teachers view the aggregated class heatmap in their portal, celebrating student gains and directing instructional time to persistent class-wide stumbling blocks.",
      icon: <Award className="w-6 h-6 text-amber-500" />,
    },
  ];

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "How Qrie Works", href: "/how-it-works" }]} />

        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>The Student Experience</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            How Qrie Works: The Adaptive Learning Journey
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            A step-by-step breakdown of how Qrie turns passive digital textbooks into an active,
            personalized educational journey for school students.
          </p>
        </div>

        {/* Step-by-Step Vertical Flow */}
        <div className="space-y-6">
          {steps.map((s, index) => (
            <div
              key={s.num}
              className="p-8 rounded-3xl border border-slate-200/90 bg-slate-50/50 hover:bg-white hover:shadow-md hover:border-slate-300 transition-all duration-200 grid grid-cols-1 md:grid-cols-12 gap-6 items-center"
            >
              <div className="md:col-span-1 flex items-center justify-center">
                <span className="w-12 h-12 rounded-2xl bg-white border border-slate-200 shadow-2xs flex items-center justify-center text-lg font-black text-sky-600">
                  {s.num}
                </span>
              </div>
              <div className="md:col-span-8 space-y-1.5">
                <div className="text-xs font-bold text-sky-600 uppercase tracking-wide">
                  {s.subtitle}
                </div>
                <h3 className="text-xl font-bold text-slate-900">{s.title}</h3>
                <p className="text-xs text-slate-600 leading-relaxed">{s.desc}</p>
              </div>
              <div className="md:col-span-3 flex justify-start md:justify-end">
                <div className="w-14 h-14 rounded-2xl bg-white border border-slate-200 shadow-2xs flex items-center justify-center">
                  {s.icon}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Next Steps CTA */}
        <div className="p-8 rounded-3xl bg-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-bold">Deep Dive into the Science of LAM</h3>
            <p className="text-xs text-slate-400">
              Read the mathematical specification behind Bayesian Knowledge Tracing and cognitive state modeling.
            </p>
          </div>
          <Button href="/lam" variant="white" size="md" icon={<ArrowRight className="w-4 h-4" />}>
            Explore LAM Whitepaper
          </Button>
        </div>
      </div>
    </div>
  );
}
