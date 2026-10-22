"use client";

import React, { useState } from "react";
import { Button } from "@/components/ui/Button";
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
    <section className="py-20 bg-[#101214] text-white relative">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        {/* Section Header with perspective tabs */}
        <div className="flex flex-col lg:flex-row items-start lg:items-end justify-between gap-6 border-b border-[#292a2e] pb-8">
          <div className="max-w-2xl space-y-3">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[13px] font-medium bg-[#1c2b42] text-[#fca700]">
              <Brain className="w-3.5 h-3.5 text-[#fca700]" />
              <span>Core Technology Architecture</span>
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-[44px] font-medium tracking-[0.012em] text-white leading-tight">
              The Learning Adaptation Model (LAM)
            </h2>
            <p className="text-[#b7b9be] text-base leading-[1.5] font-normal">
              Why Qrie is fundamentally different from a conversational chatbot: an autonomous
              cognitive state engine powered by Bayesian Knowledge Tracing.
            </p>
          </div>

          {/* Perspective Switcher */}
          <div className="flex items-center gap-1 p-1 rounded-[28px] bg-[#292a2e] text-[13px] font-medium">
            <button
              onClick={() => setActiveTab("general")}
              className={`px-3.5 py-1.5 rounded-[28px] transition-colors ${
                activeTab === "general"
                  ? "bg-[#1868db] text-white"
                  : "text-[#b7b9be] hover:text-white"
              }`}
            >
              For Learners
            </button>
            <button
              onClick={() => setActiveTab("educators")}
              className={`px-3.5 py-1.5 rounded-[28px] transition-colors ${
                activeTab === "educators"
                  ? "bg-[#1868db] text-white"
                  : "text-[#b7b9be] hover:text-white"
              }`}
            >
              For Educators
            </button>
            <button
              onClick={() => setActiveTab("engineers")}
              className={`px-3.5 py-1.5 rounded-[28px] transition-colors ${
                activeTab === "engineers"
                  ? "bg-[#1868db] text-white"
                  : "text-[#b7b9be] hover:text-white"
              }`}
            >
              Technical Specs
            </button>
          </div>
        </div>

        {/* Tab 1: General Audience */}
        {activeTab === "general" && (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 animate-in fade-in duration-200">
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="w-9 h-9 rounded-full bg-[#1868db] flex items-center justify-center text-white text-[14px] font-bold">
                1
              </div>
              <h3 className="text-lg font-medium text-white">No Two Learners Are Alike</h3>
              <p className="text-[14px] text-[#b7b9be] leading-[1.5] font-normal">
                When a student struggles with quadratic equations, the problem is rarely the entire
                chapter. Often, it is a single prerequisite concept—such as negative signs or factoring.
                LAM isolates the exact concept node.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="w-9 h-9 rounded-full bg-[#1868db] flex items-center justify-center text-white text-[14px] font-bold">
                2
              </div>
              <h3 className="text-lg font-medium text-white">Assistance That Builds Grit</h3>
              <p className="text-[14px] text-[#b7b9be] leading-[1.5] font-normal">
                Generic chatbots spoil learning by giving away answers immediately. Qrie&apos;s AI tutor
                uses Socratic questioning: nudging, asking targeted sub-questions, and guiding students to
                discover the solution independently.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="w-9 h-9 rounded-full bg-[#1868db] flex items-center justify-center text-white text-[14px] font-bold">
                3
              </div>
              <h3 className="text-lg font-medium text-white">Revision Before Forgetting</h3>
              <p className="text-[14px] text-[#b7b9be] leading-[1.5] font-normal">
                Students naturally forget topics within days. LAM schedules short, targeted 2-question
                micro-checks at scientifically calculated intervals, ensuring concepts remain solid
                heading into final board examinations.
              </p>
            </div>
          </div>
        )}

        {/* Tab 2: Educators */}
        {activeTab === "educators" && (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 animate-in fade-in duration-200">
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="w-9 h-9 rounded-[8px] bg-[#1868db] flex items-center justify-center text-white">
                <Layers className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-medium text-white">Granular Concept Mastery</h3>
              <p className="text-[14px] text-[#b7b9be] leading-[1.5] font-normal">
                Move beyond coarse test scores. LAM computes individual mastery probabilities across
                each NCERT concept node, distinguishing between careless slips and systemic
                misunderstandings.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="w-9 h-9 rounded-[8px] bg-[#1868db] flex items-center justify-center text-white">
                <ShieldAlert className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-medium text-white">Early Struggle Alerts</h3>
              <p className="text-[14px] text-[#b7b9be] leading-[1.5] font-normal">
                Teachers receive proactive alerts before midterms: &quot;64% of Section 10-A is
                confusing exothermic reactions with activation energy.&quot; Turn 45-minute lectures into
                high-impact interventions.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
              <div className="w-9 h-9 rounded-[8px] bg-[#1868db] flex items-center justify-center text-white">
                <GraduationCap className="w-5 h-5" />
              </div>
              <h3 className="text-lg font-medium text-white">Teacher in the Driver&apos;s Seat</h3>
              <p className="text-[14px] text-[#b7b9be] leading-[1.5] font-normal">
                AI does not replace pedagogical authority. LAM acts as an assistant:
                preparing homework, grading submissions, and surfacing patterns so teachers apply their
                professional judgment.
              </p>
            </div>
          </div>
        )}

        {/* Tab 3: Technical Audiences */}
        {activeTab === "engineers" && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 animate-in fade-in duration-200">
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-4 font-mono text-xs">
              <div className="flex items-center justify-between text-[#b7b9be] border-b border-[#292a2e] pb-2 font-sans text-xs">
                <span>BAYESIAN_KNOWLEDGE_TRACING.py</span>
                <span className="text-emerald-400 font-bold">FastAPI / asyncpg</span>
              </div>
              <div className="text-slate-300 leading-relaxed">
                <p className="text-[#1868db]"># BKT Posterior Probability of Mastery</p>
                <p className="text-[#f0f1f2]">
                  P_Ln_prior = learner_state.get_mastery(concept_id)
                </p>
                <p className="text-[#f0f1f2]">
                  P_learn = BKT_PARAMS.transition_prob # T
                </p>
                <p className="text-[#f0f1f2]">
                  P_guess = BKT_PARAMS.guess_prob      # G
                </p>
                <p className="text-[#f0f1f2]">
                  P_slip  = BKT_PARAMS.slip_prob       # S
                </p>
                <br />
                <p className="text-indigo-400"># Updating upon verified evidence event</p>
                <p className="text-[#f0f1f2]">
                  if event.is_correct:
                </p>
                <p className="text-[#f0f1f2] pl-4">
                  posterior = (P_Ln_prior * (1 - P_slip)) /
                  ((P_Ln_prior * (1 - P_slip)) + ((1 - P_Ln_prior) * P_guess))
                </p>
                <p className="text-[#f0f1f2]">
                  P_Ln_next = posterior + (1 - posterior) * P_learn
                </p>
              </div>
            </div>

            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-4 text-[13px]">
              <div className="flex items-center gap-2 text-[#1868db] font-bold uppercase tracking-wider text-[12px]">
                <Terminal className="w-4 h-4" />
                <span>Zero Direct Client Access</span>
              </div>
              <ul className="space-y-3 text-[#b7b9be] leading-relaxed font-normal">
                <li className="flex items-start gap-2.5">
                  <Activity className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
                  <span>
                    <strong className="text-white">Autonomous Microservice:</strong> Runs in an isolated Python/FastAPI environment
                    with its own PostgreSQL event ledger, completely separated from web & mobile clients.
                  </span>
                </li>
                <li className="flex items-start gap-2.5">
                  <GitBranch className="w-4 h-4 text-indigo-400 shrink-0 mt-0.5" />
                  <span>
                    <strong className="text-white">Immutable Event Ledger:</strong> Every question response, hint consumption, and
                    remedial review is recorded as an immutable audit event for deterministic state replays.
                  </span>
                </li>
                <li className="flex items-start gap-2.5">
                  <Brain className="w-4 h-4 text-[#bf63f3] shrink-0 mt-0.5" />
                  <span>
                    <strong className="text-white">Server-to-Server HMAC:</strong> Mobile and web portals never hold LAM API keys;
                    all interactions flow through the Fastify backend orchestration layer.
                  </span>
                </li>
              </ul>
            </div>
          </div>
        )}

        <div className="pt-4 text-center">
          <Button
            href="/lam"
            variant="primary"
            size="lg"
            icon={<ArrowRight className="w-4 h-4" />}
          >
            Read the LAM Whitepaper
          </Button>
        </div>
      </div>
    </section>
  );
}
