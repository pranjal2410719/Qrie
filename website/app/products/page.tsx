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
        return <Smartphone className="w-5 h-5 text-[#1868db]" />;
      case "ai-engine":
        return <Cpu className="w-5 h-5 text-[#1868db]" />;
      case "school-platform":
        return <School className="w-5 h-5 text-[#1868db]" />;
      case "assessment":
        return <ClipboardCheck className="w-5 h-5 text-[#1868db]" />;
      default:
        return <Cpu className="w-5 h-5 text-[#1868db]" />;
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Products Catalogue", href: "/products" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>Verified Software Offerings</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Qrie Products Catalogue
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Explore our ecosystem of verified software, mobile clients, cognitive AI engines, and
            institutional school operating systems.
          </p>
        </div>

        {/* Product Cards Grid: 20px radius cards, subtle micro-shadow */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
          {productsData.map((prod) => (
            <div
              key={prod.id}
              className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] hover:border-[#b7b9be] transition-colors flex flex-col justify-between"
            >
              <div className="space-y-6">
                <div className="flex items-center justify-between">
                  <div className="w-10 h-10 rounded-[10px] bg-[#f0f1f2] flex items-center justify-center">
                    {getCategoryIcon(prod.category)}
                  </div>
                  {prod.badge && (
                    <span className="text-[11px] font-medium px-2.5 py-0.5 rounded-full bg-[#e9f2fe] text-[#1868db]">
                      {prod.badge}
                    </span>
                  )}
                </div>

                <div>
                  <h2 className="text-2xl font-medium tracking-[0.012em] text-[#101214] mb-1">
                    {prod.name}
                  </h2>
                  <p className="text-[13px] font-medium text-[#1868db] mb-2">{prod.tagline}</p>
                  <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">{prod.description}</p>
                </div>

                <div className="space-y-2 pt-2 border-t border-[#f0f1f2]">
                  <div className="text-[11px] font-bold uppercase tracking-wider text-[#42526e]">
                    Key Highlights
                  </div>
                  <ul className="space-y-1.5 text-[13px] text-[#292a2e] font-normal">
                    {prod.highlights.slice(0, 3).map((h, i) => (
                      <li key={i} className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                        <span>{h}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              <div className="pt-6 border-t border-[#f0f1f2] mt-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                  {prod.startingPrice ? (
                    <div>
                      <span className="text-[11px] text-[#42526e]">Starting from</span>
                      <div className="text-xl font-medium tracking-[0.012em] text-[#101214]">
                        ₹{prod.startingPrice.toLocaleString("en-IN")}{" "}
                        <span className="text-[12px] font-normal text-[#42526e]">
                          /{prod.billingInterval}
                        </span>
                      </div>
                    </div>
                  ) : (
                    <div>
                      <span className="text-[11px] text-[#42526e]">Pricing</span>
                      <div className="text-base font-medium text-[#101214]">
                        Institutional Quotation
                      </div>
                    </div>
                  )}
                </div>

                <div className="flex items-center gap-2.5 w-full sm:w-auto">
                  <Link
                    href={`/products/${prod.slug}`}
                    className="px-4 py-2 text-[13px] font-medium text-[#101214] hover:text-[#1868db] border border-[#101214] rounded-[28px] hover:bg-[#f0f1f2] transition-colors text-center w-full sm:w-auto"
                  >
                    View Details
                  </Link>
                  <Button
                    href={prod.ctaHref}
                    variant={prod.canAddToCart ? "primary" : "outline"}
                    size="sm"
                    className="w-full sm:w-auto"
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
