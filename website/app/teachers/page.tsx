import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { LavenderFeatureBand } from "@/components/ui/LavenderFeatureBand";
import {
  BookOpenCheck,
  Activity,
  CheckCircle2,
  Clock,
  Sparkles,
  School,
  ArrowRight,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie for Teachers — Pedagogical Co-Pilot & Classroom Struggle Heatmaps",
  description:
    "Save 5+ hours weekly on homework corrections. Get real-time class struggle heatmaps that surface student misconceptions before class begins.",
  alternates: {
    canonical: "https://qrie.ai/teachers",
  },
};

export default function TeachersPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Teachers", href: "/teachers" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <BookOpenCheck className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Teacher Co-Pilot</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Save Hours on Corrections. Target Real Classroom Gaps.
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Qrie is built to empower teachers, not replace them. Automated diagnostic grading and class
            struggle heatmaps free educators from repetitive paper corrections so they can focus on
            high-impact instructional interventions.
          </p>
          <div className="flex flex-wrap gap-4 pt-2">
            <Button href="/school-demo" variant="primary" size="md">
              Book Teacher Demonstration
            </Button>
            <Button href="/services/teacher-ai-enablement" variant="outline" size="md">
              Explore Teacher Workshops
            </Button>
          </div>
        </div>

        {/* Teacher Pillars Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Clock className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              5+ Hours Saved Weekly
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Homework is automatically assessed for mathematical equivalence and conceptual reasoning,
              relieving teachers of clerical routine.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Activity className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Live Struggle Heatmaps
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Enter class knowing exactly which concept confused your students during yesterday&apos;s
              assignments, turning lecture time into targeted clarification.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Sparkles className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Aligned to Term Exams
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Pre-populated with NCERT-aligned practice items mapped directly to CBSE syllabus
              schedules and quarterly term milestones.
            </p>
          </div>
        </div>

        {/* Feature Band */}
        <LavenderFeatureBand
          badge="Teacher Enablement"
          headline="Technology that respects pedagogical authority."
          body="Teachers retain complete control over syllabus pacing, homework deadlines, and classroom assignments. Qrie's co-pilot simply handles the diagnostic legwork."
          ctaText="Learn about teacher training workshops"
          ctaHref="/services/teacher-ai-enablement"
        />
      </div>
    </div>
  );
}
