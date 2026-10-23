import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { servicesData } from "@/lib/data/services";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Wrench,
  BookOpen,
  GraduationCap,
  Server,
  CheckCircle, School,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie AI Services Catalogue — Onboarding, Curriculum Mapping & Teacher Enablement",
  description:
    "Explore Qrie's institutional implementation services: School Onboarding & SIS Deployment, Curriculum Mapping, Teacher AI Pedagogy Workshops, and Enterprise SLA.",
  alternates: {
    canonical: "https://qrie.ai/services",
  },
};

export default function ServicesPage() {
  const getCategoryIcon = (category: string) => {
    switch (category) {
      case "implementation":
        return <Wrench className="w-5 h-5 text-[#1868db]" />;
      case "curriculum":
        return <BookOpen className="w-5 h-5 text-[#1868db]" />;
      case "training":
        return <GraduationCap className="w-5 h-5 text-[#1868db]" />;
      case "enterprise":
        return <Server className="w-5 h-5 text-[#1868db]" />;
      default:
        return <Wrench className="w-5 h-5 text-[#1868db]" />;
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Services Catalogue", href: "/services" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>Implementation & Support</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Institutional Services & Enablement
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Turnkey deployment packages, syllabus digitization, teacher training cohorts, and dedicated
            enterprise support ensuring your school achieves measurable educational impact.
          </p>
        </div>

        {/* Services Grid: 20px radius cards, subtle micro-shadow */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
          {servicesData.map((srv) => (
            <div
              key={srv.id}
              className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] hover:border-[#b7b9be] transition-colors flex flex-col justify-between"
            >
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <div className="w-10 h-10 rounded-[10px] bg-[#f0f1f2] flex items-center justify-center">
                    {getCategoryIcon(srv.category)}
                  </div>
                  {srv.badge && (
                    <span className="text-[11px] font-medium px-2.5 py-0.5 rounded-full bg-[#e3fcef] text-[#006644]">
                      {srv.badge}
                    </span>
                  )}
                </div>

                <div>
                  <h2 className="text-2xl font-medium tracking-[0.012em] text-[#101214] mb-1">
                    {srv.name}
                  </h2>
                  <p className="text-[13px] font-medium text-[#1868db] mb-2">{srv.tagline}</p>
                  <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">{srv.description}</p>
                </div>

                <div className="space-y-2 pt-2 border-t border-[#f0f1f2]">
                  <div className="text-[11px] font-bold uppercase tracking-wider text-[#42526e]">
                    Scope & Deliverables
                  </div>
                  <ul className="space-y-1.5 text-[13px] text-[#292a2e] font-normal">
                    {srv.scopeAndDeliverables.slice(0, 3).map((d, i) => (
                      <li key={i} className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                        <span>{d}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              <div className="pt-6 border-t border-[#f0f1f2] mt-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                  <span className="text-[11px] text-[#42526e]">Timeline / Scope</span>
                  <div className="text-[14px] font-medium text-[#101214]">{srv.timeline}</div>
                </div>

                <div className="flex items-center gap-2.5 w-full sm:w-auto">
                  <Link
                    href={`/services/${srv.slug}`}
                    className="px-4 py-2 text-[13px] font-medium text-[#101214] hover:text-[#1868db] border border-[#101214] rounded-[28px] hover:bg-[#f0f1f2] transition-colors text-center w-full sm:w-auto"
                  >
                    View Details
                  </Link>
                  <Button
                    href={`/get-a-quote?service=${srv.slug}`}
                    variant="primary"
                    size="sm"
                    className="w-full sm:w-auto"
                  >
                    Request Quote
                  </Button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
