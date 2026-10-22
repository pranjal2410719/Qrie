import React from "react";

export function HeroConfettiEdges() {
  return (
    <div
      className="absolute inset-0 pointer-events-none overflow-hidden"
      aria-hidden="true"
    >
      {/* Left-edge fragmented geometric shapes */}
      <div className="absolute -left-6 top-8 w-16 h-8 bg-[#bf63f3] -rotate-12 transform" />
      <div className="absolute left-4 top-24 w-10 h-16 bg-[#fca700] rotate-45 transform" />
      <div className="absolute -left-4 top-48 w-20 h-6 bg-[#1868db] rotate-6 transform" />
      <div className="absolute left-8 top-72 w-8 h-8 bg-[#36b37e] rotate-12 transform" />
      <div className="absolute -left-8 bottom-16 w-14 h-14 bg-[#bf63f3] -rotate-45 transform" />
      <div className="absolute left-6 bottom-36 w-6 h-12 bg-[#fca700] rotate-12 transform" />

      {/* Right-edge fragmented geometric shapes */}
      <div className="absolute -right-6 top-12 w-14 h-14 bg-[#fca700] rotate-12 transform" />
      <div className="absolute right-6 top-32 w-12 h-6 bg-[#36b37e] -rotate-12 transform" />
      <div className="absolute -right-4 top-64 w-18 h-8 bg-[#1868db] rotate-45 transform" />
      <div className="absolute right-8 top-96 w-10 h-10 bg-[#bf63f3] -rotate-6 transform" />
      <div className="absolute -right-8 bottom-24 w-16 h-8 bg-[#36b37e] rotate-12 transform" />
      <div className="absolute right-4 bottom-8 w-12 h-6 bg-[#fca700] -rotate-45 transform" />
    </div>
  );
}

export function VideoConfettiFrame({ children }: { children: React.ReactNode }) {
  return (
    <div className="relative inline-block w-full">
      {/* Decorative torn geometric confetti shapes breaking the rectangular frame */}
      <div
        className="absolute -top-3 -left-3 w-10 h-10 bg-[#bf63f3] -rotate-12 -z-10"
        aria-hidden="true"
      />
      <div
        className="absolute top-1/2 -right-4 w-6 h-14 bg-[#fca700] rotate-12 -z-10"
        aria-hidden="true"
      />
      <div
        className="absolute -bottom-3 left-1/4 w-12 h-6 bg-[#36b37e] rotate-6 -z-10"
        aria-hidden="true"
      />
      <div
        className="absolute -bottom-4 -right-3 w-12 h-10 bg-[#1868db] -rotate-6 -z-10"
        aria-hidden="true"
      />

      {/* Conic gradient border highlight */}
      <div
        className="p-[3px] rounded-[22px]"
        style={{
          background:
            "conic-gradient(rgb(191, 99, 243) 170deg, rgb(252, 167, 0) 171deg, rgb(252, 167, 0) 230deg, rgb(77, 140, 237) 231deg, rgb(77, 140, 237) 360deg)",
        }}
      >
        <div className="rounded-[20px] overflow-hidden bg-[#101214]">
          {children}
        </div>
      </div>
    </div>
  );
}
