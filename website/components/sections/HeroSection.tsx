import React from "react";
import Image from "next/image";
import Link from "next/link";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Sparkles,
  ArrowRight,
  School,
  CheckCircle2,
  ShieldCheck,
  BrainCircuit,
  Smartphone,
} from "lucide-react";

export function HeroSection() {
  return (
    <section className="relative overflow-hidden pt-12 pb-20 lg:pt-20 lg:pb-28 bg-gradient-to-b from-sky-50/50 via-white to-slate-50/60">
      {/* Background Decorative Rings */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[1200px] h-[550px] bg-gradient-to-tr from-sky-200/30 via-indigo-100/20 to-transparent blur-3xl pointer-events-none -z-10 rounded-full" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
          {/* Left Column: Messaging & CTAs */}
          <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
            <div className="inline-flex items-center gap-2">
              <Badge variant="primary" size="md">
                <BrainCircuit className="w-3.5 h-3.5 text-sky-600" />
                <span>Powered by Learning Adaptation Model (LAM)</span>
              </Badge>
            </div>

            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-slate-900 tracking-tight leading-[1.12]">
              Personalized Learning for School Students,{" "}
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-sky-600 via-indigo-600 to-sky-700">
                Driven by Educational Intelligence.
              </span>
            </h1>

            <p className="text-lg sm:text-xl text-slate-600 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-normal">
              Qrie AI bridges learning gaps across NCERT Classes 6–12. Our proprietary{" "}
              <strong className="font-semibold text-slate-900">Learning Adaptation Model</strong>{" "}
              combines continuous Bayesian mastery tracking, step-by-step Socratic AI tutoring, and
              connected apps for students, teachers, and school administrators.
            </p>

            {/* CTAs */}
            <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-3.5 pt-2">
              <Button
                href="/school-demo"
                variant="primary"
                size="lg"
                icon={<School className="w-5 h-5" />}
              >
                Request a School Demo
              </Button>
              <Button
                href="/platform"
                variant="outline"
                size="lg"
                icon={<ArrowRight className="w-4 h-4" />}
              >
                Explore the Platform
              </Button>
              <Button
                href="/lam"
                variant="ghost"
                size="lg"
                className="text-sky-700 hover:text-sky-800"
              >
                Explore LAM Engine
              </Button>
            </div>

            {/* Value Proof Badges */}
            <div className="pt-6 border-t border-slate-200/80 flex flex-wrap items-center justify-center lg:justify-start gap-y-3 gap-x-6 text-xs text-slate-500 font-medium">
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                <span>NCERT Classes 6–12 Aligned</span>
              </div>
              <div className="flex items-center gap-1.5">
                <Smartphone className="w-4 h-4 text-sky-500" />
                <span>Offline-First Android App</span>
              </div>
              <div className="flex items-center gap-1.5">
                <ShieldCheck className="w-4 h-4 text-indigo-500" />
                <span>DPDP 2023 Tenant Isolation</span>
              </div>
            </div>
          </div>

          {/* Right Column: Genuine Product Interface Preview */}
          <div className="lg:col-span-5 relative">
            <div className="relative mx-auto max-w-md lg:max-w-none">
              {/* Main Bento Mobile App Frame */}
              <div className="relative bg-white rounded-3xl p-5 shadow-2xl border border-slate-200/90 overflow-hidden">
                {/* Header of Mock Screen */}
                <div className="flex items-center justify-between border-b border-slate-100 pb-4 mb-4">
                  <div className="flex items-center gap-2.5">
                    <div className="relative w-8 h-8 rounded-lg overflow-hidden bg-slate-50 p-1 border border-slate-200">
                      <Image
                        src="/Q_logo.png"
                        alt="Qrie Q"
                        fill
                        className="object-contain"
                      />
                    </div>
                    <div>
                      <div className="text-xs font-bold text-slate-900">Hi, Aarav Sharma</div>
                      <div className="text-[10px] text-slate-500">Class 10 CBSE • Science</div>
                    </div>
                  </div>
                  <div className="px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-700 text-[10px] font-bold border border-emerald-200">
                    6-Day Streak 🔥
                  </div>
                </div>

                {/* AI Tutor Chat Card */}
                <div className="bg-sky-50/80 rounded-2xl p-4 border border-sky-100 mb-4 space-y-2.5">
                  <div className="flex items-center justify-between text-xs font-semibold text-sky-800">
                    <span className="flex items-center gap-1.5">
                      <Sparkles className="w-3.5 h-3.5 text-sky-600" />
                      Qrie AI Tutor
                    </span>
                    <span className="text-[10px] bg-white px-2 py-0.5 rounded-full border border-sky-200 text-sky-700 font-bold">
                      Step-by-Step
                    </span>
                  </div>
                  <p className="text-xs text-slate-700 leading-relaxed">
                    &quot;Let&apos;s look at Photosynthesis. Remember: what happens to water molecules when light hits chlorophyll? What gas is released?&quot;
                  </p>
                  <div className="flex items-center gap-2 pt-1">
                    <span className="text-[10px] font-semibold bg-white text-slate-800 px-2 py-1 rounded-md border border-slate-200 shadow-2xs">
                      A: Oxygen is split
                    </span>
                    <span className="text-[10px] font-semibold bg-white text-slate-800 px-2 py-1 rounded-md border border-slate-200 shadow-2xs">
                      B: Carbon is fixed
                    </span>
                  </div>
                </div>

                {/* LAM Cognitive Progress Pill */}
                <div className="bg-slate-900 text-white rounded-2xl p-4 space-y-2 mb-4">
                  <div className="flex items-center justify-between text-xs">
                    <span className="text-slate-300 font-medium">Topic Mastery (BKT Score)</span>
                    <span className="font-bold text-emerald-400">84% Mastered</span>
                  </div>
                  <div className="w-full bg-slate-800 h-2 rounded-full overflow-hidden">
                    <div className="bg-emerald-400 h-full w-[84%] rounded-full transition-all duration-500" />
                  </div>
                  <div className="flex items-center justify-between text-[10px] text-slate-400 pt-1">
                    <span>Chemical Reactions & Equations</span>
                    <span className="text-sky-300">Next: Practice 3 Questions</span>
                  </div>
                </div>

                {/* Teacher / School sync indicator */}
                <div className="flex items-center justify-between p-3 rounded-xl bg-slate-50 border border-slate-200 text-xs">
                  <div className="flex items-center gap-2">
                    <School className="w-4 h-4 text-sky-600" />
                    <span className="font-medium text-slate-800">Delhi Public School • Class 10-A</span>
                  </div>
                  <span className="text-[10px] text-slate-500 font-semibold">Synced</span>
                </div>
              </div>

              {/* Floating Badge */}
              <div className="absolute -bottom-4 -left-4 bg-white rounded-2xl p-3 shadow-xl border border-slate-200/90 flex items-center gap-3 animate-bounce-slow">
                <div className="w-10 h-10 rounded-xl bg-emerald-50 border border-emerald-200 flex items-center justify-center text-emerald-600 font-bold">
                  BKT
                </div>
                <div>
                  <div className="text-xs font-bold text-slate-900">Bayesian Adaptation</div>
                  <div className="text-[10px] text-slate-500">Sub-15ms Cognitive Tracking</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
