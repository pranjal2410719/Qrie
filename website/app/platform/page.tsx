import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";
import { LavenderFeatureBand } from "@/components/ui/LavenderFeatureBand";
import {
  Layers,
  Cpu,
  Smartphone,
  School,
  Database,
  ShieldCheck,
  ArrowRight,
  Sparkles,
  RotateCcw,
  BookOpen,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie Platform Ecosystem — End-to-End Educational Intelligence",
  description:
    "Explore how Qrie's mobile apps, teacher web portals, Fastify backend, and autonomous LAM cognitive engine work together to deliver personalized school education.",
  alternates: {
    canonical: "https://qrie.ai/platform",
  },
};

export default function PlatformPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Platform Overview", href: "/platform" }]} />

        {/* Editorial Opener */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <Layers className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Architecture & System Design</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            The Qrie Platform Ecosystem
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            A decoupled, school-ready educational platform combining edge-optimized Android mobile apps,
            multi-tenant teacher web portals, and an autonomous Bayesian cognitive engine.
          </p>
        </div>

        {/* Inverted Dark Section: High-Level Topology */}
        <div className="p-8 sm:p-10 rounded-[20px] bg-[#101214] text-white border border-[#292a2e] space-y-8">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-[#292a2e] pb-6">
            <div>
              <h2 className="text-xl font-medium tracking-[0.012em] text-white">
                High-Level System Topology
              </h2>
              <p className="text-[13px] text-[#b7b9be] mt-1 font-normal">
                Decoupled application operations from autonomous adaptive learning intelligence.
              </p>
            </div>
            <span className="text-[11px] font-mono bg-[#1c2b42] text-[#fca700] px-3 py-1 rounded-full">
              VPC Isolation • Zero Direct Client Access
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Box 1: Clients */}
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="flex items-center gap-2 text-[#1868db] font-bold text-[12px] uppercase tracking-wide">
                <Smartphone className="w-4 h-4" />
                <span>Client Layer</span>
              </div>
              <ul className="space-y-2 text-[13px] text-[#f0f1f2] font-normal">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                  <span><strong>Student Android App:</strong> Flutter, SQLite outbox.</span>
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db]" />
                  <span><strong>Teacher Android App:</strong> Homework, class rosters.</span>
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#bf63f3]" />
                  <span><strong>Web Admin Portal:</strong> Next.js App Router (RSC).</span>
                </li>
              </ul>
            </div>

            {/* Box 2: Backend Orchestration */}
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="flex items-center gap-2 text-emerald-400 font-bold text-[12px] uppercase tracking-wide">
                <Database className="w-4 h-4" />
                <span>Backend Orchestration</span>
              </div>
              <ul className="space-y-2 text-[13px] text-[#f0f1f2] font-normal">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                  <span><strong>Fastify TypeScript Core:</strong> Schema validation.</span>
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db]" />
                  <span><strong>Supabase PostgreSQL:</strong> Row-Level Security (RLS).</span>
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#fca700]" />
                  <span><strong>Diagnostic Grader:</strong> Symbolic math equivalence.</span>
                </li>
              </ul>
            </div>

            {/* Box 3: LAM Autonomous Engine */}
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="flex items-center gap-2 text-[#bf63f3] font-bold text-[12px] uppercase tracking-wide">
                <Cpu className="w-4 h-4" />
                <span>LAM Cognitive Engine</span>
              </div>
              <ul className="space-y-2 text-[13px] text-[#f0f1f2] font-normal">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#bf63f3]" />
                  <span><strong>Python FastAPI / asyncpg:</strong> Numerical computing.</span>
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db]" />
                  <span><strong>BKT Probability Engine:</strong> Concept mastery.</span>
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#36b37e]" />
                  <span><strong>Spaced Retrieval:</strong> Ebbinghaus retention decay.</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Core Pillars Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <Sparkles className="w-6 h-6 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Step-by-Step AI Tutor
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Provides multi-step explanation escalation. Starts with conceptual nudges and guides students
              until they arrive at the solution independently.
            </p>
          </div>

          <div className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <RotateCcw className="w-6 h-6 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Spaced Retention Engine
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Continuously updates concept half-life. Automatically generates 2-question micro-retrieval
              practices right as memory retention starts to drop.
            </p>
          </div>

          <div className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
            <School className="w-6 h-6 text-[#1868db]" />
            <h3 className="text-xl font-medium tracking-[0.012em] text-[#101214]">
              Institutional Isolation
            </h3>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Full compliance with the India DPDP Act 2023. Row-level multi-tenant isolation ensures one
              school never accesses another&apos;s academic records.
            </p>
          </div>
        </div>

        {/* Lavender Band */}
        <LavenderFeatureBand
          badge="Deployment Flexibility"
          headline="Operate reliably in schools with intermittent internet."
          body="Student apps sync via an offline SQLite outbox pattern. Homework questions and diagnostic tests can be taken offline in rural or low-bandwidth zones and queued for instant synchronization."
          ctaText="Explore the Student App specs"
          ctaHref="/products/qrie-student-app"
        />

        {/* CTA */}
        <div className="text-center pt-4">
          <Button href="/school-demo" variant="primary" size="lg">
            Request a Platform Demonstration
          </Button>
        </div>
      </div>
    </div>
  );
}
