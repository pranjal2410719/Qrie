import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Students", href: "/students" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <GraduationCap className="w-3.5 h-3.5 text-sky-600" />
            <span>Built for School Students</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Learn Without Fear. Master Every Concept.
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
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
          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Sparkles className="w-8 h-8 text-sky-600" />
            <h3 className="text-xl font-bold text-slate-900">24/7 Socratic AI Tutor</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Ask doubts anytime in English, Hindi, or Hinglish. Instead of giving you direct answers,
              Qrie gives step-by-step hints so you learn how to solve the problem yourself.
            </p>
          </div>

          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Smartphone className="w-8 h-8 text-emerald-600" />
            <h3 className="text-xl font-bold text-slate-900">Offline-First Learning</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Internet down at home? No problem. Download chapters and practice quizzes while connected,
              study completely offline, and your progress syncs automatically when reconnected.
            </p>
          </div>

          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Flame className="w-8 h-8 text-amber-500" />
            <h3 className="text-xl font-bold text-slate-900">Streaks, XP & Gamification</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Stay motivated with daily streaks, level progression, and mastery pills. Track your real
              understanding rather than just cramming the night before an exam.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
