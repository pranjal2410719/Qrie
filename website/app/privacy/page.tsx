import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Badge } from "@/components/ui/Badge";
import { ShieldCheck } from "lucide-react";
import { siteConfig } from "@/lib/seo/siteConfig";

export const metadata: Metadata = {
  title: "Privacy Policy & Student Data Protection — Qrie AI",
  description:
    "Qrie AI's privacy policy and student data governance in full compliance with India's Digital Personal Data Protection (DPDP) Act 2023.",
  alternates: {
    canonical: "https://qrie.ai/privacy",
  },
};

export default function PrivacyPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[960px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Privacy Policy", href: "/privacy" }]} />

        <div className="space-y-4 border-b border-[#f0f1f2] pb-8">
          <Badge variant="primary" size="md">
            <ShieldCheck className="w-3.5 h-3.5 text-[#1868db]" />
            <span>DPDP Act 2023 Compliant</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Privacy Policy & Student Data Governance
          </h1>
          <p className="text-[13px] text-[#42526e] font-normal">
            Last updated: October 2026 • Effective Date: January 1, 2026
          </p>
        </div>

        <div className="space-y-8 text-base text-[#292a2e] leading-[1.7] font-normal">
          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">1. Commitment to Student Privacy</h2>
            <p>
              At {siteConfig.legalName} (&quot;Qrie&quot;, &quot;we&quot;, &quot;us&quot;), protecting the privacy and personal data of
              students, parents, and educators is our highest operational commitment. We adhere strictly
              to the principles outlined in India&apos;s <strong>Digital Personal Data Protection (DPDP) Act, 2023</strong>.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">2. Student Data We Collect</h2>
            <p>We collect only the minimal data required to deliver educational services:</p>
            <ul className="list-disc pl-5 space-y-1.5 text-[14px]">
              <li><strong>Academic Profile:</strong> Student first name, enrolled grade/class, board affiliation (e.g. CBSE/ICSE), and school identifier.</li>
              <li><strong>Cognitive Learning Evidence:</strong> Question responses, symbolic mathematical derivations, hint consumption counts, and study streak timestamps.</li>
              <li><strong>Technical Metadata:</strong> Operating system version and crash reports for low-bandwidth Android performance optimization.</li>
            </ul>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">3. Absolute Prohibitions</h2>
            <div className="p-5 rounded-[12px] bg-[#f0f1f2] border border-[#f0f1f2] text-[#101214] text-[14px] space-y-1.5">
              <div>🚫 We NEVER sell student data or learning profiles to advertising brokers.</div>
              <div>🚫 We NEVER serve behavioral advertisements or commercial third-party marketing inside our apps.</div>
              <div>🚫 We NEVER use student queries or homework submissions to train publicly accessible AI models.</div>
            </div>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">4. Data Residency & Cryptographic Isolation</h2>
            <p>
              All student records and school databases are hosted within certified sovereign data centers located in
              India (Bengaluru / Mumbai). Every school is provisioned with row-level cryptographic tenant isolation.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">5. Contact Data Protection Officer</h2>
            <p>
              For inquiries regarding student records, parental data deletion requests, or compliance audits, contact
              our Data Protection Officer at:
            </p>
            <div className="p-4 rounded-[12px] bg-[#f0f1f2] text-[14px]">
              <strong>DPO Office:</strong> privacy@qrie.ai • {siteConfig.legalName}, Bellandur, Bengaluru, Karnataka 560103
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
