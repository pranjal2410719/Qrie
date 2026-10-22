import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { siteConfig } from "@/lib/seo/siteConfig";
import {
  Building2,
  Mail,
  Phone,
  FileCheck,
  CheckCircle2,
  ArrowRight,
  ShieldCheck,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Contact Institutional Sales — Qrie AI School Deployments",
  description:
    "Connect with Qrie's institutional partnerships and enterprise sales team to arrange multi-branch school deployments, custom curriculum mapping, and enterprise SLAs.",
  alternates: {
    canonical: "https://qrie.ai/contact/sales",
  },
};

export default function SalesContactPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs
          items={[
            { label: "Contact", href: "/contact" },
            { label: "Institutional Sales", href: "/contact/sales" },
          ]}
        />

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          <div className="lg:col-span-7 space-y-6">
            <Badge variant="primary" size="md">
              <Building2 className="w-3.5 h-3.5 text-sky-600" />
              <span>Institutional Partnerships</span>
            </Badge>

            <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
              Institutional Sales & Multi-School Partnerships
            </h1>

            <p className="text-base text-slate-600 leading-relaxed font-normal">
              For school trusts, multi-branch foundations (20+ campuses), state educational boards, and
              academic publishing partners seeking tailored technology agreements.
            </p>

            <div className="space-y-4 pt-4 border-t border-slate-100 text-xs text-slate-600">
              <div className="flex items-start gap-3">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                <span>Dedicated Enterprise Account Director and deployment team.</span>
              </div>
              <div className="flex items-start gap-3">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                <span>Custom ERP integration (Google Workspace, Microsoft Entra, SAML 2.0).</span>
              </div>
              <div className="flex items-start gap-3">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                <span>Contractual 99.9% uptime SLA with 1-hour critical response desk.</span>
              </div>
            </div>

            <div className="pt-4 flex flex-wrap gap-3">
              <Button href="/get-a-quote" variant="primary" size="md">
                Get an Official Quotation
              </Button>
              <Button href="/school-demo" variant="outline" size="md">
                Book School Walkthrough
              </Button>
            </div>
          </div>

          <div className="lg:col-span-5 bg-slate-900 text-white p-8 rounded-3xl border border-slate-800 space-y-6">
            <h2 className="text-xl font-bold">Direct Institutional Desk</h2>

            <div className="space-y-4 text-xs text-slate-300">
              <div className="flex items-center gap-3">
                <Mail className="w-4 h-4 text-sky-400" />
                <div>
                  <span className="block text-slate-400">Institutional Inquiries:</span>
                  <a href={`mailto:${siteConfig.salesEmail}`} className="text-white font-bold hover:underline">
                    {siteConfig.salesEmail}
                  </a>
                </div>
              </div>

              <div className="flex items-center gap-3">
                <Phone className="w-4 h-4 text-emerald-400" />
                <div>
                  <span className="block text-slate-400">Bangalore Partnerships Office:</span>
                  <span className="text-white font-bold">{siteConfig.phone}</span>
                </div>
              </div>
            </div>

            <div className="pt-4 border-t border-slate-800 text-xs text-slate-400 flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Full compliance with India DPDP Act 2023 & institutional governance.</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
