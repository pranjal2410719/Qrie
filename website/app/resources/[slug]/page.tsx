import React from "react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { resourcesData } from "@/lib/data/resources";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { generateArticleSchema } from "@/lib/seo/jsonLd";
import { Clock, User, Calendar } from "lucide-react";

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
      <div className="max-w-[960px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs
          items={[
            { label: "Resources", href: "/resources" },
            { label: article.title, href: `/resources/${article.slug}` },
          ]}
        />

        {/* Article Header */}
        <header className="space-y-4 border-b border-[#f0f1f2] pb-8">
          <Badge variant="primary" size="md">
            {article.category.replace("-", " ").toUpperCase()}
          </Badge>

          <h1 className="text-3xl sm:text-4xl lg:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            {article.title}
          </h1>

          <p className="text-lg text-[#42526e] leading-[1.6] font-normal">
            {article.excerpt}
          </p>

          <div className="flex flex-wrap items-center gap-6 pt-2 text-[13px] text-[#42526e] font-normal">
            <div className="flex items-center gap-2">
              <User className="w-4 h-4 text-[#1868db]" />
              <span className="font-medium text-[#101214]">{article.author.name}</span>
              <span className="text-[#42526e]">({article.author.role})</span>
            </div>
            <div className="flex items-center gap-1.5">
              <Calendar className="w-4 h-4 text-[#1868db]" />
              <span>{article.publishedAt}</span>
            </div>
            <div className="flex items-center gap-1.5">
              <Clock className="w-4 h-4 text-[#1868db]" />
              <span>{article.readTime}</span>
            </div>
          </div>
        </header>

        {/* Body Paragraphs */}
        <div className="space-y-6 text-base text-[#292a2e] leading-[1.7] font-normal">
          {article.content.map((paragraph, idx) => (
            <p key={idx}>{paragraph}</p>
          ))}
        </div>

        {/* Tags */}
        <div className="pt-6 border-t border-[#f0f1f2] flex flex-wrap gap-2">
          {article.tags.map((tag) => (
            <span
              key={tag}
              className="px-3 py-1 rounded-full bg-[#f0f1f2] text-[#42526e] text-[12px] font-medium"
            >
              #{tag}
            </span>
          ))}
        </div>

        {/* Bottom Banner */}
        <div className="p-8 rounded-[20px] bg-[#101214] text-white flex flex-col sm:flex-row items-center justify-between gap-6 border border-[#292a2e]">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-lg font-medium tracking-[0.012em]">See LAM in Action in Classrooms</h3>
            <p className="text-[14px] text-[#b7b9be] font-normal">
              Schedule a personalized school demonstration or explore our platform whitepaper.
            </p>
          </div>
          <div className="flex items-center gap-3">
            <Button href="/school-demo" variant="white" size="md">
              Book School Demo
            </Button>
            <Button href="/resources" variant="outline" size="md" className="border-[#b7b9be] text-white hover:bg-white/10">
              Back to Resources
            </Button>
          </div>
        </div>
      </div>
    </article>
  );
}
