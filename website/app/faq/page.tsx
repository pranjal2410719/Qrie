import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { FaqAccordion } from "@/components/sections/FaqAccordion";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { faqsData } from "@/lib/data/faqs";
import { generateFaqSchema } from "@/lib/seo/jsonLd";
import { HelpCircle, Mail } from "lucide-react";

export const metadata: Metadata = {
  title: "Frequently Asked Questions — Qrie AI Knowledge & Support",
  description:
    "Find answers about Qrie AI, the Learning Adaptation Model (LAM), offline mobile capabilities, CBSE/NCERT curriculum alignment, data privacy, and school onboarding.",
  alternates: {
    canonical: "https://qrie.ai/faq",
  },
};

export default function FaqPage() {
  const jsonLd = generateFaqSchema(faqsData);

  return (
    <div className="py-12 bg-white">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <div className="max-w-[960px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Frequently Asked Questions", href: "/faq" }]} />

        {/* Hero */}
        <div className="text-center space-y-4">
          <Badge variant="primary" size="md">
            <HelpCircle className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Support & Documentation</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Frequently Asked Questions
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal max-w-xl mx-auto">
            Everything you need to know about Qrie AI, our Learning Adaptation Model (LAM),
            offline mobile capabilities, and institutional school deployment.
          </p>
        </div>

        {/* Interactive Accordion with category filter */}
        <FaqAccordion showCategoryFilter={true} />

        {/* Still have questions card: 20px radius card */}
        <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] text-center space-y-4">
          <h2 className="text-xl font-medium tracking-[0.012em] text-[#101214]">Still Have a Specific Question?</h2>
          <p className="text-[14px] text-[#42526e] max-w-md mx-auto font-normal leading-[1.5]">
            Our academic and technical team is ready to answer specific institutional questions or curriculum requirements.
          </p>
          <div className="flex items-center justify-center gap-3 pt-2">
            <Button href="/contact" variant="primary" size="md" icon={<Mail className="w-4 h-4" />}>
              Contact Academic Desk
            </Button>
            <Button href="/school-demo" variant="outline" size="md">
              Book School Demo
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
