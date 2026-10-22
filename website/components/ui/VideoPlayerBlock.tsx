"use client";

import React, { useState } from "react";
import { Play, Sparkles, CheckCircle2 } from "lucide-react";
import { VideoConfettiFrame } from "./ConfettiDecoration";
import { EditorialHeadline } from "./EditorialHeadline";

export function VideoPlayerBlock() {
  const [isPlaying, setIsPlaying] = useState(false);

  return (
    <section className="py-20 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <EditorialHeadline
          badge="Product in Action"
          title="See Qrie's Socratic Engine in 90 Seconds"
          highlightWord="Socratic Engine"
          description="Watch how an actual student interacts with the step-by-step NCERT tutor and how the teacher receives automatic struggle analytics."
        />

        <div className="max-w-4xl mx-auto">
          <VideoConfettiFrame>
            <div className="relative aspect-video w-full bg-[#101214] flex items-center justify-center overflow-hidden group">
              {/* Darkened background simulation / thumbnail */}
              <div className="absolute inset-0 bg-gradient-to-tr from-[#101214] via-[#1c2b42] to-[#101214] opacity-80" />

              {/* Decorative diagram grid inside video */}
              <div
                className="absolute inset-0 opacity-15"
                style={{
                  backgroundImage:
                    "radial-gradient(#ffffff 1px, transparent 1px)",
                  backgroundSize: "24px 24px",
                }}
              />

              {!isPlaying ? (
                <div className="relative z-10 text-center space-y-4 px-4">
                  {/* Centered White Play Button (~64px) */}
                  <button
                    onClick={() => setIsPlaying(true)}
                    className="w-16 h-16 rounded-full bg-white flex items-center justify-center text-[#1868db] shadow-xl hover:scale-110 active:scale-95 transition-all duration-200 mx-auto group-hover:bg-[#fca700] group-hover:text-[#101214]"
                    aria-label="Play Qrie AI walkthrough video"
                  >
                    <Play className="w-7 h-7 ml-1 fill-current" />
                  </button>
                  <div className="space-y-1">
                    <div className="text-white font-medium text-base sm:text-lg">
                      Interactive Product Walkthrough
                    </div>
                    <div className="text-xs text-[#b7b9be]">
                      CBSE Class 10 • Quadratic Equations & Chemical Reactions
                    </div>
                  </div>
                </div>
              ) : (
                <div className="relative z-10 w-full h-full p-8 flex flex-col justify-between text-white animate-in fade-in duration-300">
                  <div className="flex items-center justify-between border-b border-white/20 pb-4">
                    <span className="text-sm font-semibold flex items-center gap-2">
                      <Sparkles className="w-4 h-4 text-[#fca700]" />
                      Simulated Live Session: Photosynthesis & Light Reactions
                    </span>
                    <button
                      onClick={() => setIsPlaying(false)}
                      className="text-xs text-white/70 hover:text-white px-2 py-1 bg-white/10 rounded-full"
                    >
                      Reset Preview
                    </button>
                  </div>
                  <div className="max-w-xl mx-auto text-center space-y-3 py-6">
                    <p className="text-sm sm:text-base text-white/90 italic">
                      &quot;Step 1: The photon activates chlorophyll P680. Water photolysis splits H₂O into oxygen and protons. The student correctly identified the byproduct.&quot;
                    </p>
                    <div className="inline-flex items-center gap-2 px-3 py-1 bg-[#1868db] text-white rounded-full text-xs font-semibold">
                      <CheckCircle2 className="w-3.5 h-3.5" />
                      <span>Posterior Mastery updated to 0.91 (+0.07)</span>
                    </div>
                  </div>
                  <div className="text-center text-xs text-[#b7b9be]">
                    Click Reset Preview to replay or explore the live interactive demo page.
                  </div>
                </div>
              )}
            </div>
          </VideoConfettiFrame>
        </div>
      </div>
    </section>
  );
}
