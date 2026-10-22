import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { SchoolAppsShowcase } from "@/components/sections/SchoolAppsShowcase";
import {
  School,
  ShieldCheck,
  Users,
  CheckCircle2,
  FileSpreadsheet,
  ArrowRight,
  Server,
  Layers,
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "For Schools", href: "/schools" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <School className="w-3.5 h-3.5 text-sky-600" />
            <span>Institutional Software</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            School Operating System for Modern Classrooms
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
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
        <div className="p-8 sm:p-10 rounded-3xl bg-slate-50 border border-slate-200 space-y-8">
          <div className="max-w-3xl space-y-2">
            <span className="text-xs font-bold text-sky-600 uppercase tracking-wider">
              Implementation & Setup
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
              Turnkey School Onboarding in 2 to 3 Weeks
            </h2>
            <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
              We understand school administrative burdens. Our deployment specialists manage the technical
              onboarding so teachers can begin using diagnostic tools effortlessly.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="p-6 rounded-2xl bg-white border border-slate-200/90 shadow-2xs space-y-2">
              <span className="text-xs font-bold text-sky-600">Step 1</span>
              <h3 className="font-bold text-sm text-slate-900">Tenant Setup & Security</h3>
              <p className="text-xs text-slate-600 leading-relaxed">
                Dedicated cryptographic realm created in PostgreSQL with multi-tenant Row-Level Security.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-white border border-slate-200/90 shadow-2xs space-y-2">
              <span className="text-xs font-bold text-sky-600">Step 2</span>
              <h3 className="font-bold text-sm text-slate-900">Roster Sync (ERP / CSV)</h3>
              <p className="text-xs text-slate-600 leading-relaxed">
                Automated student, teacher, section, and subject allocation imported directly from spreadsheets.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-white border border-slate-200/90 shadow-2xs space-y-2">
              <span className="text-xs font-bold text-sky-600">Step 3</span>
              <h3 className="font-bold text-sm text-slate-900">Custom Branding</h3>
              <p className="text-xs text-slate-600 leading-relaxed">
                Your school crest, colors, and motto configured into student and teacher Android apps.
              </p>
            </div>

            <div className="p-6 rounded-2xl bg-white border border-slate-200/90 shadow-2xs space-y-2">
              <span className="text-xs font-bold text-sky-600">Step 4</span>
              <h3 className="font-bold text-sm text-slate-900">Faculty Enablement</h3>
              <p className="text-xs text-slate-600 leading-relaxed">
                Interactive 2-day on-campus or virtual workshop certifying teachers on struggle heatmaps.
              </p>
            </div>
          </div>
        </div>

        {/* Security & Data Compliance */}
        <div className="p-8 sm:p-10 rounded-3xl bg-slate-900 text-white space-y-6">
          <div className="flex items-center gap-2 text-emerald-400 text-xs font-bold uppercase tracking-wider">
            <ShieldCheck className="w-5 h-5" />
            <span>Institutional Security Guarantee</span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight">
            Strict Multi-Tenant Isolation & India DPDP Act 2023 Compliance
          </h2>
          <p className="text-xs sm:text-sm text-slate-300 max-w-3xl leading-relaxed">
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
