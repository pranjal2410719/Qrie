"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { pricingTiers } from "@/lib/data/pricing";
import { PlanComparisonTable } from "@/components/commerce/PlanComparisonTable";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { Check, ArrowRight, ShieldCheck, HelpCircle } from "lucide-react";

export default function PricingPage() {
  const [billingCycle, setBillingCycle] = useState<"monthly" | "annual">("annual");

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Pricing & Plans", href: "/pricing" }]} />

        {/* Hero */}
        <div className="text-center max-w-3xl mx-auto space-y-4">
          <Badge variant="primary" size="md">
            <span>Transparent Educational Pricing</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Predictable Plans for Students & Schools
          </h1>
          <p className="text-base text-slate-600 leading-relaxed font-normal">
            Whether you are an individual student preparing for board exams or an educational institution
            modernizing 50 classrooms, our plans offer fair, predictable pricing with no hidden fees.
          </p>

          {/* Billing Toggle */}
          <div className="pt-4 flex items-center justify-center gap-3">
            <span className={`text-xs font-semibold ${billingCycle === "monthly" ? "text-slate-900" : "text-slate-400"}`}>
              Monthly
            </span>
            <button
              onClick={() => setBillingCycle(billingCycle === "monthly" ? "annual" : "monthly")}
              className="relative w-12 h-6 bg-sky-600 rounded-full transition-colors p-0.5 focus:outline-none"
              aria-label="Toggle annual billing discount"
            >
              <div
                className={`w-5 h-5 bg-white rounded-full transition-transform duration-200 ${
                  billingCycle === "annual" ? "translate-x-6" : "translate-x-0"
                }`}
              />
            </button>
            <div className="flex items-center gap-1.5">
              <span className={`text-xs font-semibold ${billingCycle === "annual" ? "text-slate-900" : "text-slate-400"}`}>
                Annual
              </span>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                Save 25%
              </span>
            </div>
          </div>
        </div>

        {/* Tier Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 items-stretch">
          {pricingTiers.map((tier) => {
            const displayPrice =
              tier.priceMonthly === 0
                ? "Free"
                : billingCycle === "annual"
                ? `₹${Math.round(tier.priceAnnual / 12).toLocaleString("en-IN")}`
                : `₹${tier.priceMonthly.toLocaleString("en-IN")}`;

            return (
              <div
                key={tier.id}
                className={`p-6 sm:p-8 rounded-3xl border flex flex-col justify-between transition-all duration-200 ${
                  tier.popular
                    ? "border-sky-500 bg-sky-50/30 shadow-lg ring-1 ring-sky-500/50"
                    : "border-slate-200 bg-white hover:border-slate-300 hover:shadow-xs"
                }`}
              >
                <div className="space-y-6">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-lg text-slate-900">{tier.name}</span>
                    {tier.badge && (
                      <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-sky-100 text-sky-800">
                        {tier.badge}
                      </span>
                    )}
                  </div>

                  <div>
                    <div className="text-3xl font-black text-slate-900">
                      {tier.isQuoteOnly ? (
                        <span className="text-xl">Custom Quote</span>
                      ) : (
                        <>
                          {displayPrice}{" "}
                          <span className="text-xs font-normal text-slate-500">
                            {tier.priceMonthly > 0 ? "/month" : ""}
                          </span>
                        </>
                      )}
                    </div>
                    <div className="text-xs text-slate-500 mt-1">{tier.billingText}</div>
                  </div>

                  <p className="text-xs text-slate-600 leading-relaxed border-t border-slate-100 pt-3">
                    {tier.tagline}
                  </p>

                  <div className="space-y-2 border-t border-slate-100 pt-4">
                    <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                      Included
                    </div>
                    <ul className="space-y-2 text-xs text-slate-700">
                      {tier.features.map((feat, i) => (
                        <li key={i} className="flex items-start gap-2">
                          <Check className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
                          <span>{feat}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>

                <div className="pt-6 border-t border-slate-100 mt-6">
                  <Button
                    href={tier.ctaHref}
                    variant={tier.popular ? "primary" : "outline"}
                    size="md"
                    className="w-full text-xs font-bold"
                  >
                    {tier.ctaText}
                  </Button>
                </div>
              </div>
            );
          })}
        </div>

        {/* Full Feature Comparison Matrix */}
        <div className="space-y-6 pt-12 border-t border-slate-100">
          <div className="max-w-3xl space-y-2">
            <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900">
              Detailed Plan Comparison
            </h2>
            <p className="text-xs sm:text-sm text-slate-600">
              Review fine-grained feature availability, LAM capabilities, and institutional SLA terms.
            </p>
          </div>

          <PlanComparisonTable />
        </div>
      </div>
    </div>
  );
}
