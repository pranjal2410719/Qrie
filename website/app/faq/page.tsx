import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { FaqAccordion } from "@/components/sections/FaqAccordion";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { faqsData } from "@/lib/data/faqs";
import { generateFaqSchema } from "@/lib/seo/jsonLd";
import { HelpCircle, Mail, MessageSquare } from "lucide-react";

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
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Frequently Asked Questions", href: "/faq" }]} />

        {/* Hero */}
        <div className="text-center space-y-4">
          <Badge variant="primary" size="md">
            <HelpCircle className="w-3.5 h-3.5 text-sky-600" />
            <span>Support & Documentation</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
            Frequently Asked Questions
          </h1>
          <p className="text-base text-slate-600 leading-relaxed font-normal">
            Everything you need to know about Qrie AI, our Learning Adaptation Model (LAM),
            offline mobile capabilities, and institutional school deployment.
          </p>
        </div>

        {/* Interactive Accordion with category filter */}
        <FaqAccordion showCategoryFilter={true} />

        {/* Still have questions card */}
        <div className="p-8 rounded-3xl bg-slate-50 border border-slate-200 text-center space-y-4">
          <h2 className="text-lg font-bold text-slate-900">Still Have a Specific Question?</h2>
          <p className="text-xs text-slate-600 max-w-md mx-auto">
            Our academic and technical team is ready to answer specific institutional questions or curriculum requirements.
          </p>
          <div className="flex items-center justify-center gap-3 pt-2">
            <Button href="/contact" variant="primary" size="md" icon={<Mail className="w-4 h-4" />}>
              Contact Academic Desk
            </Button>
            <Button href="/contact/sales" variant="outline" size="md">
              Speak to Institutional Sales
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
