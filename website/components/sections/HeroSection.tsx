import React from "react";
import Image from "next/image";
import { Button } from "@/components/ui/Button";
import { HeroConfettiEdges } from "@/components/ui/ConfettiDecoration";
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
    <section className="relative overflow-hidden pt-16 pb-20 lg:pt-24 lg:pb-32 bg-[#101214] text-white">
      {/* Signature Atlassian Confetti Edges (Vivid Violet, Taxicab Yellow, Electric Blue, Leaf Green) */}
      <HeroConfettiEdges />

      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-10 items-center">
          {/* Left Column: Messaging & Yellow CTA */}
          <div className="lg:col-span-7 space-y-6 text-left">
            <div className="inline-flex items-center gap-2">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[13px] font-medium leading-[1.29] bg-[#1c2b42] text-[#fca700]">
                <BrainCircuit className="w-3.5 h-3.5 text-[#fca700]" />
                <span>Learning Adaptation Model (LAM)</span>
              </span>
            </div>

            {/* Charlie Display Editorial Headline: Scales up to 72px-80px with 0.012em tracking */}
            <h1 className="text-4xl sm:text-6xl lg:text-[76px] font-medium text-white tracking-[0.012em] leading-[1.05]">
              Personalized learning for school students.
            </h1>

            <p className="text-base text-white/90 max-w-xl leading-[1.5] font-normal">
              Qrie AI bridges learning gaps across NCERT Classes 6–12. Our proprietary{" "}
              <span className="text-white font-medium">Learning Adaptation Model</span>{" "}
              combines continuous Bayesian mastery tracking, step-by-step Socratic AI tutoring, and
              connected apps for students, teachers, and school leadership.
            </p>

            {/* CTAs: Primary Yellow (#fca700) CTA strictly on dark hero */}
            <div className="flex flex-wrap items-center gap-4 pt-2">
              <Button
                href="/school-demo"
                variant="yellow"
                size="lg"
                icon={<School className="w-4 h-4 text-[#101214]" />}
              >
                Request a School Demo
              </Button>
              <Button
                href="/platform"
                variant="white"
                size="lg"
                icon={<ArrowRight className="w-4 h-4" />}
              >
                Explore Platform
              </Button>
              <Button
                href="/demo"
                variant="secondary"
                size="lg"
                className="text-white hover:text-[#fca700]"
              >
                Try Interactive Demo
              </Button>
            </div>

            {/* Proof Badges */}
            <div className="pt-6 border-t border-[#292a2e] flex flex-wrap items-center gap-y-3 gap-x-6 text-[13px] text-[#b7b9be] font-normal">
              <div className="flex items-center gap-2">
                <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0" />
                <span>NCERT Classes 6–12 Aligned</span>
              </div>
              <div className="flex items-center gap-2">
                <Smartphone className="w-4 h-4 text-[#1868db] shrink-0" />
                <span>Offline-First Android App</span>
              </div>
              <div className="flex items-center gap-2">
                <ShieldCheck className="w-4 h-4 text-[#bf63f3] shrink-0" />
                <span>DPDP Act 2023 Compliant</span>
              </div>
            </div>
          </div>

          {/* Right Column: Promotional Bento Card with 20px radius */}
          <div className="lg:col-span-5 relative">
            <div className="bg-white text-[#101214] rounded-[20px] p-6 shadow-2xl border border-[#292a2e] space-y-4">
              {/* Card Header */}
              <div className="flex items-center justify-between border-b border-[#f0f1f2] pb-4">
                <div className="flex items-center gap-2.5">
                  <div className="relative w-8 h-8 rounded-[8px] overflow-hidden bg-[#f0f1f2] p-1 border border-[#f0f1f2]">
                    <Image
                      src="/Q_logo.png"
                      alt="Qrie Mark"
                      fill
                      sizes="32px"
                      className="object-contain"
                    />
                  </div>
                  <div>
                    <div className="text-[14px] font-bold text-[#101214]">Aarav Sharma</div>
                    <div className="text-[12px] text-[#42526e]">Class 10 CBSE • Science</div>
                  </div>
                </div>
                <span className="px-2.5 py-0.5 rounded-full bg-[#e3fcef] text-[#006644] text-[11px] font-bold">
                  6-Day Streak 🔥
                </span>
              </div>

              {/* Socratic Dialogue Preview */}
              <div className="bg-[#f0f1f2] rounded-[12px] p-4 space-y-2">
                <div className="flex items-center justify-between text-[13px] font-bold text-[#101214]">
                  <span className="flex items-center gap-1.5">
                    <Sparkles className="w-3.5 h-3.5 text-[#1868db]" />
                    Qrie Socratic Tutor
                  </span>
                  <span className="text-[10px] bg-white px-2 py-0.5 rounded-full text-[#1868db] font-semibold border border-[#f0f1f2]">
                    Step-by-Step
                  </span>
                </div>
                <p className="text-[13px] text-[#292a2e] leading-relaxed">
                  &quot;Let&apos;s look at Photosynthesis. Remember: what happens to water molecules when light hits chlorophyll? What gas is released?&quot;
                </p>
                <div className="flex items-center gap-2 pt-1">
                  <span className="text-[11px] font-semibold bg-white text-[#101214] px-2.5 py-1 rounded-[6px] border border-[#f0f1f2]">
                    A: Oxygen is split
                  </span>
                  <span className="text-[11px] font-semibold bg-[#e9f2fe] text-[#1868db] px-2.5 py-1 rounded-[6px] border border-[#1868db]">
                    B: Carbon is fixed
                  </span>
                </div>
              </div>

              {/* BKT Mastery Tracker */}
              <div className="bg-[#101214] text-white rounded-[12px] p-4 space-y-2">
                <div className="flex items-center justify-between text-[12px]">
                  <span className="text-[#b7b9be] font-medium">BKT Topic Mastery P(L)</span>
                  <span className="font-bold text-emerald-400">84% Mastered</span>
                </div>
                <div className="w-full bg-[#292a2e] h-2 rounded-full overflow-hidden">
                  <div className="bg-emerald-400 h-full w-[84%] rounded-full" />
                </div>
                <div className="flex items-center justify-between text-[11px] text-[#b7b9be] pt-0.5">
                  <span>Chemical Reactions & Equations</span>
                  <span className="text-[#fca700]">Next: Practice 3 Questions</span>
                </div>
              </div>

              {/* Institutional Sync */}
              <div className="flex items-center justify-between p-3 rounded-[12px] bg-[#f0f1f2] text-[12px]">
                <div className="flex items-center gap-2">
                  <School className="w-4 h-4 text-[#1868db]" />
                  <span className="font-medium text-[#101214]">Delhi Public School • Class 10-A</span>
                </div>
                <span className="text-[11px] text-emerald-600 font-bold">Live Synced</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
