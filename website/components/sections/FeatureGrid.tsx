import React from "react";
import Link from "next/link";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";
import {
  GraduationCap,
  HeartHandshake,
  BookOpenCheck,
  Building2,
  ArrowRight,
} from "lucide-react";

export function FeatureGrid() {
  const audiences = [
    {
      title: "For Students",
      icon: <GraduationCap className="w-5 h-5 text-[#1868db]" />,
      tagline: "Learn at your own pace without fear of asking questions.",
      points: [
        "24/7 AI tutor available whenever you get stuck on difficult homework",
        "Interactive NCERT chapter summaries and practice quizzes",
        "Offline study capability for uninterrupted learning anywhere",
        "Gamified streaks and badges to keep your study habits consistent",
      ],
      href: "/students",
      cta: "Explore Student Benefits",
    },
    {
      title: "For Parents",
      icon: <HeartHandshake className="w-5 h-5 text-[#1868db]" />,
      tagline: "Clear visibility into what your child actually understands.",
      points: [
        "Honest mastery indicators rather than relying only on exam surprises",
        "Early alerts on specific concepts that need revision or extra help",
        "Confidence that learning data is protected under India DPDP Act 2023",
        "Curriculum-aligned practice that matches school examinations",
      ],
      href: "/parents",
      cta: "Explore Parent Features",
    },
    {
      title: "For Teachers",
      icon: <BookOpenCheck className="w-5 h-5 text-[#1868db]" />,
      tagline: "Save 5+ hours weekly while targeting real classroom gaps.",
      points: [
        "Automated homework distribution and multi-step diagnostic grading",
        "Real-time struggle heatmaps showing class-wide misconceptions",
        "Syllabus tracker aligned with term exams and academic calendars",
        "AI co-pilot that assists instruction without replacing teacher judgment",
      ],
      href: "/teachers",
      cta: "Explore Teacher Tools",
    },
    {
      title: "For School Leaders",
      icon: <Building2 className="w-5 h-5 text-[#1868db]" />,
      tagline: "A unified, modern software system for academic excellence.",
      points: [
        "Multi-tenant data isolation ensuring institutional privacy",
        "Roster sync with existing school ERP/SIS databases",
        "Turnkey teacher training workshops and on-campus onboarding",
        "School-branded mobile apps (custom crest, colors, and motto)",
      ],
      href: "/schools",
      cta: "Explore School Solutions",
    },
  ];

  return (
    <section className="py-20 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <EditorialHeadline
          badge="Tailored For Education"
          title="Designed for the Entire School Community"
          highlightWord="School Community"
          description="Education requires alignment between students, families, educators, and leadership. Qrie provides dedicated experiences for each stakeholder."
        />

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {audiences.map((item) => (
            <div
              key={item.title}
              className="p-8 rounded-[20px] bg-white border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] hover:border-[#b7b9be] transition-colors flex flex-col justify-between"
            >
              <div className="space-y-4">
                <div className="w-10 h-10 rounded-[10px] bg-[#f0f1f2] flex items-center justify-center">
                  {item.icon}
                </div>
                <h3 className="text-2xl font-medium tracking-[0.012em] text-[#101214]">
                  {item.title}
                </h3>
                <p className="text-[14px] font-medium text-[#42526e]">
                  {item.tagline}
                </p>
                <ul className="space-y-2.5 pt-2">
                  {item.points.map((pt, i) => (
                    <li key={i} className="text-[13px] text-[#42526e] flex items-start gap-2.5 font-normal">
                      <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] shrink-0 mt-2" />
                      <span>{pt}</span>
                    </li>
                  ))}
                </ul>
              </div>

              <div className="pt-6 border-t border-[#f0f1f2] mt-6">
                <Link
                  href={item.href}
                  className="inline-flex items-center gap-1.5 text-[14px] font-medium text-[#1868db] hover:underline transition-colors"
                >
                  <span>{item.cta}</span>
                  <ArrowRight className="w-4 h-4" />
                </Link>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
