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
  Cpu,
  Layers,
  ShieldCheck,
  Smartphone,
  ArrowRight,
  School,
  Lock,
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
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
              {product.badge && <Badge variant="accent">{product.badge}</Badge>}
            </div>

            <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
              {product.name}
            </h1>
            <p className="text-xl font-medium text-slate-600 leading-relaxed">
              {product.tagline}
            </p>
            <p className="text-sm text-slate-600 leading-relaxed max-w-3xl">
              {product.longDescription}
            </p>

            {/* Target Audience Pill */}
            <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200 text-xs text-slate-700">
              <strong className="text-slate-900 font-semibold">Target Audience:</strong>{" "}
              {product.targetAudience}
            </div>
          </div>

          {/* Pricing & CTA Card */}
          <div className="lg:col-span-4 bg-slate-50 rounded-3xl p-6 sm:p-8 border border-slate-200 space-y-6">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-slate-400">
                Licensing & Pricing
              </span>
              {product.startingPrice ? (
                <div className="mt-1">
                  <div className="text-3xl font-black text-slate-900">
                    ₹{product.startingPrice.toLocaleString("en-IN")}
                  </div>
                  <span className="text-xs text-slate-500">
                    Billed {product.billingInterval} • Includes verified updates
                  </span>
                </div>
              ) : (
                <div className="mt-1">
                  <div className="text-2xl font-bold text-slate-900">
                    Institutional Quote
                  </div>
                  <span className="text-xs text-slate-500">
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

            <div className="text-[11px] text-slate-400 space-y-2 border-t border-slate-200/80 pt-4">
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
        <div className="space-y-6 border-t border-slate-100 pt-12">
          <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900">
            Key Capabilities & Features
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {product.features.map((feat, i) => (
              <div key={i} className="p-6 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-2">
                <h3 className="font-bold text-base text-slate-900">{feat.title}</h3>
                <p className="text-xs text-slate-600 leading-relaxed">{feat.description}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Technical Specifications */}
        <div className="space-y-6 border-t border-slate-100 pt-12">
          <h2 className="text-2xl sm:text-3xl font-extrabold text-slate-900">
            Technical Specifications & Runtime
          </h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {product.technicalSpecs.map((spec, i) => (
              <div key={i} className="p-4 rounded-xl border border-slate-200 bg-white space-y-1">
                <div className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                  {spec.label}
                </div>
                <div className="text-xs font-semibold text-slate-800">{spec.value}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
