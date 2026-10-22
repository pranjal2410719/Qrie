import React from "react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { resourcesData } from "@/lib/data/resources";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { generateArticleSchema } from "@/lib/seo/jsonLd";
import { Clock, User, Calendar, ArrowLeft, ArrowRight, Share2 } from "lucide-react";

export async function generateStaticParams() {
  return resourcesData.map((art) => ({
    slug: art.slug,
  }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const article = resourcesData.find((a) => a.slug === slug);
  if (!article) return {};

  return {
    title: `${article.title} — Qrie AI Knowledge Hub`,
    description: article.excerpt,
    alternates: {
      canonical: `https://qrie.ai/resources/${article.slug}`,
    },
  };
}

export default async function ResourceArticlePage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const article = resourcesData.find((a) => a.slug === slug);

  if (!article) {
    notFound();
  }

  const jsonLd = generateArticleSchema({
    headline: article.title,
    description: article.excerpt,
    url: `/resources/${article.slug}`,
    publishedAt: article.publishedAt,
    authorName: article.author.name,
  });

  return (
    <article className="py-12 bg-white">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs
          items={[
            { label: "Resources", href: "/resources" },
            { label: article.title, href: `/resources/${article.slug}` },
          ]}
        />

        {/* Article Header */}
        <header className="space-y-4 border-b border-slate-100 pb-8">
          <Badge variant="primary" size="md">
            {article.category.replace("-", " ").toUpperCase()}
          </Badge>

          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            {article.title}
          </h1>

          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            {article.excerpt}
          </p>

          <div className="flex flex-wrap items-center gap-6 pt-2 text-xs text-slate-500">
            <div className="flex items-center gap-2">
              <User className="w-4 h-4 text-slate-400" />
              <span className="font-semibold text-slate-800">{article.author.name}</span>
              <span className="text-slate-400">({article.author.role})</span>
            </div>
            <div className="flex items-center gap-1.5">
              <Calendar className="w-4 h-4 text-slate-400" />
              <span>{article.publishedAt}</span>
            </div>
            <div className="flex items-center gap-1.5">
              <Clock className="w-4 h-4 text-slate-400" />
              <span>{article.readTime}</span>
            </div>
          </div>
        </header>

        {/* Body Paragraphs */}
        <div className="space-y-6 text-sm sm:text-base text-slate-700 leading-relaxed font-normal">
          {article.content.map((paragraph, idx) => (
            <p key={idx}>{paragraph}</p>
          ))}
        </div>

        {/* Tags */}
        <div className="pt-6 border-t border-slate-100 flex flex-wrap gap-2">
          {article.tags.map((tag) => (
            <span
              key={tag}
              className="px-3 py-1 rounded-full bg-slate-100 text-slate-700 text-xs font-semibold"
            >
              #{tag}
            </span>
          ))}
        </div>

        {/* Bottom Banner */}
        <div className="p-8 rounded-3xl bg-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-lg font-bold">See LAM in Action in Classrooms</h3>
            <p className="text-xs text-slate-400">
              Schedule a personalized school demonstration or explore our platform whitepaper.
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Button href="/school-demo" variant="white" size="md">
              Book School Demo
            </Button>
            <Button href="/resources" variant="outline" size="md" className="border-slate-700 text-white bg-slate-800 hover:bg-slate-700">
              Back to Resources
            </Button>
          </div>
        </div>
      </div>
    </article>
  );
}
