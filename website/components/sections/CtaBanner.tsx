import React from "react";
import Link from "next/link";
import { Button } from "@/components/ui/Button";
import { School, ArrowRight, Sparkles } from "lucide-react";

export function CtaBanner({
  title = "Ready to Transform Learning in Your School?",
  description = "Join progressive K-12 schools using Qrie's Learning Adaptation Model to deliver personalized education and automated teacher diagnostics.",
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
    <section className="py-20 bg-gradient-to-r from-sky-900 via-slate-900 to-indigo-950 text-white relative overflow-hidden">
      {/* Glow effect */}
      <div className="absolute top-0 right-0 w-96 h-96 bg-sky-500/10 blur-3xl rounded-full pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative text-center space-y-6">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-sky-900/60 border border-sky-700/80 text-xs font-semibold text-sky-300">
          <Sparkles className="w-3.5 h-3.5 text-sky-400" />
          <span>Transforming K-12 Classrooms</span>
        </div>

        <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight max-w-3xl mx-auto leading-tight">
          {title}
        </h2>

        <p className="text-slate-300 text-base sm:text-lg max-w-2xl mx-auto leading-relaxed">
          {description}
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 pt-4">
          <Button
            href={primaryCtaHref}
            variant="white"
            size="lg"
            icon={<School className="w-5 h-5 text-sky-700" />}
          >
            {primaryCtaText}
          </Button>
          <Button
            href={secondaryCtaHref}
            variant="outline"
            size="lg"
            className="border-slate-600 text-white bg-slate-800/80 hover:bg-slate-700"
            icon={<ArrowRight className="w-4 h-4" />}
          >
            {secondaryCtaText}
          </Button>
        </div>
      </div>
    </section>
  );
}
