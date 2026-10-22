import React from "react";
import type { Metadata } from "next";
import { HeroSection } from "@/components/sections/HeroSection";
import { AdaptiveCycleDiagram } from "@/components/sections/AdaptiveCycleDiagram";
import { LamExplainer } from "@/components/sections/LamExplainer";
import { SchoolAppsShowcase } from "@/components/sections/SchoolAppsShowcase";
import { FeatureGrid } from "@/components/sections/FeatureGrid";
import { TestimonialSection } from "@/components/sections/TestimonialSection";
import { FaqAccordion } from "@/components/sections/FaqAccordion";
import { CtaBanner } from "@/components/sections/CtaBanner";
import { ShieldCheck, BookOpen, Smartphone, Activity } from "lucide-react";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Qrie AI — Adaptive Learning Platform for K-12 School Education",
  description:
    "Personalized NCERT education powered by the Learning Adaptation Model (LAM). Step-by-step AI tutoring, continuous Bayesian mastery tracking, and connected apps for students, teachers, and schools.",
  alternates: {
    canonical: "https://qrie.ai",
  },
};

export default function HomePage() {
  return (
    <div className="flex flex-col">
      {/* 1. Hero Section */}
      <HeroSection />

      {/* 2. Trust & Verified Standards Strip */}
      <section className="bg-slate-900 text-slate-300 py-6 border-y border-slate-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
            <div className="flex flex-col items-center justify-center gap-1">
              <span className="text-xl sm:text-2xl font-black text-white">NCERT</span>
              <span className="text-xs text-slate-400">Classes 6–12 Curriculum</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-1">
              <span className="text-xl sm:text-2xl font-black text-sky-400">BKT Math</span>
              <span className="text-xs text-slate-400">Bayesian Knowledge Tracing</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-1">
              <span className="text-xl sm:text-2xl font-black text-emerald-400">Offline-First</span>
              <span className="text-xs text-slate-400">Low-Bandwidth SQLite Queue</span>
            </div>
            <div className="flex flex-col items-center justify-center gap-1">
              <span className="text-xl sm:text-2xl font-black text-indigo-400">DPDP 2023</span>
              <span className="text-xs text-slate-400">Tenant-Isolated RLS Security</span>
            </div>
          </div>
        </div>
      </section>

      {/* 3. The Continuous Adaptive Learning Cycle */}
      <AdaptiveCycleDiagram />

      {/* 4. The Learning Adaptation Model (LAM) Showcase */}
      <LamExplainer />

      {/* 5. Connected School Applications & Ecosystem */}
      <SchoolAppsShowcase />

      {/* 6. Beneficiary Feature Grid (Students, Parents, Teachers, Leadership) */}
      <FeatureGrid />

      {/* 7. Verified Educator & Institutional Feedback */}
      <TestimonialSection />

      {/* 8. Frequently Asked Questions */}
      <section className="py-20 bg-white">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center space-y-3 mb-12">
            <span className="text-xs font-bold uppercase tracking-wider text-sky-600 bg-sky-50 px-3 py-1 rounded-full border border-sky-100">
              Clear & Transparent Answers
            </span>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
              Frequently Asked Questions
            </h2>
            <p className="text-sm text-slate-600">
              Everything you need to know about Qrie AI, the LAM engine, and school deployment.
            </p>
          </div>

          <FaqAccordion limit={5} showCategoryFilter={false} />
        </div>
      </section>

      {/* 9. Final Call to Action */}
      <CtaBanner />
    </div>
  );
}
