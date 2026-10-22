import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { resourcesData } from "@/lib/data/resources";
import { Badge } from "@/components/ui/Badge";
import { BookOpen, Clock, ArrowRight, User } from "lucide-react";

export const metadata: Metadata = {
  title: "Qrie AI Resources & Articles — Learning Science, LAM & Educational AI",
  description:
    "Explore in-depth articles on cognitive modeling, Bayesian Knowledge Tracing, Socratic tutoring pedagogy, and spaced retention strategies for school education.",
  alternates: {
    canonical: "https://qrie.ai/resources",
  },
};

export default function ResourcesPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Resources", href: "/resources" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <BookOpen className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Articles & Research</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Learning Science & Educational AI Hub
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Articles and technical explanations exploring cognitive architecture, Bayesian Knowledge
            Tracing (BKT), Socratic assistance escalation, and real-world school deployment strategies.
          </p>
        </div>

        {/* Articles Grid: 20px radius cards, subtle micro-shadow */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
          {resourcesData.map((article) => (
            <article
              key={article.slug}
              className="p-8 rounded-[20px] border border-[#f0f1f2] bg-white shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] hover:border-[#b7b9be] transition-colors flex flex-col justify-between"
            >
              <div className="space-y-4">
                <div className="flex items-center justify-between text-[12px] text-[#42526e] font-normal">
                  <span className="font-medium uppercase tracking-wider text-[#1868db]">
                    {article.category.replace("-", " ")}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="w-3.5 h-3.5 text-[#1868db]" />
                    <span>{article.readTime}</span>
                  </span>
                </div>

                <h2 className="text-2xl font-medium tracking-[0.012em] text-[#101214] leading-snug hover:text-[#1868db] transition-colors">
                  <Link href={`/resources/${article.slug}`}>{article.title}</Link>
                </h2>

                <p className="text-[14px] text-[#42526e] leading-[1.6] font-normal">
                  {article.excerpt}
                </p>

                <div className="flex flex-wrap gap-1.5 pt-2">
                  {article.tags.map((t) => (
                    <span
                      key={t}
                      className="text-[11px] font-medium px-2.5 py-0.5 rounded-full bg-[#f0f1f2] text-[#42526e]"
                    >
                      #{t}
                    </span>
                  ))}
                </div>
              </div>

              <div className="pt-6 border-t border-[#f0f1f2] mt-6 flex items-center justify-between">
                <div className="flex items-center gap-2 text-[13px] text-[#42526e] font-normal">
                  <User className="w-3.5 h-3.5 text-[#1868db]" />
                  <span>{article.author.name}</span>
                </div>

                <Link
                  href={`/resources/${article.slug}`}
                  className="inline-flex items-center gap-1.5 text-[14px] font-medium text-[#1868db] hover:underline"
                >
                  <span>Read Article</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </Link>
              </div>
            </article>
          ))}
        </div>
      </div>
    </div>
  );
}
