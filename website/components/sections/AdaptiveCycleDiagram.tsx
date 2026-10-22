import React from "react";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";
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
      icon: <ClipboardCheck className="w-5 h-5 text-[#1868db]" />,
      title: "Assess",
      desc: "Student attempts an initial diagnostic check to establish current topic baseline.",
    },
    {
      step: "02",
      icon: <Search className="w-5 h-5 text-[#1868db]" />,
      title: "Identify Gaps",
      desc: "LAM diagnoses atomic concept deficits rather than coarse chapter percentages.",
    },
    {
      step: "03",
      icon: <BookOpen className="w-5 h-5 text-[#1868db]" />,
      title: "Teach",
      desc: "Delivers targeted bite-sized explanations with multi-step assistance escalation.",
    },
    {
      step: "04",
      icon: <HelpCircle className="w-5 h-5 text-[#1868db]" />,
      title: "Test",
      desc: "Independent multi-step questions with symbolic math validation, not simple multiple choice.",
    },
    {
      step: "05",
      icon: <Cpu className="w-5 h-5 text-[#1868db]" />,
      title: "Update Model",
      desc: "Bayesian Knowledge Tracing calculates posterior probability of mastery P(Ln | Evidence).",
    },
    {
      step: "06",
      icon: <Compass className="w-5 h-5 text-[#1868db]" />,
      title: "Next Activity",
      desc: "LAM algorithmically selects whether to advance, reinforce, or solve an easier sub-step.",
    },
    {
      step: "07",
      icon: <RotateCcw className="w-5 h-5 text-[#1868db]" />,
      title: "Revisit",
      desc: "Spaced retrieval scheduler activates before memory falls below the 70% retention threshold.",
    },
    {
      step: "08",
      icon: <Award className="w-5 h-5 text-[#1868db]" />,
      title: "Mastery",
      desc: "Durable conceptual understanding achieved for school exams and board certifications.",
    },
  ];

  return (
    <section className="py-20 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <EditorialHeadline
          badge="Continuous Cycle"
          title="How LAM Powers Adaptive Learning"
          highlightWord="Adaptive Learning"
          description="Unlike static video libraries or generic chatbot prompts, Qrie guides learners through a scientifically validated closed-loop cycle of diagnostic instruction."
        />

        {/* 8-Step Grid with 20px card radius, 24px padding, subtle shadow */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {steps.map((item) => (
            <div
              key={item.title}
              className="bg-white rounded-[20px] p-6 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] hover:border-[#b7b9be] transition-colors group flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between mb-4">
                  <div className="w-10 h-10 rounded-[10px] bg-[#f0f1f2] flex items-center justify-center">
                    {item.icon}
                  </div>
                  <span className="text-[13px] font-bold text-[#b7b9be] group-hover:text-[#1868db] transition-colors">
                    {item.step}
                  </span>
                </div>
                <h3 className="text-[18px] font-medium text-[#101214] mb-2 leading-snug">
                  {item.title}
                </h3>
                <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
                  {item.desc}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
