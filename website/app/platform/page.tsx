import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Platform Overview", href: "/platform" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <Layers className="w-3.5 h-3.5 text-sky-600" />
            <span>Architecture & System Design</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            The Qrie Platform Ecosystem
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            A decoupled, school-ready educational platform combining edge-optimized Android mobile apps,
            multi-tenant teacher web portals, and an autonomous Bayesian cognitive engine.
          </p>
        </div>

        {/* System Flow Diagram */}
        <div className="p-8 sm:p-10 rounded-3xl bg-slate-950 text-white border border-slate-900 space-y-8">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-slate-800 pb-6">
            <div>
              <h2 className="text-xl font-bold text-white">High-Level System Topology</h2>
              <p className="text-xs text-slate-400 mt-1">
                Decoupled application operations from autonomous adaptive learning intelligence.
              </p>
            </div>
            <span className="text-xs font-mono bg-sky-950 text-sky-400 px-3 py-1 rounded-full border border-sky-800">
              VPC Isolation • Zero Direct Client Access
            </span>
          </div>

          {/* ASCII / Semantic Visual Flow */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Box 1: Clients */}
            <div className="p-6 rounded-2xl bg-slate-900 border border-slate-800 space-y-3">
              <div className="flex items-center gap-2 text-sky-400 font-bold text-xs uppercase tracking-wide">
                <Smartphone className="w-4 h-4" />
                <span>Client Layer</span>
              </div>
              <ul className="space-y-2 text-xs text-slate-300">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                  <strong>Student Android App:</strong> Flutter, SQLite outbox queue.
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-indigo-400" />
                  <strong>Teacher Android App:</strong> Homework, class rosters.
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-purple-400" />
                  <strong>Web Admin Portal:</strong> Next.js App Router (RSC).
                </li>
              </ul>
            </div>

            {/* Box 2: Backend Orchestration */}
            <div className="p-6 rounded-2xl bg-slate-900 border border-slate-800 space-y-3">
              <div className="flex items-center gap-2 text-emerald-400 font-bold text-xs uppercase tracking-wide">
                <Database className="w-4 h-4" />
                <span>Backend Orchestration</span>
              </div>
              <ul className="space-y-2 text-xs text-slate-300">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                  <strong>Fastify TypeScript Core:</strong> Schema validation & events.
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-sky-400" />
                  <strong>Supabase PostgreSQL:</strong> Row-Level Security (RLS) tenancy.
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-amber-400" />
                  <strong>Diagnostic Grader:</strong> Symbolic math equivalence.
                </li>
              </ul>
            </div>

            {/* Box 3: LAM Autonomous Engine */}
            <div className="p-6 rounded-2xl bg-slate-900 border border-slate-800 space-y-3">
              <div className="flex items-center gap-2 text-indigo-400 font-bold text-xs uppercase tracking-wide">
                <Cpu className="w-4 h-4" />
                <span>LAM Cognitive Engine</span>
              </div>
              <ul className="space-y-2 text-xs text-slate-300">
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-purple-400" />
                  <strong>Python FastAPI / asyncpg:</strong> High-precision numerical computing.
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-indigo-400" />
                  <strong>BKT Probability Engine:</strong> Concept mastery inference.
                </li>
                <li className="flex items-center gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-rose-400" />
                  <strong>Spaced Retrieval:</strong> Ebbinghaus half-life decay scheduler.
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* Core Pillars Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div className="p-8 rounded-3xl border border-slate-200/90 bg-white space-y-3">
            <Sparkles className="w-7 h-7 text-sky-600" />
            <h3 className="text-xl font-bold text-slate-900">Step-by-Step AI Tutor</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Provides multi-step explanation escalation. Starts with conceptual nudges and guides students
              through difficult NCERT chemistry, math, and physics questions without spoiling answers.
            </p>
          </div>

          <div className="p-8 rounded-3xl border border-slate-200/90 bg-white space-y-3">
            <RotateCcw className="w-7 h-7 text-emerald-600" />
            <h3 className="text-xl font-bold text-slate-900">Automated Spaced Revision</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Monitors the estimated memory half-life of learned topics and smoothly introduces 2-question
              micro-checks right before forgetting occurs.
            </p>
          </div>

          <div className="p-8 rounded-3xl border border-slate-200/90 bg-white space-y-3">
            <School className="w-7 h-7 text-indigo-600" />
            <h3 className="text-xl font-bold text-slate-900">School Roster & Homework Sync</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Teachers assign homework digitally. The platform grades symbolic multi-step answers and
              surfaces aggregate struggle heatmaps to classroom educators.
            </p>
          </div>
        </div>

        {/* CTA Banner */}
        <div className="p-8 rounded-3xl bg-sky-50 border border-sky-100 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-lg font-bold text-slate-900">Experience the Student Interface</h3>
            <p className="text-xs text-slate-600">
              Try our interactive demonstration showcasing courses, lessons, and progress tracking.
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Button href="/demo" variant="primary" size="md">
              Launch Product Demo
            </Button>
            <Button href="/how-it-works" variant="outline" size="md">
              How Qrie Works
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
