import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Brain,
  Activity,
  CheckCircle2,
  Clock,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Learning Adaptation Model (LAM) — Qrie's Core Educational Intelligence",
  description:
    "Explore Qrie's Learning Adaptation Model (LAM): an autonomous cognitive state engine powered by Bayesian Knowledge Tracing (BKT), 9-level assistance escalation, and spaced retrieval decay scheduling.",
  alternates: {
    canonical: "https://qrie.ai/lam",
  },
};

export default function LamPage() {
  const escalationLevels = [
    { level: "Level 1", title: "Socratic Inversion", desc: "Reflects the student's premise as a question to prompt active self-correction." },
    { level: "Level 2", title: "Targeted Concept Nudge", desc: "Reminds the learner of the relevant core formula or foundational law." },
    { level: "Level 3", title: "Symptom Pinpoint", desc: "Points directly to the algebraic or conceptual error without providing the fix." },
    { level: "Level 4", title: "Sub-Goal Decomposition", desc: "Breaks a complex multi-step question into two smaller digestible sub-tasks." },
    { level: "Level 5", title: "Worked Sub-Step Example", desc: "Demonstrates how to solve the immediate stumbling block with parallel values." },
    { level: "Level 6", title: "Syntax & Mathematical Scaffold", desc: "Provides the structured equation template, prompting the student to substitute values." },
    { level: "Level 7", title: "Step-by-Step Guided Walkthrough", desc: "Step-by-step interactive derivation requiring confirmation at each transition." },
    { level: "Level 8", title: "Full Worked Solution", desc: "Provides the comprehensive solution with explicit pedagogical commentary." },
    { level: "Level 9", title: "Prerequisite Remediation", desc: "Reroutes the learner to a foundational concept lesson before re-attempting." },
  ];

  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Learning Adaptation Model (LAM)", href: "/lam" }]} />

        {/* Hero */}
        <div className="max-w-4xl space-y-6">
          <Badge variant="primary" size="md">
            <Brain className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Core Learning Intelligence Engine</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Learning Adaptation Model (LAM)
          </h1>
          <p className="text-lg sm:text-xl text-[#42526e] leading-[1.5] font-normal">
            LAM is Qrie&apos;s proprietary cognitive state architecture. Rather than relying on generic,
            unbounded generative AI chatbots, LAM models student concept understanding through
            statistically grounded Bayesian Knowledge Tracing, 9-level assistance escalation, and
            decaying half-life spaced retrieval.
          </p>
          <div className="flex flex-wrap gap-4 pt-2">
            <Button href="/get-a-quote?product=qrie-lam-engine" variant="primary" size="md">
              Request LAM Engine Evaluation
            </Button>
            <Button href="/how-it-works" variant="outline" size="md">
              View the 8-Step Learning Cycle
            </Button>
          </div>
        </div>

        {/* 1. Mathematics of BKT (Inverted Dark Section) */}
        <div className="p-8 sm:p-10 rounded-[20px] bg-[#101214] text-white border border-[#292a2e] space-y-8">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-[#292a2e] pb-6">
            <div>
              <h2 className="text-2xl font-medium tracking-[0.012em] text-white">
                The Mathematics of Bayesian Knowledge Tracing
              </h2>
              <p className="text-[13px] text-[#b7b9be] mt-1 font-normal">
                How LAM infers student mastery probability without guessing or naive percentages.
              </p>
            </div>
            <span className="text-[11px] font-mono bg-[#1c2b42] text-[#fca700] px-3 py-1 rounded-full">
              Corbett & Anderson BKT Formulation
            </span>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
            <div className="space-y-4 text-[14px] text-[#f0f1f2] leading-[1.6] font-normal">
              <p>
                In standard online education platforms, scoring an 8/10 treats every question equally.
                Bayesian Knowledge Tracing (BKT) recognizes that correct answers can arise from lucky
                guesses, and incorrect answers can result from careless arithmetic slips despite complete
                mastery.
              </p>
              <p>
                LAM models each atomic NCERT concept node with four fundamental parameters:
              </p>
              <ul className="space-y-2 pl-2">
                <li>
                  <strong className="text-[#1868db] font-mono">L₀ (Initial Knowledge):</strong> The baseline probability that a student knows the concept prior to first practice.
                </li>
                <li>
                  <strong className="text-emerald-400 font-mono">T (Transition / Learn Rate):</strong> The probability that a student transitions from unmastered to mastered state during a learning step.
                </li>
                <li>
                  <strong className="text-[#fca700] font-mono">G (Guess Parameter):</strong> The probability that a student who has not mastered the concept answers correctly by chance.
                </li>
                <li>
                  <strong className="text-rose-400 font-mono">S (Slip Parameter):</strong> The probability that a student who has mastered the concept makes an accidental error.
                </li>
              </ul>
            </div>

            {/* Code / Math Panel */}
            <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] font-mono text-xs text-[#f0f1f2] space-y-3">
              <div className="text-[#b7b9be] border-b border-[#292a2e] pb-2 flex justify-between font-sans">
                <span>BAYES_POSTERIOR_UPDATE.py</span>
                <span className="text-emerald-400 font-bold">FastAPI</span>
              </div>
              <p className="text-[#b7b9be]"># 1. Update belief given verified response</p>
              <p className="text-[#1868db]">
                if interaction.is_correct:
                <br />
                &nbsp;&nbsp;P_obs = (P_prior * (1 - S)) / ((P_prior * (1 - S)) + ((1 - P_prior) * G))
                <br />
                else:
                <br />
                &nbsp;&nbsp;P_obs = (P_prior * S) / ((P_prior * S) + ((1 - P_prior) * (1 - G)))
              </p>
              <p className="text-[#b7b9be]"># 2. Account for learning during the opportunity</p>
              <p className="text-emerald-300">
                P_mastery_next = P_obs + (1 - P_obs) * T
              </p>
              <p className="text-[#b7b9be]"># 3. Commit immutable event ledger entry</p>
              <p className="text-[#bf63f3]">
                await event_ledger.record(student_id, concept_id, P_mastery_next)
              </p>
            </div>
          </div>
        </div>

        {/* 2. Nine-Level Assistance Escalation Matrix */}
        <div className="space-y-6">
          <div className="max-w-3xl space-y-2">
            <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
              The 9-Level Assistance Escalation Matrix
            </h2>
            <p className="text-base text-[#42526e] leading-[1.5] font-normal">
              Why generic chatbots spoil problem-solving: when students request help in Qrie, the AI
              escalates assistance through controlled pedagogical tiers without revealing full answers.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {escalationLevels.map((lvl) => (
              <div
                key={lvl.level}
                className="p-5 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-1.5"
              >
                <div className="flex items-center justify-between text-xs font-bold text-[#1868db]">
                  <span>{lvl.level}</span>
                  <span className="text-[10px] text-[#42526e] uppercase tracking-wider">Tier</span>
                </div>
                <h3 className="font-medium text-base text-[#101214]">{lvl.title}</h3>
                <p className="text-[13px] text-[#42526e] leading-[1.5] font-normal">{lvl.desc}</p>
              </div>
            ))}
          </div>
        </div>

        {/* 3. Spaced Retention & Half-Life Decay */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center bg-[#f0f1f2]/60 p-8 sm:p-10 rounded-[20px] border border-[#f0f1f2]">
          <div className="space-y-4">
            <Badge variant="primary" size="md">
              <Clock className="w-3.5 h-3.5 text-[#1868db]" />
              <span>Retention Science</span>
            </Badge>
            <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
              Spaced Retrieval & Half-Life Forgetting
            </h2>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              Traditional school schedules teach a topic in August and don&apos;t reassess it until
              December midterms. LAM models the decaying half-life of each mastered concept:
            </p>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              <strong className="text-[#101214] font-semibold">R = e^(-t / S)</strong>, where R is
              retrievability, t is elapsed time, and S is memory stability. When retrievability dips below
              70%, LAM triggers an automated 2-question micro-check in the student app.
            </p>
          </div>

          <div className="bg-white p-6 rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-4">
            <h3 className="text-xs font-bold uppercase tracking-wider text-[#42526e]">
              Decay Intervention Simulation
            </h3>
            <div className="space-y-3 text-xs font-normal">
              <div>
                <div className="flex justify-between font-semibold mb-1">
                  <span>Day 1 (Initial Mastery)</span>
                  <span className="text-emerald-600 font-bold">95% Retrievability</span>
                </div>
                <div className="w-full bg-[#f0f1f2] h-2 rounded-full overflow-hidden">
                  <div className="bg-emerald-500 h-full w-[95%]" />
                </div>
              </div>

              <div>
                <div className="flex justify-between font-semibold mb-1">
                  <span>Day 7 (Without Revision)</span>
                  <span className="text-rose-600 font-bold">52% (Severe Loss)</span>
                </div>
                <div className="w-full bg-[#f0f1f2] h-2 rounded-full overflow-hidden">
                  <div className="bg-rose-500 h-full w-[52%]" />
                </div>
              </div>

              <div>
                <div className="flex justify-between font-semibold mb-1">
                  <span>Day 7 (With LAM Micro-Check)</span>
                  <span className="text-[#1868db] font-bold">92% Restored & Stabilized</span>
                </div>
                <div className="w-full bg-[#f0f1f2] h-2 rounded-full overflow-hidden">
                  <div className="bg-[#1868db] h-full w-[92%]" />
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* 4. Production Capabilities vs Roadmap */}
        <div className="space-y-6">
          <div className="max-w-3xl space-y-2">
            <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
              Production Capabilities vs Planned Roadmap
            </h2>
            <p className="text-base text-[#42526e] leading-[1.5] font-normal">
              We believe in complete transparency about what is live in schools today versus what is in research.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="p-6 rounded-[20px] bg-white border border-emerald-200 shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
              <div className="flex items-center gap-2 text-emerald-700 font-bold text-sm">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>Implemented Today (Production & Pilots)</span>
              </div>
              <ul className="space-y-2 text-[13px] text-[#42526e] font-normal leading-[1.5]">
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 mt-2 shrink-0" />
                  <span>Bayesian Knowledge Tracing (BKT) probability calculation in FastAPI service.</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 mt-2 shrink-0" />
                  <span>Immutable interaction event ledger with server-to-server HMAC authentication.</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 mt-2 shrink-0" />
                  <span>9-level assistance escalation matrix for AI tutor doubt sessions.</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 mt-2 shrink-0" />
                  <span>Decoupled SQLite mobile outbox sync for intermittent network connectivity.</span>
                </li>
              </ul>
            </div>

            <div className="p-6 rounded-[20px] bg-white border border-[#1868db] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-3">
              <div className="flex items-center gap-2 text-[#1868db] font-bold text-sm">
                <Activity className="w-4 h-4 text-[#1868db]" />
                <span>Roadmap & Active Research</span>
              </div>
              <ul className="space-y-2 text-[13px] text-[#42526e] font-normal leading-[1.5]">
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
                  <span>Cross-school shared parametric model fine-tuning with differential privacy.</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
                  <span>Real-time voice speech-to-speech Socratic dialogue in Hindi and regional dialects.</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
                  <span>Automated question blueprint generation directly from physical school test scans.</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
                  <span>Third-party LMS webhook integrations for Canvas and Moodle.</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        {/* CTA */}
        <div className="p-8 rounded-[20px] bg-[#101214] text-white flex flex-col sm:flex-row items-center justify-between gap-6 border border-[#292a2e]">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-medium tracking-[0.012em] text-white">
              Evaluate LAM for Your Institution
            </h3>
            <p className="text-[14px] text-[#b7b9be] font-normal">
              Speak with our research and engineering team to evaluate LAM integration for your school network.
            </p>
          </div>
          <Button href="/get-a-quote?product=qrie-lam-engine" variant="white" size="md">
            Request LAM Evaluation Quote
          </Button>
        </div>
      </div>
    </div>
  );
}
