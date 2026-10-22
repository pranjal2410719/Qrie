import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Badge } from "@/components/ui/Badge";
import { ShieldCheck, Lock, CheckCircle2 } from "lucide-react";
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
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Privacy Policy", href: "/privacy" }]} />

        <div className="space-y-4 border-b border-slate-100 pb-8">
          <Badge variant="success" size="md">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-600" />
            <span>DPDP Act 2023 Compliant</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight leading-tight">
            Privacy Policy & Student Data Governance
          </h1>
          <p className="text-xs text-slate-500">
            Last updated: October 2026 • Effective Date: January 1, 2026
          </p>
        </div>

        <div className="prose prose-slate max-w-none space-y-6 text-sm text-slate-700 leading-relaxed">
          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">1. Commitment to Student Privacy</h2>
            <p>
              At {siteConfig.legalName} (&quot;Qrie&quot;, &quot;we&quot;, &quot;us&quot;), protecting the privacy and personal data of
              students, parents, and educators is our highest operational commitment. We adhere strictly
              to the principles outlined in India&apos;s <strong>Digital Personal Data Protection (DPDP) Act, 2023</strong>.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">2. Student Data We Collect</h2>
            <p>We collect only the minimal data required to deliver educational services:</p>
            <ul className="list-disc pl-5 space-y-1 text-xs">
              <li><strong>Academic Profile:</strong> Student first name, enrolled grade/class, board affiliation (e.g. CBSE/ICSE), and school identifier.</li>
              <li><strong>Cognitive Learning Evidence:</strong> Question responses, symbolic mathematical derivations, hint consumption counts, and study streak timestamps.</li>
              <li><strong>Technical Metadata:</strong> Operating system version and crash reports for low-bandwidth Android performance optimization.</li>
            </ul>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">3. Absolute Prohibitions</h2>
            <div className="p-4 rounded-2xl bg-rose-50 border border-rose-200 text-rose-900 text-xs space-y-1.5 font-medium">
              <div>🚫 We NEVER sell student data or learning profiles to advertising brokers.</div>
              <div>🚫 We NEVER serve behavioral advertisements or commercial third-party marketing inside our apps.</div>
              <div>🚫 We NEVER use private student homework or question responses to train public generative foundational models.</div>
            </div>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">4. Multi-Tenant Architectural Isolation</h2>
            <p>
              Our database architecture implements strict <strong>PostgreSQL Row-Level Security (RLS)</strong>.
              Every query is cryptographically constrained by the institutional <code>school_id</code>.
              Data belonging to one school cannot be queried, leaked, or viewed by another institution.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-slate-900">5. Data Retention & Deletion</h2>
            <p>
              Schools and parents have the right to request full export or permanent cryptographic deletion
              of student records upon graduation or termination of institutional licenses. Requests can be
              directed to our Data Protection Officer at <a href={`mailto:${siteConfig.contactEmail}`} className="text-sky-600 underline">{siteConfig.contactEmail}</a>.
            </p>
          </section>
        </div>
      </div>
    </div>
  );
}
