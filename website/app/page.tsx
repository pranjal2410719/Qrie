import React from "react";
import type { Metadata } from "next";
import { HeroSection } from "@/components/sections/HeroSection";
import { AdaptiveCycleDiagram } from "@/components/sections/AdaptiveCycleDiagram";
import { LamExplainer } from "@/components/sections/LamExplainer";
import { SchoolAppsShowcase } from "@/components/sections/SchoolAppsShowcase";
import { FeatureGrid } from "@/components/sections/FeatureGrid";
import { TestimonialSection } from "@/components/sections/TestimonialSection";
import { FaqAccordion } from "@/components/sections/FaqAccordion";
import { CtaBanner } from "@/components/sections/CtaBanner";
import { ProductScreenshotCard } from "@/components/ui/ProductScreenshotCard";
import { LavenderFeatureBand } from "@/components/ui/LavenderFeatureBand";
import { VideoPlayerBlock } from "@/components/ui/VideoPlayerBlock";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";

export const metadata: Metadata = {
  title: "Qrie AI — Adaptive Learning Platform & Learning Adaptation Model",
  description:
    "Personalized NCERT K-12 education powered by the Learning Adaptation Model (LAM). Step-by-step Socratic AI tutoring, continuous Bayesian mastery tracking, and connected apps for students, teachers, and schools.",
  alternates: {
    canonical: "https://qrie.ai",
  },
};

export default function HomePage() {
  return (
    <div className="flex flex-col">
      {/* 1. Atlassian Dark Hero Banner with Confetti Framing & Taxicab Yellow CTA */}
      <HeroSection />

      {/* 2. Trust & Verified Standards Strip */}
      <section className="bg-[#101214] text-[#f0f1f2] py-5 border-y border-[#292a2e]">
        <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
            <div className="flex flex-col items-center justify-center">
              <span className="text-xl sm:text-2xl font-medium text-white tracking-tight">NCERT</span>
              <span className="text-[12px] text-[#b7b9be] mt-0.5">Classes 6–12 Curriculum</span>
            </div>
            <div className="flex flex-col items-center justify-center">
              <span className="text-xl sm:text-2xl font-medium text-[#1868db] tracking-tight">BKT Math</span>
              <span className="text-[12px] text-[#b7b9be] mt-0.5">Bayesian Knowledge Tracing</span>
            </div>
            <div className="flex flex-col items-center justify-center">
              <span className="text-xl sm:text-2xl font-medium text-emerald-400 tracking-tight">Offline-First</span>
              <span className="text-[12px] text-[#b7b9be] mt-0.5">Low-Bandwidth SQLite Sync</span>
            </div>
            <div className="flex flex-col items-center justify-center">
              <span className="text-xl sm:text-2xl font-medium text-[#bf63f3] tracking-tight">DPDP 2023</span>
              <span className="text-[12px] text-[#b7b9be] mt-0.5">Tenant-Isolated Privacy</span>
            </div>
          </div>
        </div>
      </section>

      {/* 3. Lavender Feature Band (Editorial Divider Between Dark and White Canvas) */}
      <LavenderFeatureBand
        badge="The Educational Imperative"
        headline="School education should adapt to the student, not the other way around."
        body="Traditional classrooms assume every student grasps concepts at the identical pace. Qrie replaces rigid curricula with dynamic Bayesian knowledge tracing that pinpoints atomic learning gaps in real time."
        ctaText="Explore how LAM models student comprehension"
        ctaHref="/lam"
      />

      {/* 4. Product UI Screenshot Showcase Card (Tilted 3° on Solid #1868db Blue) */}
      <ProductScreenshotCard />

      {/* 5. The Continuous Adaptive Learning Cycle (8-Step Loop on Pure White Canvas) */}
      <AdaptiveCycleDiagram />

      {/* 6. Signature Video / Interactive Player with Confetti Frame & Conic Border */}
      <VideoPlayerBlock />

      {/* 7. Inverted Dark Section (The Learning Adaptation Model Engine) */}
      <LamExplainer />

      {/* 8. Connected School Operating System & Apps */}
      <SchoolAppsShowcase />

      {/* 9. Beneficiary Feature Grid (Students, Parents, Teachers, School Leadership) */}
      <FeatureGrid />

      {/* 10. Verified Educator & Institutional Feedback */}
      <TestimonialSection />

      {/* 11. Frequently Asked Questions with Centered Editorial Headline */}
      <section className="py-20 bg-white">
        <div className="max-w-[900px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
          <EditorialHeadline
            badge="Clear Answers"
            title="Frequently Asked Questions"
            highlightWord="Questions"
            description="Everything you need to know about Qrie AI, the LAM cognitive engine, CBSE/NCERT curriculum alignment, and school deployment."
          />

          <FaqAccordion limit={5} showCategoryFilter={false} />
        </div>
      </section>

      {/* 12. Final High-Contrast CTA Banner */}
      <CtaBanner />
    </div>
  );
}
