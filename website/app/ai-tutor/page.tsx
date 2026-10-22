import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Sparkles,
  MessageSquare,
  CheckCircle,
  HelpCircle,
  BrainCircuit,
  ArrowRight,
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "AI Tutor", href: "/ai-tutor" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <Sparkles className="w-3.5 h-3.5 text-sky-600" />
            <span>24/7 Educational Guidance</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            The Socratic AI Tutor That Teaches How to Think
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            Most chatbots immediately give away the final answer, depriving students of the critical struggle
            needed for deep learning. Qrie&apos;s AI Tutor guides learners through hints, analogies, and
            step-by-step conceptual scaffolding.
          </p>
        </div>

        {/* Interactive Chat Simulation */}
        <div className="max-w-3xl mx-auto bg-slate-50 rounded-3xl p-6 sm:p-8 border border-slate-200/90 shadow-sm space-y-5">
          <div className="flex items-center justify-between border-b border-slate-200/80 pb-4">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-xl bg-sky-600 text-white flex items-center justify-center font-bold text-xs shadow-xs">
                Q
              </div>
              <div>
                <div className="text-xs font-bold text-slate-900">Qrie AI Socratic Session</div>
                <div className="text-[10px] text-slate-500">NCERT Class 10 • Chemical Reactions</div>
              </div>
            </div>
            <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
              Assistance Level 2 (Nudge)
            </span>
          </div>

          <div className="space-y-4 text-xs sm:text-sm">
            {/* Student Message */}
            <div className="flex justify-end">
              <div className="bg-sky-600 text-white p-3.5 rounded-2xl rounded-tr-none max-w-md shadow-xs">
                &quot;I don&apos;t get why iron rusting is considered a redox reaction. Isn&apos;t it just getting dirty?&quot;
              </div>
            </div>

            {/* AI Tutor Response */}
            <div className="flex justify-start">
              <div className="bg-white border border-slate-200 p-4 rounded-2xl rounded-tl-none max-w-lg space-y-2 text-slate-800 shadow-2xs leading-relaxed">
                <p>
                  Good question! Let&apos;s break it down scientifically. Think about what rust is chemically:
                  it is hydrated iron(III) oxide (Fe₂O₃·xH₂O).
                </p>
                <p className="font-medium text-sky-800">
                  What happens to the electrons of neutral iron atoms (Fe) when they bond with oxygen from the air?
                  Are electrons lost or gained?
                </p>
                <div className="pt-2 flex flex-wrap gap-2">
                  <span className="px-2.5 py-1 rounded-lg bg-slate-100 text-slate-700 text-xs font-medium border border-slate-200">
                    Option A: Iron loses electrons (Oxidation)
                  </span>
                  <span className="px-2.5 py-1 rounded-lg bg-slate-100 text-slate-700 text-xs font-medium border border-slate-200">
                    Option B: Iron gains electrons (Reduction)
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Feature Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-6 rounded-2xl border border-slate-200/90 bg-white space-y-3">
            <Languages className="w-6 h-6 text-indigo-600" />
            <h3 className="font-bold text-base text-slate-900">Bilingual & Hinglish Support</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Understands queries in formal English, Hindi, and natural Hinglish idioms commonly spoken
              by Indian school students, removing language barriers to STEM comprehension.
            </p>
          </div>

          <div className="p-6 rounded-2xl border border-slate-200/90 bg-white space-y-3">
            <BrainCircuit className="w-6 h-6 text-sky-600" />
            <h3 className="font-bold text-base text-slate-900">Connected to LAM Mastery</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Every doubt asked and concept clarified feeds directly into the student&apos;s Bayesian
              knowledge profile, updating mastery scores and preventing future misconception recurrence.
            </p>
          </div>

          <div className="p-6 rounded-2xl border border-slate-200/90 bg-white space-y-3">
            <ShieldCheck className="w-6 h-6 text-emerald-600" />
            <h3 className="font-bold text-base text-slate-900">Curriculum Guardrails</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Trained strictly on approved NCERT syllabus bounds. The tutor declines off-topic prompts
              and preserves academic focus during study sessions.
            </p>
          </div>
        </div>

        {/* CTA */}
        <div className="p-8 rounded-3xl bg-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-bold">Experience the Student App with AI Tutor</h3>
            <p className="text-xs text-slate-400">
              Download the Android APK or try our interactive web demo today.
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Button href="/demo" variant="white" size="md">
              Try Interactive Demo
            </Button>
            <Button href="/products/qrie-student-app" variant="outline" size="md" className="border-slate-700 text-white bg-slate-800 hover:bg-slate-700">
              Student App Details
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
