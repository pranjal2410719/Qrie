import React from "react";
import Link from "next/link";
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
      icon: <GraduationCap className="w-6 h-6 text-sky-600" />,
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
      icon: <HeartHandshake className="w-6 h-6 text-rose-600" />,
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
      icon: <BookOpenCheck className="w-6 h-6 text-emerald-600" />,
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
      icon: <Building2 className="w-6 h-6 text-indigo-600" />,
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto space-y-4 mb-16">
          <span className="text-xs font-bold uppercase tracking-wider text-sky-600 bg-sky-50 px-3 py-1 rounded-full border border-sky-100">
            Tailored For Education
          </span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Designed for the Entire School Community
          </h2>
          <p className="text-base text-slate-600 leading-relaxed">
            Education requires alignment between students, families, educators, and leadership.
            Qrie provides dedicated experiences for each stakeholder.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {audiences.map((item) => (
            <div
              key={item.title}
              className="p-8 rounded-3xl bg-slate-50/60 border border-slate-200/80 hover:bg-white hover:shadow-md hover:border-slate-300 transition-all duration-200 flex flex-col justify-between"
            >
              <div className="space-y-4">
                <div className="w-12 h-12 rounded-2xl bg-white border border-slate-200 flex items-center justify-center shadow-2xs">
                  {item.icon}
                </div>
                <h3 className="text-2xl font-bold text-slate-900">{item.title}</h3>
                <p className="text-sm font-medium text-slate-600">{item.tagline}</p>
                <ul className="space-y-2.5 pt-2">
                  {item.points.map((pt, i) => (
                    <li key={i} className="text-xs text-slate-600 flex items-start gap-2.5">
                      <span className="w-1.5 h-1.5 rounded-full bg-sky-600 shrink-0 mt-1.5" />
                      <span>{pt}</span>
                    </li>
                  ))}
                </ul>
              </div>

              <div className="pt-6 border-t border-slate-200/80 mt-6">
                <Link
                  href={item.href}
                  className="inline-flex items-center gap-1.5 text-xs font-bold text-sky-700 hover:text-sky-800 transition-colors"
                >
                  <span>{item.cta}</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </Link>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
