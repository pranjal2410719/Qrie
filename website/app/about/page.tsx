import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Brain,
  Target,
  MapPin,
  Mail,
} from "lucide-react";
import { siteConfig } from "@/lib/seo/siteConfig";

export const metadata: Metadata = {
  title: "About Qrie AI — Mission, Learning Philosophy & Technology",
  description:
    "Learn about Qrie AI's mission to bridge learning gaps across Indian school education using mathematically grounded cognitive modeling and connected school software.",
  alternates: {
    canonical: "https://qrie.ai/about",
  },
};

export default function AboutPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <Breadcrumbs items={[{ label: "About Qrie AI", href: "/about" }]} />

        {/* Hero */}
        <div className="max-w-3xl space-y-4">
          <Badge variant="primary" size="md">
            <span>Our Educational Mission</span>
          </Badge>
          <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Bridging Learning Gaps in Every Classroom
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Qrie was founded to solve a fundamental challenge in Indian school education: in a classroom
            of 40 students, one teacher cannot deliver 40 personalized explanations simultaneously.
            We build the cognitive intelligence layer that makes personalized education accessible to every student.
          </p>
        </div>

        {/* Problem & Approach Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-4">
            <Target className="w-8 h-8 text-[#1868db]" />
            <h3 className="text-2xl font-medium tracking-[0.012em] text-[#101214]">The Challenge</h3>
            <p className="text-[14px] text-[#42526e] leading-[1.6] font-normal">
              Standard curricula move at a predetermined calendar pace. When a student misses a single
              foundational concept in July (such as negative exponents or the concept of moles in chemistry),
              that unnoticed gap compounds. By December, the student struggles with advanced derivations,
              leading to exam anxiety and academic disengagement.
            </p>
          </div>

          <div className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] space-y-4">
            <Brain className="w-8 h-8 text-[#1868db]" />
            <h3 className="text-2xl font-medium tracking-[0.012em] text-[#101214]">Our Approach: LAM</h3>
            <p className="text-[14px] text-[#42526e] leading-[1.6] font-normal">
              Instead of generic conversational chatbots that offer passive answers, Qrie developed the
              Learning Adaptation Model (LAM). Using Bayesian Knowledge Tracing and decaying half-life
              retrieval curves, LAM continuously estimates atomic concept mastery, ensures active Socratic
              struggle, and surfaces early struggle heatmaps directly to classroom teachers.
            </p>
          </div>
        </div>

        {/* Core Principles: Inverted Dark Panel */}
        <div className="p-8 sm:p-10 rounded-[20px] bg-[#101214] text-white border border-[#292a2e] space-y-8">
          <h2 className="text-2xl sm:text-3xl font-medium tracking-[0.012em]">Our Core Principles</h2>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="space-y-2">
              <span className="text-[12px] font-bold text-[#1868db] uppercase tracking-wide">
                Principle 1
              </span>
              <h3 className="text-lg font-medium tracking-[0.012em]">Pedagogy Over Hype</h3>
              <p className="text-[13px] text-[#b7b9be] leading-[1.5] font-normal">
                We measure success through durable concept retention and reduced teacher grading burden,
                not through superficial chat response counts.
              </p>
            </div>

            <div className="space-y-2">
              <span className="text-[12px] font-bold text-emerald-400 uppercase tracking-wide">
                Principle 2
              </span>
              <h3 className="text-lg font-medium tracking-[0.012em]">Empowering Educators</h3>
              <p className="text-[13px] text-[#b7b9be] leading-[1.5] font-normal">
                AI must never replace teachers. Our software is designed as a co-pilot that provides
                teachers with actionable data so they can make high-impact human interventions.
              </p>
            </div>

            <div className="space-y-2">
              <span className="text-[12px] font-bold text-[#fca700] uppercase tracking-wide">
                Principle 3
              </span>
              <h3 className="text-lg font-medium tracking-[0.012em]">Low-Bandwidth Equity</h3>
              <p className="text-[13px] text-[#b7b9be] leading-[1.5] font-normal">
                Personalized education cannot be restricted to high-speed broadband zones. Our Android
                app is lightweight (~30MB) and operates fully offline via SQLite outbox queues.
              </p>
            </div>
          </div>
        </div>

        {/* Headquarters & Contact */}
        <div className="p-8 rounded-[20px] bg-[#f0f1f2] border border-[#f0f1f2] flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div className="space-y-2">
            <h3 className="text-lg font-medium tracking-[0.012em] text-[#101214]">Headquartered in Bengaluru, India</h3>
            <div className="flex items-center gap-2 text-[13px] text-[#42526e] font-normal">
              <MapPin className="w-4 h-4 text-[#1868db]" />
              <span>Outer Ring Road, Bellandur, Bengaluru, Karnataka 560103</span>
            </div>
            <div className="flex items-center gap-2 text-[13px] text-[#42526e] font-normal">
              <Mail className="w-4 h-4 text-[#1868db]" />
              <a href={`mailto:${siteConfig.contactEmail}`} className="hover:underline">
                {siteConfig.contactEmail}
              </a>
            </div>
          </div>

          <Button href="/contact" variant="primary" size="md">
            Connect With Our Team
          </Button>
        </div>
      </div>
    </div>
  );
}
