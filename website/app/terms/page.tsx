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
      <div className="max-w-[960px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Terms of Service", href: "/terms" }]} />

        <div className="space-y-4 border-b border-[#f0f1f2] pb-8">
          <Badge variant="primary" size="md">
            <span>Legal Agreement</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Terms of Service
          </h1>
          <p className="text-[13px] text-[#42526e] font-normal">
            Last updated: October 2026 • Governing Law: Jurisdiction of Bengaluru, Karnataka, India
          </p>
        </div>

        <div className="space-y-8 text-base text-[#292a2e] leading-[1.7] font-normal">
          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">1. Acceptance of Terms</h2>
            <p>
              By accessing the Qrie AI website, downloading the Qrie Student Android App, or using any associated
              educational services provided by {siteConfig.legalName}, you agree to be bound by these Terms of Service.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">2. Permitted Educational Use</h2>
            <p>
              Qrie AI is licensed exclusively for personal educational study and school instruction. Users agree not to:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-[14px]">
              <li>Reverse engineer, decompile, or extract the underlying LAM Bayesian model weights or proprietary algorithms.</li>
              <li>Scrape, bulk-extract, or systematically redistribute curriculum question banks.</li>
              <li>Impersonate institutional faculty or submit forged academic attendance records.</li>
            </ul>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">3. Institutional School Contracts</h2>
            <p>
              For schools and educational trusts deploying Qrie across classrooms, the specific terms, student headcounts,
              billing schedules, and SLA commitments detailed in the executed Institutional Proposal supersede conflicting
              general website terms.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">4. Jurisdiction</h2>
            <p>
              These terms are governed by and construed in accordance with the laws of India. Any disputes arising
              hereunder shall be subject to the exclusive jurisdiction of the competent courts in Bengaluru, Karnataka.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
