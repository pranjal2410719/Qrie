import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { LavenderFeatureBand } from "@/components/ui/LavenderFeatureBand";
import {
  Sparkles,
  BrainCircuit,
  ShieldCheck,
  Languages,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie AI Tutor — 24/7 Socratic Learning & Doubt Resolution",
  description:
    "Meet Qrie AI Tutor: an educational assistant that guides students step-by-step through NCERT Science, Math, and English using Socratic questioning rather than giving away answers.",
  alternates: {
    canonical: "https://qrie.ai/ai-tutor",
  },
};

export default function AiTutorPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "AI Tutor", href: "/ai-tutor" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <Sparkles className="w-3.5 h-3.5 text-[#1868db]" />
            <span>24/7 Educational Guidance</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            The Socratic AI Tutor That Teaches How to Think
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Most chatbots immediately give away the final answer, depriving students of the critical struggle
            needed for deep learning. Qrie&apos;s AI Tutor guides learners through hints, analogies, and
            step-by-step conceptual scaffolding.
          </p>
        </div>

        {/* Interactive Chat Simulation */}
        <div className="max-w-3xl mx-auto bg-white rounded-[20px] p-6 sm:p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-5">
          <div className="flex items-center justify-between border-b border-[#f0f1f2] pb-4">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-[8px] bg-[#1868db] text-white flex items-center justify-center font-bold text-xs">
                Q
              </div>
              <div>
                <div className="text-[14px] font-medium text-[#101214]">Qrie Socratic Session</div>
                <div className="text-[12px] text-[#42526e]">NCERT Class 10 • Chemical Reactions</div>
              </div>
            </div>
            <span className="text-[11px] font-bold px-2.5 py-0.5 rounded-full bg-[#e3fcef] text-[#006644]">
              Assistance Level 2 (Nudge)
            </span>
          </div>

          <div className="space-y-4 text-[14px]">
            {/* Student Message */}
            <div className="flex justify-end">
              <div className="bg-[#1868db] text-white p-3.5 rounded-[16px] rounded-tr-none max-w-md font-normal leading-[1.5]">
                &quot;I don&apos;t get why iron rusting is considered a redox reaction. Isn&apos;t it just getting dirty?&quot;
              </div>
            </div>

            {/* AI Tutor Response */}
            <div className="flex justify-start">
              <div className="bg-[#f0f1f2] p-4 rounded-[16px] rounded-tl-none max-w-lg space-y-2 text-[#292a2e] leading-[1.5] font-normal">
                <p>
                  Good question! Let&apos;s break it down scientifically. Think about what rust is chemically:
                  it is hydrated iron(III) oxide (Fe₂O₃·xH₂O).
                </p>
                <p className="font-medium text-[#1868db]">
                  What happens to the electrons of neutral iron atoms (Fe) when they bond with oxygen from the air?
                  Are electrons lost or gained?
                </p>
                <div className="pt-2 flex flex-wrap gap-2">
                  <span className="px-3 py-1 rounded-[8px] bg-white text-[#292a2e] text-[12px] font-medium border border-[#f0f1f2]">
                    Option A: Iron loses electrons (Oxidation)
                  </span>
                  <span className="px-3 py-1 rounded-[8px] bg-white text-[#292a2e] text-[12px] font-medium border border-[#f0f1f2]">
                    Option B: Iron gains electrons (Reduction)
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Feature Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Languages className="w-6 h-6 text-[#1868db]" />
            <h3 className="font-medium text-lg text-[#101214] tracking-[0.012em]">Bilingual & Hinglish Support</h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Understands queries in formal English, Hindi, and natural Hinglish idioms commonly spoken
              by Indian school students, removing language barriers to STEM comprehension.
            </p>
          </div>

          <div className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <BrainCircuit className="w-6 h-6 text-[#1868db]" />
            <h3 className="font-medium text-lg text-[#101214] tracking-[0.012em]">Connected to LAM Mastery</h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Every doubt asked and concept clarified feeds directly into the student&apos;s Bayesian
              knowledge profile, updating mastery scores and preventing future misconception recurrence.
            </p>
          </div>

          <div className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <ShieldCheck className="w-6 h-6 text-[#1868db]" />
            <h3 className="font-medium text-lg text-[#101214] tracking-[0.012em]">Curriculum Guardrails</h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Trained strictly on approved NCERT syllabus bounds. The tutor declines off-topic prompts
              and preserves academic focus during study sessions.
            </p>
          </div>
        </div>

        {/* Feature Band */}
        <LavenderFeatureBand
          badge="Socratic Pedagogy"
          headline="Guidance that strengthens conceptual thinking."
          body="Instead of providing shortcuts that students copy without understanding, Qrie asks purposeful questions that build durable problem-solving capability."
          ctaText="Try the interactive Socratic demo"
          ctaHref="/demo"
        />

        {/* CTA */}
        <div className="p-8 rounded-[20px] bg-[#101214] text-white flex flex-col sm:flex-row items-center justify-between gap-6 border border-[#292a2e]">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-medium tracking-[0.012em]">Experience the Student App with AI Tutor</h3>
            <p className="text-[14px] text-[#b7b9be] font-normal">
              Download the Android APK or try our interactive web demo today.
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Button href="/demo" variant="white" size="md">
              Try Interactive Demo
            </Button>
            <Button href="/products/qrie-student-app" variant="outline" size="md" className="border-[#b7b9be] text-white hover:bg-white/10">
              Student App Details
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
