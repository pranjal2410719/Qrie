"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Brain,
  GraduationCap,
  Terminal,
  ArrowRight,
  ShieldAlert,
  GitBranch,
  Activity,
  Layers,
} from "lucide-react";

export function LamExplainer() {
  const [activeTab, setActiveTab] = useState<"general" | "educators" | "engineers">("general");

  return (
    <section className="py-20 bg-slate-900 text-white relative overflow-hidden">
      {/* Background Gradient */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[1000px] h-[500px] bg-gradient-to-r from-sky-500/10 via-indigo-500/10 to-transparent blur-3xl pointer-events-none rounded-full" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
        <div className="flex flex-col lg:flex-row items-start lg:items-end justify-between gap-6 mb-12">
          <div className="max-w-2xl space-y-3">
            <Badge variant="accent" size="md" className="bg-sky-950 text-sky-400 border-sky-800">
              <Brain className="w-3.5 h-3.5 text-sky-400" />
              <span>Core Technology</span>
            </Badge>
            <h2 className="text-3xl sm:text-4xl font-extrabold tracking-tight">
              The Learning Adaptation Model (LAM)
            </h2>
            <p className="text-slate-400 text-base leading-relaxed">
              Why Qrie is fundamentally different from a generic conversational chatbot: an autonomous
              cognitive state engine powered by Bayesian Knowledge Tracing.
            </p>
          </div>

          {/* Perspective Switcher */}
          <div className="flex items-center gap-1.5 p-1.5 rounded-xl bg-slate-800/80 border border-slate-700/80 text-xs font-semibold">
            <button
              onClick={() => setActiveTab("general")}
              className={`px-3 py-2 rounded-lg transition-all ${
                activeTab === "general"
                  ? "bg-sky-600 text-white shadow-xs"
                  : "text-slate-400 hover:text-white"
              }`}
            >
              For Parents & Students
            </button>
            <button
              onClick={() => setActiveTab("educators")}
              className={`px-3 py-2 rounded-lg transition-all ${
                activeTab === "educators"
                  ? "bg-sky-600 text-white shadow-xs"
                  : "text-slate-400 hover:text-white"
              }`}
            >
              For Educators
            </button>
            <button
              onClick={() => setActiveTab("engineers")}
              className={`px-3 py-2 rounded-lg transition-all ${
                activeTab === "engineers"
                  ? "bg-sky-600 text-white shadow-xs"
                  : "text-slate-400 hover:text-white"
              }`}
            >
              Technical / Algorithmic
            </button>
          </div>
        </div>

        {/* Tab 1: General Audience */}
        {activeTab === "general" && (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 animate-in fade-in duration-200">
            <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-3">
              <div className="w-10 h-10 rounded-xl bg-sky-950 border border-sky-800 flex items-center justify-center text-sky-400 font-bold">
                1
              </div>
              <h3 className="text-lg font-bold">No Two Learners Are Alike</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                When a student struggles with quadratic equations, the problem is rarely the entire
                chapter. Often, it is a single prerequisite concept—such as negative signs or factoring.
                LAM identifies the exact gap instead of making the student re-read 40 pages.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-3">
              <div className="w-10 h-10 rounded-xl bg-emerald-950 border border-emerald-800 flex items-center justify-center text-emerald-400 font-bold">
                2
              </div>
              <h3 className="text-lg font-bold">Assistance That Builds Grit</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Generic chatbots spoil learning by giving away answers immediately. Qrie&apos;s AI tutor
                uses Socratic questioning: nudging, asking targeted questions, and guiding students to
                discover the solution on their own.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-3">
              <div className="w-10 h-10 rounded-xl bg-purple-950 border border-purple-800 flex items-center justify-center text-purple-400 font-bold">
                3
              </div>
              <h3 className="text-lg font-bold">Revision Before Forgetting</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Students naturally forget topics within days. LAM schedules short, targeted 2-question
                micro-checks at scientifically calculated intervals, ensuring concepts remain solid
                heading into final school exams.
              </p>
            </div>
          </div>
        )}

        {/* Tab 2: Educators */}
        {activeTab === "educators" && (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 animate-in fade-in duration-200">
            <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-3">
              <div className="w-10 h-10 rounded-xl bg-sky-950 border border-sky-800 flex items-center justify-center text-sky-400">
                <Layers className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold">Granular Topic Mastery</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Move beyond coarse test scores. LAM computes individual mastery probabilities across
                each NCERT concept node, distinguishing between careless slips and systemic
                misunderstandings.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-3">
              <div className="w-10 h-10 rounded-xl bg-emerald-950 border border-emerald-800 flex items-center justify-center text-emerald-400">
                <ShieldAlert className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold">Early Struggle Detection</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Teachers receive proactive alerts before midterms: &quot;64% of Section 10-A is
                confusing exothermic reactions with activation energy.&quot; Turn 45-minute lectures into
                high-impact interventions.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-3">
              <div className="w-10 h-10 rounded-xl bg-purple-950 border border-purple-800 flex items-center justify-center text-purple-400">
                <GraduationCap className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-bold">Teacher in the Driver&apos;s Seat</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                AI does not make diagnostic educational decisions alone. LAM acts as an assistant:
                preparing homework, grading submissions, and surfacing patterns so teachers apply their
                pedagogical judgment.
              </p>
            </div>
          </div>
        )}

        {/* Tab 3: Technical Audiences */}
        {activeTab === "engineers" && (
          <div className="space-y-6 animate-in fade-in duration-200">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-4 font-mono text-xs">
                <div className="flex items-center justify-between text-slate-400 border-b border-slate-700 pb-2">
                  <span>BAYESIAN_KNOWLEDGE_TRACING.py</span>
                  <span className="text-emerald-400 font-sans font-bold">FastAPI / asyncpg</span>
                </div>
                <div className="text-slate-300 leading-relaxed">
                  <p className="text-sky-400"># BKT Posterior Probability of Mastery</p>
                  <p className="text-slate-200">
                    P_Ln_prior = learner_state.get_mastery(concept_id)
                  </p>
                  <p className="text-slate-200">
                    P_learn = BKT_PARAMS.transition_prob # T
                  </p>
                  <p className="text-slate-200">
                    P_guess = BKT_PARAMS.guess_prob      # G
                  </p>
                  <p className="text-slate-200">
                    P_slip  = BKT_PARAMS.slip_prob       # S
                  </p>
                  <br />
                  <p className="text-indigo-400"># Updating upon verified evidence event</p>
                  <p className="text-slate-200">
                    if event.is_correct:
                  </p>
                  <p className="text-slate-200 pl-4">
                    posterior = (P_Ln_prior * (1 - P_slip)) /
                    ((P_Ln_prior * (1 - P_slip)) + ((1 - P_Ln_prior) * P_guess))
                  </p>
                  <p className="text-slate-200">
                    P_Ln_next = posterior + (1 - posterior) * P_learn
                  </p>
                </div>
              </div>

              <div className="p-6 rounded-2xl bg-slate-800/60 border border-slate-700/80 space-y-4">
                <div className="flex items-center gap-2 text-sky-400 text-xs font-bold uppercase tracking-wider">
                  <Terminal className="w-4 h-4" />
                  <span>Architecture & Zero Direct Access</span>
                </div>
                <ul className="space-y-3 text-xs text-slate-300 leading-relaxed">
                  <li className="flex items-start gap-2">
                    <Activity className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
                    <span>
                      <strong>Autonomous Service:</strong> Runs in an isolated Python/FastAPI environment
                      with its own PostgreSQL event ledger, completely separated from web & mobile clients.
                    </span>
                  </li>
                  <li className="flex items-start gap-2">
                    <GitBranch className="w-4 h-4 text-indigo-400 shrink-0 mt-0.5" />
                    <span>
                      <strong>Immutable Event Ledger:</strong> Every question response, hint consumption, and
                      remedial review is stored as an immutable audit event for deterministic state replays.
                    </span>
                  </li>
                  <li className="flex items-start gap-2">
                    <Brain className="w-4 h-4 text-purple-400 shrink-0 mt-0.5" />
                    <span>
                      <strong>Server-to-Server HMAC:</strong> Mobile and web portals never hold LAM API keys;
                      all interactions flow through the Fastify backend orchestration layer.
                    </span>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        )}

        <div className="mt-12 text-center">
          <Button
            href="/lam"
            variant="primary"
            size="lg"
            icon={<ArrowRight className="w-4 h-4" />}
          >
            Read the Full LAM Technical Whitepaper
          </Button>
        </div>
      </div>
    </section>
  );
}
