import React from "react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { servicesData } from "@/lib/data/services";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  CheckCircle2,
  Clock,
  Users,
  ShieldCheck,
  ArrowRight,
  FileText,
} from "lucide-react";

export async function generateStaticParams() {
  return servicesData.map((srv) => ({
    slug: srv.slug,
  }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const service = servicesData.find((s) => s.slug === slug);
  if (!service) return {};

  return {
    title: `${service.name} — Qrie AI Services`,
    description: service.description,
    alternates: {
      canonical: `https://qrie.ai/services/${service.slug}`,
    },
  };
}

export default async function ServiceDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const service = servicesData.find((s) => s.slug === slug);

  if (!service) {
    notFound();
  }

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs
          items={[
            { label: "Services", href: "/services" },
            { label: service.name, href: `/services/${service.slug}` },
          ]}
        />

        {/* Hero */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          <div className="lg:col-span-8 space-y-6">
            <div className="flex items-center gap-2">
              <Badge variant="primary" size="md">
                Institutional Service
              </Badge>
              {service.badge && <Badge variant="success">{service.badge}</Badge>}
            </div>

            <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
              {service.name}
            </h1>
            <p className="text-xl font-medium text-slate-600 leading-relaxed">
              {service.tagline}
            </p>
            <p className="text-sm text-slate-600 leading-relaxed max-w-3xl">
              {service.description}
            </p>

            <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200 text-xs text-slate-700">
              <strong className="text-slate-900 font-semibold">Intended Audience:</strong>{" "}
              {service.targetAudience}
            </div>
          </div>

          {/* Quotation Action Card */}
          <div className="lg:col-span-4 bg-slate-50 rounded-3xl p-6 sm:p-8 border border-slate-200 space-y-6">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-slate-400">
                Engagement Model
              </span>
              <div className="text-xl font-bold text-slate-900 mt-1">
                {service.pricingModel}
              </div>
              {service.startingEstimate && (
                <div className="text-xs text-slate-500 mt-1">
                  Estimated baseline: <strong className="text-slate-800">{service.startingEstimate}</strong>
                </div>
              )}
            </div>

            <div className="space-y-2 text-xs text-slate-600 border-t border-slate-200/80 pt-4">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4 text-sky-600 shrink-0" />
                <span>
                  <strong>Timeline:</strong> {service.timeline}
                </span>
              </div>
            </div>

            <Button
              href={`/get-a-quote?service=${service.slug}`}
              variant="primary"
              size="lg"
              className="w-full"
              icon={<ArrowRight className="w-4 h-4" />}
            >
              {service.ctaText}
            </Button>
          </div>
        </div>

        {/* Scope & Deliverables */}
        <div className="space-y-6 border-t border-slate-100 pt-12">
          <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900">
            Scope & Deliverables
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {service.scopeAndDeliverables.map((d, i) => (
              <div key={i} className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 flex items-start gap-3">
                <CheckCircle2 className="w-5 h-5 text-emerald-600 shrink-0 mt-0.5" />
                <span className="text-xs text-slate-700 leading-relaxed">{d}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Customer Responsibilities */}
        <div className="space-y-6 border-t border-slate-100 pt-12">
          <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900">
            Customer Prerequisites & Responsibilities
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {service.customerResponsibilities.map((r, i) => (
              <div key={i} className="p-5 rounded-2xl bg-white border border-slate-200 flex items-start gap-3">
                <FileText className="w-5 h-5 text-indigo-600 shrink-0 mt-0.5" />
                <span className="text-xs text-slate-700 leading-relaxed">{r}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
