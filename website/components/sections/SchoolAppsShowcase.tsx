import React from "react";
import Link from "next/link";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  Smartphone,
  LayoutDashboard,
  Users,
  CheckCircle,
  GraduationCap,
  ShieldCheck,
  School,
  ArrowRight,
} from "lucide-react";

export function SchoolAppsShowcase() {
  return (
    <section className="py-20 bg-slate-50 border-b border-slate-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto space-y-4 mb-16">
          <Badge variant="primary" size="md">
            <School className="w-3.5 h-3.5 text-sky-600" />
            <span>Connected School Operating System</span>
          </Badge>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Complete Digital Software for Schools
          </h2>
          <p className="text-base text-slate-600 leading-relaxed">
            Qrie connects administration, faculty, and students through dedicated mobile applications
            and responsive web portals designed specifically for Indian K-12 school workflows.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-stretch">
          {/* Card 1: Application A - Teacher & Admin App */}
          <div className="bg-white rounded-3xl p-8 border border-slate-200/90 shadow-sm flex flex-col justify-between">
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold px-3 py-1 rounded-full bg-indigo-50 text-indigo-700 border border-indigo-200">
                  Application A
                </span>
                <span className="text-xs text-slate-500 font-medium">For Android & Web</span>
              </div>

              <div>
                <h3 className="text-2xl font-black text-slate-900 mb-2">
                  School Staff & Teacher Co-Pilot
                </h3>
                <p className="text-sm text-slate-600 leading-relaxed">
                  Equips subject teachers and academic coordinators with automated homework creation,
                  live classroom struggle heatmaps, and attendance rosters.
                </p>
              </div>

              <div className="space-y-3 pt-2">
                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">Roster & Section Management:</strong>{" "}
                    Track multi-section classes (e.g. 9-A, 9-B) and teacher timetables.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">Automated Homework Grading:</strong>{" "}
                    Diagnostic auto-grading with symbolic mathematics error verification.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">Struggle Alerts:</strong> Proactive
                    warnings highlighting topics where class comprehension drops below 70%.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">Administrative Portal:</strong>{" "}
                    Web portal for school principals to monitor syllabus progress and teacher coverage.
                  </div>
                </div>
              </div>
            </div>

            <div className="pt-8 border-t border-slate-100 mt-6 flex items-center justify-between">
              <span className="text-xs font-semibold text-slate-500">
                CBSE & State Board Ready
              </span>
              <Button href="/teachers" variant="outline" size="sm">
                Explore Teacher Tools
              </Button>
            </div>
          </div>

          {/* Card 2: Application B - Student Mobile App */}
          <div className="bg-white rounded-3xl p-8 border border-slate-200/90 shadow-sm flex flex-col justify-between">
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold px-3 py-1 rounded-full bg-sky-50 text-sky-700 border border-sky-200">
                  Application B
                </span>
                <span className="text-xs text-slate-500 font-medium">For Android Mobile</span>
              </div>

              <div>
                <h3 className="text-2xl font-black text-slate-900 mb-2">
                  Student Mobile Learning App
                </h3>
                <p className="text-sm text-slate-600 leading-relaxed">
                  A high-performance, offline-capable Flutter Android client engineered for cost-effective
                  smartphones and low-bandwidth connectivity in Indian environments.
                </p>
              </div>

              <div className="space-y-3 pt-2">
                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">Offline-First SQLite Outbox:</strong>{" "}
                    Complete study sessions and quizzes without active internet; syncs automatically.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">24/7 AI Socratic Tutor:</strong>{" "}
                    Step-by-step guidance that provides hints and conceptual breakdowns.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">School Homework Integration:</strong>{" "}
                    Directly receive assignments from teachers and submit answers digitally.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />
                  <div className="text-xs text-slate-700">
                    <strong className="font-semibold text-slate-900">Gamified Motivation:</strong>{" "}
                    Study streaks, XP, gems, and mastery badges to encourage daily consistency.
                  </div>
                </div>
              </div>
            </div>

            <div className="pt-8 border-t border-slate-100 mt-6 flex items-center justify-between">
              <span className="text-xs font-semibold text-slate-500">
                Lightweight (~30MB APK)
              </span>
              <Button href="/products/qrie-student-app" variant="primary" size="sm">
                View Student App
              </Button>
            </div>
          </div>
        </div>

        {/* Institutional Callout */}
        <div className="mt-12 p-8 rounded-3xl bg-slate-900 text-white flex flex-col md:flex-row items-center justify-between gap-6">
          <div className="space-y-2 text-center md:text-left">
            <h4 className="text-xl font-bold">
              Looking to deploy Qrie across your school or institution?
            </h4>
            <p className="text-xs text-slate-400 max-w-xl">
              We provide full turnkey onboarding, SIS roster synchronization, teacher enablement workshops,
              and dedicated institutional support.
            </p>
          </div>
          <div className="flex items-center gap-3 shrink-0">
            <Button href="/school-demo" variant="white" size="md">
              Schedule School Demo
            </Button>
            <Button href="/get-a-quote" variant="outline" size="md" className="border-slate-700 text-white bg-slate-800 hover:bg-slate-700">
              Get Custom Quote
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
