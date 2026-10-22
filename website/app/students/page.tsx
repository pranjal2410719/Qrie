import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { LavenderFeatureBand } from "@/components/ui/LavenderFeatureBand";
import {
  GraduationCap,
  Sparkles,
  Smartphone,
  Flame,
  Award,
  CheckCircle2,
  Clock,
  ArrowRight,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie for Students — Study at Your Own Pace with AI Support",
  description:
    "Learn NCERT Science, Math, and English without stress. 24/7 Socratic AI tutor, offline downloads, daily study streaks, and exam-ready revision.",
  alternates: {
    canonical: "https://qrie.ai/students",
  },
};

export default function StudentsPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Students", href: "/students" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <GraduationCap className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Built for School Students</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Learn Without Fear. Master Every Concept.
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Whether you are solving challenging physics numericals late at night or revising biology diagrams
            before class, Qrie is your 24/7 study companion that never judges your questions.
          </p>
          <div className="flex flex-wrap gap-4 pt-2">
            <Button href="/demo" variant="primary" size="md">
              Try Interactive Student Demo
            </Button>
            <Button href="/products/qrie-student-app" variant="outline" size="md">
              Download Student Android App
            </Button>
          </div>
        </div>

        {/* Student Feature Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Sparkles className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              24/7 Socratic AI Tutor
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Stuck on homework? Ask anything. Qrie doesn&apos;t just spit out answers—it guides you
              step-by-step through the logic.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Smartphone className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Offline-First Capability
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Download entire chapters and study offline. Your quizzes and practice sync automatically
              when internet reconnects.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Flame className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Gamified Consistency
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Maintain study streaks, collect mastery badges, and gain confidence across every NCERT
              chapter ahead of exams.
            </p>
          </div>
        </div>

        {/* Feature Band */}
        <LavenderFeatureBand
          badge="Confidence Building"
          headline="Ask questions with zero embarrassment."
          body="Many students hesitate to raise their hands in crowded classrooms. Qrie provides a safe, patient environment where you can ask for explanations as many times as you need."
          ctaText="Explore the 24/7 AI Tutor"
          ctaHref="/ai-tutor"
        />
      </div>
    </div>
  );
}
