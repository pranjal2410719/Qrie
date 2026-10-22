"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { pricingTiers } from "@/lib/data/pricing";
import { PlanComparisonTable } from "@/components/commerce/PlanComparisonTable";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";
import { Check, ArrowRight, ShieldCheck, HelpCircle } from "lucide-react";

export default function PricingPage() {
  const [billingCycle, setBillingCycle] = useState<"monthly" | "annual">("annual");

  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Pricing & Plans", href: "/pricing" }]} />

        {/* Hero Editorial Opener */}
        <div className="text-center max-w-3xl mx-auto space-y-4">
          <Badge variant="primary" size="md">
            <span>Transparent Educational Pricing</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Predictable Plans for Students & Schools
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Whether you are an individual student preparing for board exams or an educational institution
            modernizing 50 classrooms, our plans offer fair, predictable pricing with no hidden fees.
          </p>

          {/* Billing Toggle (Atlassian Blue pill switch) */}
          <div className="pt-4 flex items-center justify-center gap-3">
            <span
              className={`text-[14px] ${
                billingCycle === "monthly" ? "font-semibold text-[#101214]" : "text-[#42526e]"
              }`}
            >
              Monthly Billing
            </span>
            <button
              onClick={() => setBillingCycle(billingCycle === "monthly" ? "annual" : "monthly")}
              className="relative w-12 h-6 bg-[#1868db] rounded-full transition-colors p-0.5 focus:outline-none"
              aria-label="Toggle annual billing discount"
            >
              <div
                className={`w-5 h-5 bg-white rounded-full transition-transform duration-200 ${
                  billingCycle === "annual" ? "translate-x-6" : "translate-x-0"
                }`}
              />
            </button>
            <div className="flex items-center gap-1.5">
              <span
                className={`text-[14px] ${
                  billingCycle === "annual" ? "font-semibold text-[#101214]" : "text-[#42526e]"
                }`}
              >
                Annual Billing
              </span>
              <span className="text-[11px] font-bold px-2 py-0.5 rounded-full bg-[#e3fcef] text-[#006644]">
                Save 25%
              </span>
            </div>
          </div>
        </div>

        {/* Tier Cards Grid (20px radius cards, subtle shadow) */}
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
                className={`p-6 sm:p-7 rounded-[20px] border flex flex-col justify-between transition-colors ${
                  tier.popular
                    ? "border-[#1868db] bg-[#e9f2fe]/40 shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_2px_4px_0px]"
                    : "border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] hover:border-[#b7b9be]"
                }`}
              >
                <div className="space-y-6">
                  <div className="flex items-center justify-between">
                    <span className="font-medium text-lg text-[#101214]">{tier.name}</span>
                    {tier.badge && (
                      <span className="text-[11px] font-medium px-2.5 py-0.5 rounded-full bg-[#1868db] text-white">
                        {tier.badge}
                      </span>
                    )}
                  </div>

                  <div>
                    <div className="text-3xl font-medium tracking-[0.012em] text-[#101214]">
                      {tier.isQuoteOnly ? (
                        <span className="text-2xl">Custom Quote</span>
                      ) : (
                        <>
                          {displayPrice}{" "}
                          <span className="text-[13px] font-normal text-[#42526e]">
                            {tier.priceMonthly > 0 ? "/month" : ""}
                          </span>
                        </>
                      )}
                    </div>
                    <p className="text-[13px] text-[#42526e] mt-2 leading-[1.5] font-normal">
                      {tier.tagline}
                    </p>
                  </div>

                  {/* Highlights */}
                  <div className="space-y-2.5 pt-2 border-t border-[#f0f1f2]">
                    <div className="text-[11px] font-bold uppercase tracking-wider text-[#42526e]">
                      Included Features:
                    </div>
                    <ul className="space-y-2">
                      {tier.features.map((feat: string, i: number) => (
                        <li key={i} className="text-[13px] text-[#292a2e] flex items-start gap-2">
                          <Check className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                          <span>{feat}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>

                <div className="pt-6 border-t border-[#f0f1f2] mt-6">
                  <Button
                    href={tier.ctaHref}
                    variant={tier.popular ? "primary" : "outline"}
                    size="md"
                    className="w-full"
                  >
                    {tier.ctaText}
                  </Button>
                </div>
              </div>
            );
          })}
        </div>

        {/* Detailed Matrix Section */}
        <div className="space-y-8 pt-8">
          <EditorialHeadline
            title="Comprehensive Feature Comparison"
            highlightWord="Comparison"
            description="Side-by-side technical and educational capabilities across our student and institutional editions."
            align="left"
          />

          <div className="bg-white rounded-[20px] p-6 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px]">
            <PlanComparisonTable />
          </div>
        </div>

        {/* Security / Compliance Guarantee */}
        <div className="p-8 rounded-[20px] bg-[#f0f1f2] text-[#101214] flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="space-y-1">
            <div className="flex items-center gap-2">
              <ShieldCheck className="w-5 h-5 text-[#1868db]" />
              <h3 className="font-medium text-lg">Institutional Security & DPDP Compliance</h3>
            </div>
            <p className="text-[14px] text-[#42526e] max-w-2xl font-normal">
              Every paid institutional license includes signed Data Processing Agreements, row-level tenant
              isolation, encrypted backups in Indian data centers, and dedicated deployment support.
            </p>
          </div>
          <Button href="/school-demo" variant="primary" size="md">
            Schedule Institutional Demo
          </Button>
        </div>
      </div>
    </div>
  );
}
