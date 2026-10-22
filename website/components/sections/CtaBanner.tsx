import React from "react";
import { Button } from "@/components/ui/Button";
import { School, ArrowRight, Sparkles } from "lucide-react";

export function CtaBanner({
  title = "Ready to transform learning in your school?",
  description = "Join progressive K-12 institutions across India using Qrie's Learning Adaptation Model to deliver personalized education and automated teacher diagnostics.",
  primaryCtaText = "Request a School Demo",
  primaryCtaHref = "/school-demo",
  secondaryCtaText = "Get a Custom Quote",
  secondaryCtaHref = "/get-a-quote",
}: {
  title?: string;
  description?: string;
  primaryCtaText?: string;
  primaryCtaHref?: string;
  secondaryCtaText?: string;
  secondaryCtaHref?: string;
}) {
  return (
    <section className="py-20 bg-[#101214] text-white relative overflow-hidden">
      {/* Torn geometric confetti accents in corners */}
      <div
        className="absolute -top-4 -left-4 w-12 h-12 bg-[#bf63f3] -rotate-12 pointer-events-none"
        aria-hidden="true"
      />
      <div
        className="absolute top-1/2 -right-4 w-8 h-16 bg-[#fca700] rotate-45 pointer-events-none"
        aria-hidden="true"
      />
      <div
        className="absolute -bottom-4 right-1/4 w-14 h-8 bg-[#36b37e] rotate-12 pointer-events-none"
        aria-hidden="true"
      />

      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 relative text-center space-y-6">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#1c2b42] text-[13px] font-medium text-[#fca700]">
          <Sparkles className="w-3.5 h-3.5 text-[#fca700]" />
          <span>Transforming K-12 Classrooms</span>
        </div>

        <h2 className="text-3xl sm:text-4xl lg:text-[48px] font-medium tracking-[0.012em] max-w-3xl mx-auto leading-[1.14]">
          {title}
        </h2>

        <p className="text-[#b7b9be] text-base max-w-2xl mx-auto leading-[1.5] font-normal">
          {description}
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
          <Button
            href={primaryCtaHref}
            variant="yellow"
            size="lg"
            icon={<School className="w-4 h-4 text-[#101214]" />}
          >
            {primaryCtaText}
          </Button>
          <Button
            href={secondaryCtaHref}
            variant="white"
            size="lg"
            icon={<ArrowRight className="w-4 h-4" />}
          >
            {secondaryCtaText}
          </Button>
        </div>
      </div>
    </section>
  );
}
