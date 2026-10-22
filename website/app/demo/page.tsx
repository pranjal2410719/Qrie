"use client";

import React, { useState } from "react";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  BookOpen,
  CheckCircle2,
  Flame,
} from "lucide-react";

export default function DemoPage() {
  const [activeTab, setActiveTab] = useState<"dashboard" | "learn" | "quiz">("dashboard");
  const [selectedSubject, setSelectedSubject] = useState("Science");

  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Interactive Product Demo", href: "/demo" }]} />

        {/* Header */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>Live Interactive Preview</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Explore the Qrie Student Experience
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            This interactive demonstration simulates the student mobile client. Explore how subjects,
            micro-lessons, streaks, and the 24/7 Socratic AI tutor come together in daily study.
          </p>
        </div>

        {/* Demo Frame Shell (Inverted Dark Section) */}
        <div className="bg-[#101214] rounded-[20px] p-6 sm:p-10 border border-[#292a2e] space-y-6">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 border-b border-[#292a2e] pb-4">
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 rounded-full bg-rose-500" />
              <span className="w-2.5 h-2.5 rounded-full bg-amber-500" />
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-500" />
              <span className="text-[12px] text-[#b7b9be] font-mono ml-2 font-normal">
                demo.qrie.ai • Student Mode (Aarav Sharma - Class 10 CBSE)
              </span>
            </div>

            {/* View Switcher */}
            <div className="flex items-center gap-1 bg-[#292a2e] p-1 rounded-[28px] text-[13px] font-medium">
              <button
                onClick={() => setActiveTab("dashboard")}
                className={`px-3.5 py-1.5 rounded-[28px] transition-colors ${
                  activeTab === "dashboard"
                    ? "bg-[#1868db] text-white"
                    : "text-[#b7b9be] hover:text-white"
                }`}
              >
                Dashboard
              </button>
              <button
                onClick={() => setActiveTab("learn")}
                className={`px-3.5 py-1.5 rounded-[28px] transition-colors ${
                  activeTab === "learn"
                    ? "bg-[#1868db] text-white"
                    : "text-[#b7b9be] hover:text-white"
                }`}
              >
                NCERT Lessons
              </button>
              <button
                onClick={() => setActiveTab("quiz")}
                className={`px-3.5 py-1.5 rounded-[28px] transition-colors ${
                  activeTab === "quiz"
                    ? "bg-[#1868db] text-white"
                    : "text-[#b7b9be] hover:text-white"
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
                <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-3">
                  <div className="flex items-center justify-between text-[12px] text-[#b7b9be]">
                    <span>Daily Study Target</span>
                    <span className="text-emerald-400 font-bold">3 of 5 Done</span>
                  </div>
                  <div className="w-full bg-[#292a2e] h-2 rounded-full overflow-hidden">
                    <div className="bg-emerald-400 h-full w-[60%]" />
                  </div>
                  <div className="text-[13px] text-[#f0f1f2] font-normal">
                    Complete 2 more practice items to maintain your streak!
                  </div>
                </div>

                <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] flex items-center justify-between">
                  <div>
                    <div className="text-[12px] text-[#b7b9be]">Current Study Streak</div>
                    <div className="text-3xl font-medium tracking-[0.012em] text-[#fca700] flex items-center gap-2">
                      <span>6 Days</span>
                      <Flame className="w-6 h-6 text-[#fca700]" />
                    </div>
                  </div>
                  <div className="text-[12px] text-[#b7b9be] text-right font-normal">
                    Top 15% in Class 10
                  </div>
                </div>

                <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] flex items-center justify-between">
                  <div>
                    <div className="text-[12px] text-[#b7b9be]">Total XP Earned</div>
                    <div className="text-3xl font-medium tracking-[0.012em] text-[#1868db]">1,840 XP</div>
                  </div>
                  <span className="text-[11px] bg-[#1868db] text-white px-2.5 py-1 rounded-full font-bold">
                    Level 8 Scholar
                  </span>
                </div>
              </div>

              {/* Subject Selectors */}
              <div className="space-y-3">
                <div className="text-[12px] font-bold uppercase tracking-wider text-[#b7b9be]">
                  Select Curriculum Subject
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                  {["Science", "Mathematics", "English"].map((subj) => (
                    <div
                      key={subj}
                      onClick={() => setSelectedSubject(subj)}
                      className={`p-5 rounded-[20px] border cursor-pointer transition-colors ${
                        selectedSubject === subj
                          ? "bg-[#1868db] border-[#1868db] text-white"
                          : "bg-[#1c2b42]/30 border-[#292a2e] text-[#f0f1f2] hover:bg-[#1c2b42]/60"
                      }`}
                    >
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-medium text-base">{subj}</span>
                        <BookOpen className="w-4 h-4" />
                      </div>
                      <div className="text-[12px] opacity-80 font-normal">NCERT Class 10 CBSE</div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Up Next Card */}
              <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] flex flex-col sm:flex-row items-center justify-between gap-4">
                <div className="space-y-1 text-center sm:text-left">
                  <div className="text-[12px] text-[#fca700] font-medium">Recommended by LAM Engine</div>
                  <div className="text-lg font-medium text-white tracking-[0.012em]">
                    {selectedSubject}: Chapter 2 — Acids, Bases and Salts
                  </div>
                  <div className="text-[13px] text-[#b7b9be] font-normal">
                    Spaced retrieval scheduled: Practice 3 diagnostic questions to reinforce pH scale.
                  </div>
                </div>
                <Button
                  onClick={() => setActiveTab("quiz")}
                  variant="yellow"
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
              <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-[12px] text-[#1868db] font-bold uppercase">
                    Lesson 2.1 • pH Scale & Neutralization
                  </span>
                  <span className="text-[11px] bg-emerald-950 text-emerald-400 px-2 py-0.5 rounded border border-emerald-800">
                    Concept Active
                  </span>
                </div>
                <h3 className="text-xl font-medium tracking-[0.012em]">Understanding Universal Indicators and pH</h3>
                <p className="text-[14px] text-[#f0f1f2] leading-[1.6] font-normal">
                  The pH scale measures hydrogen ion concentration in solution: pH = -log₁₀[H⁺].
                  Solutions with pH &lt; 7 are acidic, while pH &gt; 7 indicates basicity.
                  When an acid reacts with a base, they neutralize each other, producing a salt and water.
                </p>
                <div className="p-4 rounded-[12px] bg-[#101214] border border-[#292a2e] font-mono text-xs text-emerald-300">
                  HCl(aq) + NaOH(aq) → NaCl(aq) + H₂O(l) + Heat
                </div>
              </div>
            </div>
          )}

          {/* Tab 3: Diagnostic Quiz View */}
          {activeTab === "quiz" && (
            <div className="space-y-6 text-white animate-in fade-in duration-150">
              <div className="p-6 rounded-[20px] bg-[#1c2b42]/40 border border-[#292a2e] space-y-4">
                <div className="flex items-center justify-between text-[12px] text-[#b7b9be]">
                  <span>Question 1 of 3 • Diagnostic Check</span>
                  <span className="text-[#1868db] font-bold">LAM Concept: chemical_neutralization_10</span>
                </div>
                <h3 className="text-base font-medium tracking-[0.012em]">
                  What is the resulting pH when equal concentrations of strong acid (HCl) and strong base (NaOH) are mixed?
                </h3>

                <div className="space-y-2 pt-2 text-[13px]">
                  <div className="p-3.5 rounded-[12px] bg-[#101214] border border-emerald-500/80 text-emerald-300 flex items-center justify-between">
                    <span>A: pH = 7 (Neutral solution with NaCl salt)</span>
                    <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                  </div>
                  <div className="p-3.5 rounded-[12px] bg-[#101214] border border-[#292a2e] text-[#b7b9be]">
                    B: pH &lt; 7 (Acidic)
                  </div>
                  <div className="p-3.5 rounded-[12px] bg-[#101214] border border-[#292a2e] text-[#b7b9be]">
                    C: pH &gt; 7 (Basic)
                  </div>
                </div>

                <div className="p-4 rounded-[12px] bg-emerald-950/60 border border-emerald-800/80 text-[13px] text-emerald-300 leading-relaxed font-normal">
                  <strong>LAM BKT Update:</strong> P(Mastery | Correct) updated from 0.62 → 0.84.
                  Concept marked as understood. Next review scheduled in 5 days.
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Closing Action */}
        <div className="p-8 rounded-[20px] bg-[#f0f1f2] border border-[#f0f1f2] flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-lg font-medium tracking-[0.012em] text-[#101214]">
              Want to test Qrie on your Android device?
            </h3>
            <p className="text-[14px] text-[#42526e] font-normal">
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
