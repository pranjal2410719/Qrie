import React from "react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { productsData } from "@/lib/data/products";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { generateProductSchema } from "@/lib/seo/jsonLd";
import {
  CheckCircle2,
  ShieldCheck,
  ArrowRight,
} from "lucide-react";

export async function generateStaticParams() {
  return productsData.map((prod) => ({
    slug: prod.slug,
  }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const product = productsData.find((p) => p.slug === slug);
  if (!product) return {};

  return {
    title: `${product.name} — Qrie AI Products`,
    description: product.description,
    alternates: {
      canonical: `https://qrie.ai/products/${product.slug}`,
    },
  };
}

export default async function ProductDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const product = productsData.find((p) => p.slug === slug);

  if (!product) {
    notFound();
  }

  const jsonLd = generateProductSchema({
    name: product.name,
    description: product.description,
    sku: product.id,
    price: product.startingPrice,
    currency: "INR",
  });

  return (
    <div className="py-12 bg-white">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs
          items={[
            { label: "Products", href: "/products" },
            { label: product.name, href: `/products/${product.slug}` },
          ]}
        />

        {/* Hero Header */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          <div className="lg:col-span-8 space-y-6">
            <div className="flex items-center gap-2">
              <Badge variant="primary" size="md">
                {product.availability}
              </Badge>
              {product.badge && <Badge variant="lavender">{product.badge}</Badge>}
            </div>

            <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
              {product.name}
            </h1>
            <p className="text-xl font-medium text-[#1868db] leading-relaxed">
              {product.tagline}
            </p>
            <p className="text-base text-[#42526e] leading-[1.6] max-w-3xl font-normal">
              {product.longDescription}
            </p>

            {/* Target Audience Pill */}
            <div className="p-4 rounded-[12px] bg-[#f0f1f2] text-[13px] text-[#292a2e] font-normal">
              <strong className="text-[#101214] font-semibold">Target Audience:</strong>{" "}
              {product.targetAudience}
            </div>
          </div>

          {/* Pricing & CTA Card: 20px radius card, subtle micro-shadow */}
          <div className="lg:col-span-4 bg-white rounded-[20px] p-6 sm:p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-6">
            <div>
              <span className="text-[12px] font-bold uppercase tracking-wider text-[#42526e]">
                Licensing & Pricing
              </span>
              {product.startingPrice ? (
                <div className="mt-1">
                  <div className="text-3xl font-medium tracking-[0.012em] text-[#101214]">
                    ₹{product.startingPrice.toLocaleString("en-IN")}
                  </div>
                  <span className="text-[12px] text-[#42526e] font-normal">
                    Billed {product.billingInterval} • Verified Updates
                  </span>
                </div>
              ) : (
                <div className="mt-1">
                  <div className="text-2xl font-medium text-[#101214]">
                    Institutional Quote
                  </div>
                  <span className="text-[12px] text-[#42526e] font-normal">
                    Tailored to school student headcount and training
                  </span>
                </div>
              )}
            </div>

            <Button
              href={product.ctaHref}
              variant="primary"
              size="lg"
              className="w-full"
              icon={<ArrowRight className="w-4 h-4" />}
            >
              {product.ctaText}
            </Button>

            <div className="text-[12px] text-[#42526e] space-y-2 border-t border-[#f0f1f2] pt-4 font-normal">
              <div className="flex items-center gap-2 text-emerald-700 font-semibold">
                <ShieldCheck className="w-4 h-4" />
                <span>Verified Qrie Architecture</span>
              </div>
              <p>
                Strict DPDP Act 2023 compliance, no public model training on student queries.
              </p>
            </div>
          </div>
        </div>

        {/* Feature Breakdown */}
        <div className="space-y-6 border-t border-[#f0f1f2] pt-12">
          <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
            Key Capabilities & Features
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {product.features.map((feat, i) => (
              <div
                key={i}
                className="p-6 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-2"
              >
                <h3 className="font-medium text-[16px] text-[#101214]">{feat.title}</h3>
                <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">{feat.description}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Technical Specifications */}
        <div className="space-y-6 border-t border-[#f0f1f2] pt-12">
          <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em] text-[#101214]">
            Technical Specifications & Runtime
          </h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {product.technicalSpecs.map((spec, i) => (
              <div
                key={i}
                className="p-4 rounded-[12px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-1"
              >
                <div className="text-[11px] font-bold uppercase tracking-wider text-[#42526e]">
                  {spec.label}
                </div>
                <div className="text-[13px] font-medium text-[#101214]">{spec.value}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
