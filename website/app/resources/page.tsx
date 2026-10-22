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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "Resources", href: "/resources" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <BookOpen className="w-3.5 h-3.5 text-sky-600" />
            <span>Articles & Research</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Learning Science & Educational AI Hub
          </h1>
          <p className="text-lg text-slate-600 leading-relaxed font-normal">
            Articles and technical explanations exploring cognitive architecture, Bayesian Knowledge
            Tracing (BKT), Socratic assistance escalation, and real-world school deployment strategies.
          </p>
        </div>

        {/* Articles Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-stretch">
          {resourcesData.map((article) => (
            <article
              key={article.slug}
              className="p-8 rounded-3xl border border-slate-200/90 bg-white hover:border-slate-300 hover:shadow-md transition-all duration-200 flex flex-col justify-between"
            >
              <div className="space-y-4">
                <div className="flex items-center justify-between text-xs text-slate-400">
                  <span className="font-semibold uppercase tracking-wider text-sky-600">
                    {article.category.replace("-", " ")}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="w-3.5 h-3.5" />
                    <span>{article.readTime}</span>
                  </span>
                </div>

                <h2 className="text-2xl font-bold text-slate-900 leading-snug hover:text-sky-600 transition-colors">
                  <Link href={`/resources/${article.slug}`}>{article.title}</Link>
                </h2>

                <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
                  {article.excerpt}
                </p>

                <div className="flex flex-wrap gap-1.5 pt-2">
                  {article.tags.map((t) => (
                    <span
                      key={t}
                      className="text-[10px] font-semibold px-2.5 py-0.5 rounded-full bg-slate-100 text-slate-600"
                    >
                      #{t}
                    </span>
                  ))}
                </div>
              </div>

              <div className="pt-6 border-t border-slate-100 mt-6 flex items-center justify-between">
                <div className="flex items-center gap-2 text-xs text-slate-600">
                  <User className="w-3.5 h-3.5 text-slate-400" />
                  <span>{article.author.name}</span>
                </div>

                <Link
                  href={`/resources/${article.slug}`}
                  className="inline-flex items-center gap-1.5 text-xs font-bold text-sky-600 hover:text-sky-700"
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
