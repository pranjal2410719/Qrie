"use client";

import React, { useState } from "react";
import Link from "next/link";
import { faqsData, FaqItem } from "@/lib/data/faqs";
import { ChevronDown, HelpCircle, ArrowRight } from "lucide-react";

export function FaqAccordion({
  limit,
  showCategoryFilter = true,
}: {
  limit?: number;
  showCategoryFilter?: boolean;
}) {
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [openIds, setOpenIds] = useState<Record<string, boolean>>({
    "faq-what-is-qrie": true,
  });

  const categories = [
    { id: "all", label: "All Questions" },
    { id: "product", label: "Product & App" },
    { id: "lam", label: "LAM & AI Engine" },
    { id: "schools", label: "Schools & Teachers" },
    { id: "curriculum", label: "Curriculum" },
    { id: "privacy", label: "Data Privacy" },
    { id: "pricing", label: "Pricing & Plans" },
  ];

  const filteredFaqs = faqsData.filter((f) => {
    if (selectedCategory === "all") return true;
    return f.category === selectedCategory;
  });

  const displayedFaqs = limit ? filteredFaqs.slice(0, limit) : filteredFaqs;

  const toggle = (id: string) => {
    setOpenIds((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <div className="space-y-8">
      {/* Category Pills */}
      {showCategoryFilter && (
        <div className="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-none">
          {categories.map((c) => (
            <button
              key={c.id}
              onClick={() => setSelectedCategory(c.id)}
              className={`px-4 py-2 rounded-xl text-xs font-semibold whitespace-nowrap transition-all ${
                selectedCategory === c.id
                  ? "bg-sky-600 text-white shadow-xs"
                  : "bg-slate-100 text-slate-700 hover:bg-slate-200"
              }`}
            >
              {c.label}
            </button>
          ))}
        </div>
      )}

      {/* Accordion Items */}
      <div className="space-y-3">
        {displayedFaqs.map((faq) => {
          const isOpen = !!openIds[faq.id];
          return (
            <div
              key={faq.id}
              className="rounded-2xl border border-slate-200/90 bg-white overflow-hidden transition-all duration-200 hover:border-slate-300"
            >
              <button
                onClick={() => toggle(faq.id)}
                className="w-full px-6 py-5 flex items-center justify-between text-left gap-4 font-bold text-slate-900 text-base hover:text-sky-600 transition-colors"
                aria-expanded={isOpen}
              >
                <span>{faq.question}</span>
                <ChevronDown
                  className={`w-4 h-4 text-slate-400 shrink-0 transition-transform duration-200 ${
                    isOpen ? "rotate-180 text-sky-600" : ""
                  }`}
                />
              </button>

              {isOpen && (
                <div className="px-6 pb-5 pt-1 text-sm text-slate-600 leading-relaxed border-t border-slate-100 bg-slate-50/40 animate-in fade-in duration-150">
                  {faq.answer}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {limit && filteredFaqs.length > limit && (
        <div className="text-center pt-4">
          <Link
            href="/faq"
            className="inline-flex items-center gap-1.5 text-sm font-bold text-sky-600 hover:text-sky-700"
          >
            <span>View All Frequently Asked Questions</span>
            <ArrowRight className="w-4 h-4" />
          </Link>
        </div>
      )}
    </div>
  );
}
