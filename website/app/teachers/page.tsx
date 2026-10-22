import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Teachers", href: "/teachers" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <BookOpenCheck className="w-3.5 h-3.5 text-sky-600" />
            <span>Teacher Co-Pilot</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Save Hours on Corrections. Target Real Classroom Gaps.
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
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
          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Clock className="w-8 h-8 text-sky-600" />
            <h3 className="text-xl font-bold text-slate-900">5+ Hours Saved Weekly</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Distribute digital NCERT assignments in two taps. Qrie evaluates symbolic math, fractions,
              and equations automatically, eliminating midnight grading marathons.
            </p>
          </div>

          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Activity className="w-8 h-8 text-emerald-600" />
            <h3 className="text-xl font-bold text-slate-900">Live Class Struggle Heatmaps</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Before walking into your period, open the portal to see aggregate comprehension: &quot;71% of
              Section 9-B is struggling with signs in quadratic factoring.&quot;
            </p>
          </div>

          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Sparkles className="w-8 h-8 text-indigo-600" />
            <h3 className="text-xl font-bold text-slate-900">Targeted Micro-Interventions</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Instead of repeating the entire lecture, spend the first 8 minutes addressing the precise
              misconception identified by LAM, then divide students into peer-study pairs.
            </p>
          </div>
        </div>

        {/* Closing Action */}
        <div className="p-8 rounded-3xl bg-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-bold">Introduce Qrie to Your School Principal</h3>
            <p className="text-xs text-slate-400">
              We provide official pilot proposals and free trial access for participating academic departments.
            </p>
          </div>
          <Button href="/school-demo" variant="white" size="md">
            Request School Pilot Pack
          </Button>
        </div>
      </div>
    </div>
  );
}
