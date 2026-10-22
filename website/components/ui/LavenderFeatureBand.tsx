import React from "react";
import Link from "next/link";
import { ArrowRight } from "lucide-react";

interface LavenderFeatureBandProps {
  badge?: string;
  headline?: string;
  body?: string;
  ctaText?: string;
  ctaHref?: string;
}

export function LavenderFeatureBand({
  badge = "The Educational Imperative",
  headline = "School education should adapt to the student, not the other way around.",
  body = "Traditional K-12 instruction assumes every student grasps concepts at the identical pace. Qrie replaces rigid one-size-fits-all curricula with dynamic Bayesian knowledge tracing that pinpoints atomic learning gaps in real time.",
  ctaText = "Explore the science behind LAM",
  ctaHref = "/lam",
}: LavenderFeatureBandProps) {
  return (
    <section className="w-full bg-[#eed7fc] py-16 sm:py-20">
      <div className="max-w-[960px] mx-auto px-4 sm:px-6 lg:px-8 text-center space-y-4">
        {badge && (
          <span className="inline-block text-[13px] font-medium uppercase tracking-wider text-[#101214] opacity-80">
            {badge}
          </span>
        )}
        <h2 className="text-2xl sm:text-3xl lg:text-[38px] font-normal tracking-[0.012em] text-[#101214] leading-[1.25]">
          {headline}
        </h2>
        <p className="text-base text-[#101214] leading-[1.5] max-w-[720px] mx-auto opacity-90 font-normal">
          {body}
        </p>
        {ctaText && ctaHref && (
          <div className="pt-2">
            <Link
              href={ctaHref}
              className="inline-flex items-center gap-1.5 text-base font-medium text-[#1868db] hover:underline transition-all"
            >
              <span>{ctaText}</span>
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        )}
      </div>
    </section>
  );
}
