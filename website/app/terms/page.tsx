import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Badge } from "@/components/ui/Badge";
import { siteConfig } from "@/lib/seo/siteConfig";

export const metadata: Metadata = {
  title: "Terms of Service — Qrie AI",
  description: "Terms and conditions governing the use of Qrie AI software, subscriptions, and institutional licenses.",
  alternates: {
    canonical: "https://qrie.ai/terms",
  },
};

export default function TermsPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Terms of Service", href: "/terms" }]} />

        <div className="space-y-4 border-b border-slate-100 pb-8">
          <Badge variant="primary" size="md">
            <span>Legal Agreement</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight leading-tight">
            Terms of Service
          </h1>
          <p className="text-xs text-slate-500">
            Last updated: October 2026 • Governing Law: Jurisdiction of Bengaluru, Karnataka, India
          </p>
        </div>

        <div className="prose prose-slate max-w-none space-y-6 text-sm text-slate-700 leading-relaxed">
          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">1. Acceptance of Terms</h2>
            <p>
              By accessing the Qrie AI website, downloading the Qrie Student Android App, or using any associated
              educational services provided by {siteConfig.legalName}, you agree to be bound by these Terms of Service.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">2. Permitted Educational Use</h2>
            <p>
              Qrie AI is licensed exclusively for personal educational study and school instruction. Users agree not to:
            </p>
            <ul className="list-disc pl-5 space-y-1 text-xs">
              <li>Reverse engineer, decompile, or extract the underlying LAM Bayesian model weights or proprietary algorithms.</li>
              <li>Scrape, bulk-extract, or systematically redistribute curriculum question banks.</li>
              <li>Impersonate institutional faculty or submit forged academic attendance records.</li>
            </ul>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">3. Institutional School Contracts</h2>
            <p>
              For schools and educational trusts deploying Qrie across classrooms, the specific terms, student headcounts,
              billing schedules, and SLA commitments detailed in the executed Institutional Proposal supersede conflicting
              general website terms.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">4. Cancellations & Refunds</h2>
            <p>
              Individual Student Pro monthly and annual subscriptions may be cancelled at any time from the customer
              orders portal. Pro-rated refunds for annual licenses are evaluated in accordance with standard Indian
              consumer protection guidelines. Institutional school pilot fees follow the terms agreed upon during contract execution.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">5. Limitation of Liability</h2>
            <p>
              While Qrie provides curriculum-aligned diagnostic tutoring, we do not guarantee specific examination scores
              or board ranks. Educational outcomes depend on individual student dedication and teacher instruction.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
