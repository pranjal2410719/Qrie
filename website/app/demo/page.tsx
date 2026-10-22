"use client";

import React, { useState } from "react";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Sparkles,
  BookOpen,
  Calendar,
  CheckCircle2,
  Clock,
  Award,
  Smartphone,
  PlayCircle,
  HelpCircle,
  Flame,
} from "lucide-react";

export default function DemoPage() {
  const [activeTab, setActiveTab] = useState<"dashboard" | "learn" | "quiz">("dashboard");
  const [selectedSubject, setSelectedSubject] = useState("Science");

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Interactive Product Demo", href: "/demo" }]} />

        {/* Header */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="success" size="md">
            <span>Live Interactive Preview</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Explore the Qrie Student Experience
          </h1>
          <p className="text-base text-slate-600 leading-relaxed">
            This interactive demonstration simulates the student mobile client. Explore how subjects,
            micro-lessons, streaks, and the 24/7 Socratic AI tutor come together in daily study.
          </p>
        </div>

        {/* Demo Frame Shell */}
        <div className="bg-slate-900 rounded-3xl p-6 sm:p-10 border border-slate-800 shadow-xl space-y-6">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 border-b border-slate-800 pb-4">
            <div className="flex items-center gap-2">
              <span className="w-3 h-3 rounded-full bg-rose-500" />
              <span className="w-3 h-3 rounded-full bg-amber-500" />
              <span className="w-3 h-3 rounded-full bg-emerald-500" />
              <span className="text-xs text-slate-400 font-mono ml-2">
                demo.qrie.ai • Student Mode (Aarav Sharma - Class 10 CBSE)
              </span>
            </div>

            {/* View Switcher */}
            <div className="flex items-center gap-1 bg-slate-800 p-1 rounded-xl text-xs font-semibold">
              <button
                onClick={() => setActiveTab("dashboard")}
                className={`px-3 py-1.5 rounded-lg transition-all ${
                  activeTab === "dashboard"
                    ? "bg-sky-600 text-white"
                    : "text-slate-400 hover:text-white"
                }`}
              >
                Dashboard
              </button>
              <button
                onClick={() => setActiveTab("learn")}
                className={`px-3 py-1.5 rounded-lg transition-all ${
                  activeTab === "learn"
                    ? "bg-sky-600 text-white"
                    : "text-slate-400 hover:text-white"
                }`}
              >
                NCERT Lessons
              </button>
              <button
                onClick={() => setActiveTab("quiz")}
                className={`px-3 py-1.5 rounded-lg transition-all ${
                  activeTab === "quiz"
                    ? "bg-sky-600 text-white"
                    : "text-slate-400 hover:text-white"
                }`}
              >
                LAM Diagnostic Quiz
              </button>
            </div>
          </div>

          {/* Tab 1: Dashboard View */}
          {activeTab === "dashboard" && (
            <div className="space-y-6 text-white animate-in fade-in duration-150">
              {/* Daily Target Bento */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="p-6 rounded-2xl bg-slate-800/80 border border-slate-700/80 space-y-3">
                  <div className="flex items-center justify-between text-xs text-slate-400">
                    <span>Daily Study Target</span>
                    <span className="text-emerald-400 font-bold">3 of 5 Done</span>
                  </div>
                  <div className="w-full bg-slate-700 h-2 rounded-full overflow-hidden">
                    <div className="bg-emerald-400 h-full w-[60%]" />
                  </div>
                  <div className="text-xs text-slate-300">
                    Complete 2 more practice items to maintain your streak!
                  </div>
                </div>

                <div className="p-6 rounded-2xl bg-slate-800/80 border border-slate-700/80 flex items-center justify-between">
                  <div>
                    <div className="text-xs text-slate-400">Current Study Streak</div>
                    <div className="text-3xl font-black text-amber-400 flex items-center gap-2">
                      <span>6 Days</span>
                      <Flame className="w-6 h-6 text-amber-400" />
                    </div>
                  </div>
                  <div className="text-xs text-slate-400 text-right">
                    Top 15% in Class 10
                  </div>
                </div>

                <div className="p-6 rounded-2xl bg-slate-800/80 border border-slate-700/80 flex items-center justify-between">
                  <div>
                    <div className="text-xs text-slate-400">Total XP Earned</div>
                    <div className="text-3xl font-black text-sky-400">1,840 XP</div>
                  </div>
                  <span className="text-xs bg-sky-950 text-sky-400 px-2 py-1 rounded-lg border border-sky-800">
                    Level 8 Scholar
                  </span>
                </div>
              </div>

              {/* Subject Selectors */}
              <div className="space-y-3">
                <div className="text-xs font-bold uppercase tracking-wider text-slate-400">
                  Select Curriculum Subject
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                  {["Science", "Mathematics", "English"].map((subj) => (
                    <div
                      key={subj}
                      onClick={() => setSelectedSubject(subj)}
                      className={`p-5 rounded-2xl border cursor-pointer transition-all ${
                        selectedSubject === subj
                          ? "bg-sky-950/70 border-sky-500 text-white"
                          : "bg-slate-800/50 border-slate-700 text-slate-300 hover:bg-slate-800"
                      }`}
                    >
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-bold text-sm">{subj}</span>
                        <BookOpen className="w-4 h-4 text-sky-400" />
                      </div>
                      <div className="text-xs text-slate-400">NCERT Class 10 CBSE</div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Up Next Card */}
              <div className="p-6 rounded-2xl bg-sky-900/40 border border-sky-700/60 flex flex-col sm:flex-row items-center justify-between gap-4">
                <div className="space-y-1 text-center sm:text-left">
                  <div className="text-xs text-sky-300 font-semibold">Recommended by LAM Engine</div>
                  <div className="text-base font-bold text-white">
                    {selectedSubject}: Chapter 2 — Acids, Bases and Salts
                  </div>
                  <div className="text-xs text-slate-300">
                    Spaced retrieval scheduled: Practice 3 diagnostic questions to reinforce pH scale.
                  </div>
                </div>
                <Button
                  onClick={() => setActiveTab("quiz")}
                  variant="primary"
                  size="md"
                >
                  Start Diagnostic Check
                </Button>
              </div>
            </div>
          )}

          {/* Tab 2: Learn View */}
          {activeTab === "learn" && (
            <div className="space-y-6 text-white animate-in fade-in duration-150">
              <div className="p-6 rounded-2xl bg-slate-800/80 border border-slate-700 space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-xs text-sky-400 font-bold uppercase">
                    Lesson 2.1 • pH Scale & Neutralization
                  </span>
                  <span className="text-xs bg-emerald-950 text-emerald-400 px-2 py-0.5 rounded border border-emerald-800">
                    Concept Active
                  </span>
                </div>
                <h3 className="text-xl font-bold">Understanding Universal Indicators and pH</h3>
                <p className="text-xs text-slate-300 leading-relaxed">
                  The pH scale measures hydrogen ion concentration in solution: pH = -log₁₀[H⁺].
                  Solutions with pH &lt; 7 are acidic, while pH &gt; 7 indicates basicity.
                  When an acid reacts with a base, they neutralize each other, producing a salt and water.
                </p>
                <div className="p-4 rounded-xl bg-slate-900 border border-slate-700 font-mono text-xs text-emerald-300">
                  HCl(aq) + NaOH(aq) → NaCl(aq) + H₂O(l) + Heat
                </div>
              </div>
            </div>
          )}

          {/* Tab 3: Diagnostic Quiz View */}
          {activeTab === "quiz" && (
            <div className="space-y-6 text-white animate-in fade-in duration-150">
              <div className="p-6 rounded-2xl bg-slate-800/80 border border-slate-700 space-y-4">
                <div className="flex items-center justify-between text-xs text-slate-400">
                  <span>Question 1 of 3 • Diagnostic Check</span>
                  <span className="text-sky-400 font-bold">LAM Concept: chemical_neutralization_10</span>
                </div>
                <h3 className="text-base font-bold">
                  What is the resulting pH when equal concentrations of strong acid (HCl) and strong base (NaOH) are mixed?
                </h3>

                <div className="space-y-2 pt-2 text-xs">
                  <div className="p-3 rounded-xl bg-slate-900 border border-emerald-500/80 text-emerald-300 flex items-center justify-between">
                    <span>A: pH = 7 (Neutral solution with NaCl salt)</span>
                    <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                  </div>
                  <div className="p-3 rounded-xl bg-slate-900 border border-slate-700 text-slate-400">
                    B: pH &lt; 7 (Acidic)
                  </div>
                  <div className="p-3 rounded-xl bg-slate-900 border border-slate-700 text-slate-400">
                    C: pH &gt; 7 (Basic)
                  </div>
                </div>

                <div className="p-4 rounded-xl bg-emerald-950/60 border border-emerald-800/80 text-xs text-emerald-300 leading-relaxed">
                  <strong>LAM BKT Update:</strong> P(Mastery | Correct) updated from 0.62 → 0.84.
                  Concept marked as understood. Next review scheduled in 5 days.
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Closing Action */}
        <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-lg font-bold text-slate-900">Want to test Qrie on your Android device?</h3>
            <p className="text-xs text-slate-600">
              Download the release APK or request an institutional trial for your school.
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Button href="/school-demo" variant="primary" size="md">
              Book School Demo
            </Button>
            <Button href="/products/qrie-student-app" variant="outline" size="md">
              Student App Info
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
