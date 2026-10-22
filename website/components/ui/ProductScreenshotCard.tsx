import React from "react";
import { Button } from "@/components/ui/Button";
import { ArrowRight, Sparkles, CheckCircle2 } from "lucide-react";

export function ProductScreenshotCard() {
  return (
    <section className="py-16 sm:py-20 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
        {/* Solid #1868db Blue Showcase Frame */}
        <div className="bg-[#1868db] rounded-[24px] p-8 sm:p-12 lg:p-16 text-white relative overflow-hidden">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            {/* Left Messaging */}
            <div className="lg:col-span-5 space-y-4">
              <span className="inline-block px-3 py-1 rounded-full text-[13px] font-medium bg-white/20 text-white backdrop-blur-xs">
                Product Showcase
              </span>
              <h2 className="text-3xl sm:text-4xl font-medium tracking-[0.012em] leading-tight text-white">
                Step-by-Step AI Tutoring & Bayesian Tracking
              </h2>
              <p className="text-white/90 text-base leading-[1.5]">
                Designed specifically for NCERT Classes 6–12. Real-time cognitive evaluation without spoiling answers, giving students the Socratic push they need.
              </p>
              <div className="pt-2">
                <Button
                  href="/demo"
                  variant="yellow"
                  size="md"
                  icon={<ArrowRight className="w-4 h-4" />}
                >
                  Try Interactive Demo
                </Button>
              </div>
            </div>

            {/* Right Product Screenshot: Offset/Tilted 3° on Solid Blue */}
            <div className="lg:col-span-7 flex justify-center lg:justify-end">
              <div className="relative w-full max-w-lg transform lg:rotate-3 transition-transform hover:rotate-0 duration-300">
                {/* Product UI container with ~5px radius corners */}
                <div className="bg-white rounded-[5px] p-5 shadow-2xl text-[#101214] space-y-4">
                  {/* Mock Window Bar */}
                  <div className="flex items-center justify-between border-b border-[#f0f1f2] pb-3">
                    <div className="flex items-center gap-2">
                      <div className="w-2.5 h-2.5 rounded-full bg-rose-400" />
                      <div className="w-2.5 h-2.5 rounded-full bg-amber-400" />
                      <div className="w-2.5 h-2.5 rounded-full bg-emerald-400" />
                      <span className="text-[11px] font-medium text-[#42526e] ml-2">
                        qrie.ai/tutor • Class 10 Science
                      </span>
                    </div>
                    <span className="text-[10px] font-bold text-[#1868db] bg-[#e9f2fe] px-2 py-0.5 rounded-[5px]">
                      NCERT Live
                    </span>
                  </div>

                  {/* Socratic Step Interaction */}
                  <div className="bg-[#f0f1f2] rounded-[5px] p-4 space-y-2.5">
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-bold text-[#101214] flex items-center gap-1.5">
                        <Sparkles className="w-3.5 h-3.5 text-[#1868db]" />
                        Qrie Socratic Tutor
                      </span>
                      <span className="text-[10px] text-[#42526e]">Step 2 of 4</span>
                    </div>
                    <p className="text-xs text-[#292a2e] leading-relaxed">
                      &quot;In the equation <strong>2H₂ + O₂ → 2H₂O</strong>, notice the bonds breaking. Is energy absorbed or released when water molecules form?&quot;
                    </p>
                    <div className="grid grid-cols-2 gap-2 pt-1">
                      <button className="text-left text-xs bg-white p-2.5 rounded-[5px] border border-[#f0f1f2] hover:border-[#1868db] font-medium transition-colors">
                        A: Energy is absorbed
                      </button>
                      <button className="text-left text-xs bg-white p-2.5 rounded-[5px] border border-[#1868db] bg-[#e9f2fe]/40 font-semibold text-[#1868db]">
                        B: Energy is released ✓
                      </button>
                    </div>
                  </div>

                  {/* Bayesian State Widget */}
                  <div className="flex items-center justify-between pt-1 text-xs">
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-[#101214]">BKT Mastery P(L):</span>
                      <span className="text-emerald-600 font-extrabold">0.86 (Mastered)</span>
                    </div>
                    <div className="flex items-center gap-1 text-[#42526e] text-[11px]">
                      <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" />
                      <span>Chemical Equations Concept Node</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
