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
  ArrowRight,
  CheckCircle,
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
        return <Wrench className="w-5 h-5 text-sky-600" />;
      case "curriculum":
        return <BookOpen className="w-5 h-5 text-emerald-600" />;
      case "training":
        return <GraduationCap className="w-5 h-5 text-indigo-600" />;
      case "enterprise":
        return <Server className="w-5 h-5 text-purple-600" />;
      default:
        return <Wrench className="w-5 h-5 text-sky-600" />;
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Services Catalogue", href: "/services" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>Implementation & Support</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Institutional Services & Enablement
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            Turnkey deployment packages, syllabus digitization, teacher training cohorts, and dedicated
            enterprise support ensuring your school achieves measurable educational impact.
          </p>
        </div>

        {/* Services Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
          {servicesData.map((srv) => (
            <div
              key={srv.id}
              className="p-8 rounded-3xl border border-slate-200/90 bg-white hover:border-slate-300 hover:shadow-md transition-all duration-200 flex flex-col justify-between"
            >
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <div className="w-12 h-12 rounded-2xl bg-slate-50 border border-slate-200 flex items-center justify-center shadow-2xs">
                    {getCategoryIcon(srv.category)}
                  </div>
                  {srv.badge && (
                    <span className="text-xs font-bold px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200">
                      {srv.badge}
                    </span>
                  )}
                </div>

                <div>
                  <h2 className="text-2xl font-bold text-slate-900 mb-1">{srv.name}</h2>
                  <p className="text-xs font-medium text-slate-500 mb-3">{srv.tagline}</p>
                  <p className="text-xs text-slate-600 leading-relaxed">{srv.description}</p>
                </div>

                <div className="space-y-2 pt-2 border-t border-slate-100">
                  <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                    Scope & Deliverables
                  </div>
                  <ul className="space-y-1.5 text-xs text-slate-700">
                    {srv.scopeAndDeliverables.slice(0, 3).map((d, i) => (
                      <li key={i} className="flex items-start gap-2">
                        <CheckCircle className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
                        <span>{d}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              <div className="pt-6 border-t border-slate-100 mt-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                  <span className="text-xs text-slate-400">Timeline / Scope</span>
                  <div className="text-sm font-bold text-slate-900">{srv.timeline}</div>
                </div>

                <div className="flex items-center gap-2.5 w-full sm:w-auto">
                  <Link
                    href={`/services/${srv.slug}`}
                    className="px-4 py-2 text-xs font-bold text-slate-700 hover:text-slate-900 border border-slate-200 rounded-xl hover:bg-slate-50 transition-colors text-center w-full sm:w-auto"
                  >
                    View Details
                  </Link>
                  <Button
                    href={`/get-a-quote?service=${srv.slug}`}
                    variant="primary"
                    size="sm"
                    className="w-full sm:w-auto text-xs"
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
