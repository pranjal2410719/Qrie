import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { SchoolAppsShowcase } from "@/components/sections/SchoolAppsShowcase";
import {
  School,
  ShieldCheck,
  CheckCircle2,
  ArrowRight,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie School Software — Connected Apps for Teachers, Students & Administrators",
  description:
    "An end-to-end institutional software ecosystem for K-12 schools. Dual Android apps for staff and students, diagnostic homework grading, class struggle heatmaps, and secure multi-tenant portals.",
  alternates: {
    canonical: "https://qrie.ai/schools",
  },
};

export default function SchoolsPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Schools", href: "/schools" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <School className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Institutional Software</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            School Operating System for Modern Classrooms
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Qrie connects school leadership, teachers, and students through dedicated mobile applications
            and administrative web portals with multi-tenant row-level security.
          </p>
          <div className="flex flex-wrap gap-4 pt-2">
            <Button href="/school-demo" variant="primary" size="md">
              Book Institutional Demonstration
            </Button>
            <Button href="/get-a-quote?product=qrie-school-platform" variant="outline" size="md">
              Request School Proposal
            </Button>
          </div>
        </div>

        {/* Dual Android Apps Showcase */}
        <SchoolAppsShowcase />

        {/* Onboarding & SIS Integration */}
        <div className="p-8 sm:p-10 rounded-[20px] bg-[#f0f1f2]/60 border border-[#f0f1f2] space-y-8">
          <div className="max-w-3xl space-y-2">
            <span className="text-[12px] font-bold text-[#1868db] uppercase tracking-wider">
              Implementation & Setup
            </span>
            <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
              Turnkey School Onboarding in 2 to 3 Weeks
            </h2>
            <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
              We understand school administrative burdens. Our deployment specialists manage the technical
              onboarding so teachers can begin using diagnostic tools effortlessly.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="p-6 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-2">
              <span className="text-[12px] font-bold text-[#1868db]">Step 1</span>
              <h3 className="font-medium text-[16px] text-[#101214]">Tenant Setup & Security</h3>
              <p className="text-[13px] text-[#42526e] leading-[1.5] font-normal">
                Dedicated cryptographic realm created in PostgreSQL with multi-tenant Row-Level Security.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-2">
              <span className="text-[12px] font-bold text-[#1868db]">Step 2</span>
              <h3 className="font-medium text-[16px] text-[#101214]">Roster Sync (ERP / CSV)</h3>
              <p className="text-[13px] text-[#42526e] leading-[1.5] font-normal">
                Automated student, teacher, section, and subject allocation imported directly from school systems.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-2">
              <span className="text-[12px] font-bold text-[#1868db]">Step 3</span>
              <h3 className="font-medium text-[16px] text-[#101214]">School Customization</h3>
              <p className="text-[13px] text-[#42526e] leading-[1.5] font-normal">
                Your school crest, colors, and motto configured into student and teacher Android apps.
              </p>
            </div>

            <div className="p-6 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-2">
              <span className="text-[12px] font-bold text-[#1868db]">Step 4</span>
              <h3 className="font-medium text-[16px] text-[#101214]">Faculty Enablement</h3>
              <p className="text-[13px] text-[#42526e] leading-[1.5] font-normal">
                Interactive on-campus or virtual workshops certifying teachers on struggle heatmaps.
              </p>
            </div>
          </div>
        </div>

        {/* Security & Data Compliance: Inverted Dark Panel */}
        <div className="p-8 sm:p-10 rounded-[20px] bg-[#101214] text-white border border-[#292a2e] space-y-6">
          <div className="flex items-center gap-2 text-emerald-400 text-[12px] font-bold uppercase tracking-wider">
            <ShieldCheck className="w-5 h-5 text-emerald-400" />
            <span>Institutional Security Guarantee</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em]">
            Strict Multi-Tenant Isolation & India DPDP Act 2023 Compliance
          </h2>
          <p className="text-[14px] text-[#b7b9be] max-w-3xl leading-[1.6] font-normal">
            Every database query is constrained by verified school tenancy identifiers. Student performance
            data is encrypted at rest and in transit, isolated from all other institutions, and strictly
            never used to train public models or shared with commercial advertising brokers.
          </p>
          <div className="pt-2">
            <Button href="/privacy" variant="white" size="sm">
              Read Student Data Protection Policy
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
