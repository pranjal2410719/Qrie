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
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
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

            <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
              {service.name}
            </h1>
            <p className="text-xl font-medium text-[#1868db] leading-relaxed">
              {service.tagline}
            </p>
            <p className="text-base text-[#42526e] leading-[1.6] max-w-3xl font-normal">
              {service.description}
            </p>

            <div className="p-4 rounded-[12px] bg-[#f0f1f2] text-[13px] text-[#292a2e] font-normal">
              <strong className="text-[#101214] font-semibold">Intended Audience:</strong>{" "}
              {service.targetAudience}
            </div>
          </div>

          {/* Quotation Action Card: 20px radius card, subtle micro-shadow */}
          <div className="lg:col-span-4 bg-white rounded-[20px] p-6 sm:p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-6">
            <div>
              <span className="text-[12px] font-bold uppercase tracking-wider text-[#42526e]">
                Engagement Model
              </span>
              <div className="text-xl font-medium text-[#101214] mt-1 tracking-[0.012em]">
                {service.pricingModel}
              </div>
              {service.startingEstimate && (
                <div className="text-[13px] text-[#42526e] mt-1 font-normal">
                  Estimated baseline: <strong className="text-[#292a2e]">{service.startingEstimate}</strong>
                </div>
              )}
            </div>

            <div className="space-y-2 text-[13px] text-[#42526e] border-t border-[#f0f1f2] pt-4 font-normal">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4 text-[#1868db] shrink-0" />
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
        <div className="space-y-6 border-t border-[#f0f1f2] pt-12">
          <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
            Scope & Deliverables
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {service.scopeAndDeliverables.map((d, i) => (
              <div
                key={i}
                className="p-5 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] flex items-start gap-3"
              >
                <CheckCircle2 className="w-5 h-5 text-[#1868db] shrink-0 mt-0.5" />
                <span className="text-[14px] text-[#292a2e] leading-[1.5] font-normal">{d}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Customer Responsibilities */}
        <div className="space-y-6 border-t border-[#f0f1f2] pt-12">
          <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
            Customer Prerequisites & Responsibilities
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {service.customerResponsibilities.map((r, i) => (
              <div
                key={i}
                className="p-5 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] flex items-start gap-3"
              >
                <FileText className="w-5 h-5 text-[#1868db] shrink-0 mt-0.5" />
                <span className="text-[14px] text-[#292a2e] leading-[1.5] font-normal">{r}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
