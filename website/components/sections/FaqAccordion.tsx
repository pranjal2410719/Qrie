"use client";

import React, { useState } from "react";
import Link from "next/link";
import { faqsData } from "@/lib/data/faqs";
import { ChevronDown, ArrowRight } from "lucide-react";

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
      {/* Category Pills (Charlie Text 13px weight 500, pill shape 10000px) */}
      {showCategoryFilter && (
        <div className="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-none">
          {categories.map((c) => (
            <button
              key={c.id}
              onClick={() => setSelectedCategory(c.id)}
              className={`px-3.5 py-1.5 rounded-[10000px] text-[13px] font-medium whitespace-nowrap transition-colors ${
                selectedCategory === c.id
                  ? "bg-[#1868db] text-white"
                  : "bg-[#f0f1f2] text-[#42526e] hover:bg-[#e4e6e9]"
              }`}
            >
              {c.label}
            </button>
          ))}
        </div>
      )}

      {/* Accordion Items: 20px radius cards with subtle micro-shadow */}
      <div className="space-y-3">
        {displayedFaqs.map((faq) => {
          const isOpen = !!openIds[faq.id];
          return (
            <div
              key={faq.id}
              className="rounded-[20px] border border-[#f0f1f2] bg-white overflow-hidden shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] transition-colors hover:border-[#b7b9be]"
            >
              <button
                onClick={() => toggle(faq.id)}
                className="w-full px-6 py-5 flex items-center justify-between text-left gap-4 font-medium text-[#101214] text-[16px] hover:text-[#1868db] transition-colors"
                aria-expanded={isOpen}
              >
                <span>{faq.question}</span>
                <ChevronDown
                  className={`w-4 h-4 text-[#42526e] shrink-0 transition-transform duration-150 ${
                    isOpen ? "rotate-180 text-[#1868db]" : ""
                  }`}
                />
              </button>

              {isOpen && (
                <div className="px-6 pb-5 pt-1 text-[14px] text-[#42526e] leading-[1.6] border-t border-[#f0f1f2] bg-white animate-in fade-in duration-150 font-normal">
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
            className="inline-flex items-center gap-1.5 text-[14px] font-medium text-[#1868db] hover:underline"
          >
            <span>View All Frequently Asked Questions</span>
            <ArrowRight className="w-4 h-4" />
          </Link>
        </div>
      )}
    </div>
  );
}
