import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  HeartHandshake,
  ShieldCheck,
  Activity,
  CheckCircle2,
  Clock,
  Lock,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie for Parents — Transparent Learning Visibility & Progress Tracking",
  description:
    "Understand what your child truly understands before report cards arrive. Transparent topic-level mastery indicators and strict student data privacy.",
  alternates: {
    canonical: "https://qrie.ai/parents",
  },
};

export default function ParentsPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Parents", href: "/parents" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="success" size="md">
            <HeartHandshake className="w-3.5 h-3.5 text-emerald-600" />
            <span>Parental Peace of Mind</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Know What Your Child Understands, Long Before Exams
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            Traditional report cards show test scores weeks after difficulties begin. Qrie surfaces genuine
            concept-level understanding early, so you can encourage and support your child when it counts.
          </p>
        </div>

        {/* Feature Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Activity className="w-8 h-8 text-sky-600" />
            <h3 className="text-xl font-bold text-slate-900">Honest Mastery Indicators</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Instead of relying only on homework completion, our Bayesian model shows which exact
              scientific and mathematical concepts your child has mastered independently.
            </p>
          </div>

          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <Clock className="w-8 h-8 text-indigo-600" />
            <h3 className="text-xl font-bold text-slate-900">Focused, Productive Screen Time</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              No endless video scrolling or distracting social feeds. Qrie emphasizes active problem-solving
              in 15–20 minute bite-sized sessions that fit alongside regular school homework.
            </p>
          </div>

          <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200/90 space-y-4">
            <ShieldCheck className="w-8 h-8 text-emerald-600" />
            <h3 className="text-xl font-bold text-slate-900">Strict Student Privacy</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Your child&apos;s data is strictly protected under India&apos;s DPDP Act 2023. We never sell personal
              information to advertisers or commercial tutoring aggregators.
            </p>
          </div>
        </div>

        {/* Closing Info */}
        <div className="p-8 rounded-3xl bg-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-bold">Have Questions About Your Child&apos;s Learning?</h3>
            <p className="text-xs text-slate-400">
              Check our comprehensive FAQ or contact our academic support desk.
            </p>
          </div>
          <Button href="/faq" variant="white" size="md">
            View Parent FAQs
          </Button>
        </div>
      </div>
    </div>
  );
}
