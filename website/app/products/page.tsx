import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { productsData } from "@/lib/data/products";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Smartphone,
  Cpu,
  School,
  ClipboardCheck,
  ArrowRight,
  CheckCircle,
} from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie AI Products Catalogue — Software, AI Engine & Mobile Apps",
  description:
    "Explore Qrie's verified products: Qrie AI Student App, Learning Adaptation Model (LAM) API, School Operating System, and Diagnostic Assessment Engine.",
  alternates: {
    canonical: "https://qrie.ai/products",
  },
};

export default function ProductsPage() {
  const getCategoryIcon = (category: string) => {
    switch (category) {
      case "mobile-app":
        return <Smartphone className="w-5 h-5 text-sky-600" />;
      case "ai-engine":
        return <Cpu className="w-5 h-5 text-indigo-600" />;
      case "school-platform":
        return <School className="w-5 h-5 text-emerald-600" />;
      case "assessment":
        return <ClipboardCheck className="w-5 h-5 text-purple-600" />;
      default:
        return <Cpu className="w-5 h-5 text-sky-600" />;
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Products Catalogue", href: "/products" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>Verified Software Offerings</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Qrie Products Catalogue
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            Explore our ecosystem of verified software, mobile clients, cognitive AI engines, and
            institutional school operating systems.
          </p>
        </div>

        {/* Product Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
          {productsData.map((prod) => (
            <div
              key={prod.id}
              className="p-8 rounded-3xl border border-slate-200/90 bg-white hover:border-slate-300 hover:shadow-md transition-all duration-200 flex flex-col justify-between"
            >
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <div className="w-12 h-12 rounded-2xl bg-slate-50 border border-slate-200 flex items-center justify-center shadow-2xs">
                    {getCategoryIcon(prod.category)}
                  </div>
                  {prod.badge && (
                    <span className="text-xs font-bold px-3 py-1 rounded-full bg-sky-50 text-sky-700 border border-sky-200">
                      {prod.badge}
                    </span>
                  )}
                </div>

                <div>
                  <h2 className="text-2xl font-bold text-slate-900 mb-1">{prod.name}</h2>
                  <p className="text-xs font-medium text-slate-500 mb-3">{prod.tagline}</p>
                  <p className="text-xs text-slate-600 leading-relaxed">{prod.description}</p>
                </div>

                <div className="space-y-2 pt-2 border-t border-slate-100">
                  <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                    Key Highlights
                  </div>
                  <ul className="space-y-1.5 text-xs text-slate-700">
                    {prod.highlights.slice(0, 3).map((h, i) => (
                      <li key={i} className="flex items-start gap-2">
                        <CheckCircle className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
                        <span>{h}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              <div className="pt-6 border-t border-slate-100 mt-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                  {prod.startingPrice ? (
                    <div>
                      <span className="text-xs text-slate-400">Starting from</span>
                      <div className="text-xl font-black text-slate-900">
                        ₹{prod.startingPrice.toLocaleString("en-IN")}{" "}
                        <span className="text-xs font-normal text-slate-500">
                          /{prod.billingInterval}
                        </span>
                      </div>
                    </div>
                  ) : (
                    <div>
                      <span className="text-xs text-slate-400">Pricing</span>
                      <div className="text-base font-bold text-slate-800">
                        Institutional Quotation
                      </div>
                    </div>
                  )}
                </div>

                <div className="flex items-center gap-2.5 w-full sm:w-auto">
                  <Link
                    href={`/products/${prod.slug}`}
                    className="px-4 py-2 text-xs font-bold text-slate-700 hover:text-slate-900 border border-slate-200 rounded-xl hover:bg-slate-50 transition-colors text-center w-full sm:w-auto"
                  >
                    View Details
                  </Link>
                  <Button
                    href={prod.ctaHref}
                    variant={prod.canAddToCart ? "primary" : "secondary"}
                    size="sm"
                    className="w-full sm:w-auto text-xs"
                  >
                    {prod.ctaText}
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
