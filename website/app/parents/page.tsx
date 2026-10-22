import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { LavenderFeatureBand } from "@/components/ui/LavenderFeatureBand";
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
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Parents", href: "/parents" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <HeartHandshake className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Parental Peace of Mind</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Know What Your Child Understands, Long Before Exams
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Traditional report cards show test scores weeks after difficulties begin. Qrie surfaces genuine
            concept-level understanding early, so you can encourage and support your child when it counts.
          </p>
        </div>

        {/* Feature Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Activity className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Honest Mastery Indicators
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Instead of relying only on homework completion, our Bayesian model shows which exact
              scientific and mathematical concepts your child has mastered independently.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Clock className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Focused Screen Time
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              No endless video scrolling or distracting social feeds. Qrie emphasizes active problem-solving
              with focused 15–20 minute study sessions.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Lock className="w-7 h-7 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              DPDP Act 2023 Compliant
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Your child&apos;s data is never sold or used for ad targeting. We strictly follow the India Digital
              Personal Data Protection Act 2023 with parental consent safeguards.
            </p>
          </div>
        </div>

        {/* Feature Band */}
        <LavenderFeatureBand
          badge="Parent Partnership"
          headline="No surprises on report card day."
          body="With early alerts on topic-level struggles, parents can intervene with calm support weeks before school midterms and final board exams."
          ctaText="Explore the Qrie platform"
          ctaHref="/platform"
        />
      </div>
    </div>
  );
}
