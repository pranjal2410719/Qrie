import React from "react";
import {
  ClipboardCheck,
  Search,
  BookOpen,
  HelpCircle,
  Cpu,
  Compass,
  RotateCcw,
  Award,
} from "lucide-react";

export function AdaptiveCycleDiagram() {
  const steps = [
    {
      step: "01",
      icon: <ClipboardCheck className="w-5 h-5 text-sky-600" />,
      title: "Assess",
      desc: "Student attempts an initial diagnostic check to establish current topic baseline.",
    },
    {
      step: "02",
      icon: <Search className="w-5 h-5 text-indigo-600" />,
      title: "Identify Gaps",
      desc: "LAM diagnoses atomic concept deficits rather than coarse chapter percentages.",
    },
    {
      step: "03",
      icon: <BookOpen className="w-5 h-5 text-emerald-600" />,
      title: "Teach",
      desc: "Delivers targeted bite-sized explanations with multi-step assistance escalation.",
    },
    {
      step: "04",
      icon: <HelpCircle className="w-5 h-5 text-amber-600" />,
      title: "Test",
      desc: "Independent multi-step questions with symbolic math validation, not simple multiple choice.",
    },
    {
      step: "05",
      icon: <Cpu className="w-5 h-5 text-purple-600" />,
      title: "Update Model",
      desc: "Bayesian Knowledge Tracing calculates posterior probability of mastery P(Ln | Evidence).",
    },
    {
      step: "06",
      icon: <Compass className="w-5 h-5 text-cyan-600" />,
      title: "Next Activity",
      desc: "LAM algorithmically selects whether to advance, reinforce, or solve an easier sub-step.",
    },
    {
      step: "07",
      icon: <RotateCcw className="w-5 h-5 text-rose-600" />,
      title: "Revisit",
      desc: "Spaced retrieval scheduler activates before memory falls below the 70% retention threshold.",
    },
    {
      step: "08",
      icon: <Award className="w-5 h-5 text-amber-500" />,
      title: "Mastery",
      desc: "Durable conceptual understanding achieved for school exams and board certifications.",
    },
  ];

  return (
    <section className="py-20 bg-white border-y border-slate-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto space-y-4 mb-16">
          <span className="text-xs font-bold uppercase tracking-wider text-sky-600 bg-sky-50 px-3 py-1 rounded-full border border-sky-100">
            The Continuous Learning Cycle
          </span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            How LAM Powers Personalized Learning
          </h2>
          <p className="text-base text-slate-600 leading-relaxed">
            Unlike static video platforms or generic chatbot prompts, Qrie guides students through
            a scientifically validated closed-loop cycle of diagnostic learning.
          </p>
        </div>

        {/* 8-Step Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {steps.map((item, idx) => (
            <div
              key={item.title}
              className="relative p-6 rounded-2xl bg-slate-50/70 border border-slate-200/80 hover:bg-white hover:shadow-md hover:border-slate-300 transition-all duration-200 group"
            >
              <div className="flex items-center justify-between mb-4">
                <div className="w-10 h-10 rounded-xl bg-white border border-slate-200 flex items-center justify-center shadow-2xs group-hover:scale-105 transition-transform">
                  {item.icon}
                </div>
                <span className="text-xs font-black text-slate-300 group-hover:text-sky-600 transition-colors">
                  {item.step}
                </span>
              </div>
              <h3 className="text-base font-bold text-slate-900 mb-1.5">{item.title}</h3>
              <p className="text-xs text-slate-600 leading-relaxed">{item.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
