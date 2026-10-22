import React from "react";
import { Button } from "@/components/ui/Button";
import { EditorialHeadline } from "@/components/ui/EditorialHeadline";
import { CheckCircle } from "lucide-react";

export function SchoolAppsShowcase() {
  return (
    <section className="py-20 bg-white border-b border-[#f0f1f2]">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        <EditorialHeadline
          badge="School Operating System"
          title="Complete Software Ecosystem for Schools"
          highlightWord="Ecosystem"
          description="Connecting administrators, faculty, and students through dedicated Android applications and responsive web portals purpose-built for Indian K-12 classrooms."
        />

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-stretch">
          {/* Card 1: App A - Teacher & Admin App */}
          <div className="bg-white rounded-[20px] p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] flex flex-col justify-between">
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <span className="text-[12px] font-medium px-3 py-1 rounded-full bg-[#f0f1f2] text-[#42526e]">
                  Application A
                </span>
                <span className="text-[12px] text-[#42526e] font-normal">
                  For Android & Web Portal
                </span>
              </div>

              <div>
                <h3 className="text-2xl font-medium text-[#101214] mb-2 tracking-[0.012em]">
                  School Faculty & Teacher Co-Pilot
                </h3>
                <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
                  Equips subject teachers and academic coordinators with automated homework creation,
                  live classroom struggle heatmaps, and attendance rosters.
                </p>
              </div>

              <div className="space-y-3 pt-2">
                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">Roster & Section Management:</strong>{" "}
                    Track multi-section classes (e.g. 9-A, 9-B) and teacher timetables.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">Automated Homework Grading:</strong>{" "}
                    Diagnostic auto-grading with symbolic mathematics error verification.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">Struggle Alerts:</strong> Proactive
                    warnings highlighting topics where class comprehension drops below 70%.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">Administrative Portal:</strong>{" "}
                    Web portal for school principals to monitor syllabus progress and teacher coverage.
                  </div>
                </div>
              </div>
            </div>

            <div className="pt-6 border-t border-[#f0f1f2] mt-6 flex items-center justify-between">
              <span className="text-[13px] font-normal text-[#42526e]">
                CBSE & State Board Ready
              </span>
              <Button href="/teachers" variant="outline" size="sm">
                Explore Teacher Tools
              </Button>
            </div>
          </div>

          {/* Card 2: App B - Student Mobile App */}
          <div className="bg-white rounded-[20px] p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px] flex flex-col justify-between">
            <div className="space-y-6">
              <div className="flex items-center justify-between">
                <span className="text-[12px] font-medium px-3 py-1 rounded-full bg-[#e9f2fe] text-[#1868db]">
                  Application B
                </span>
                <span className="text-[12px] text-[#42526e] font-normal">
                  For Android Mobile
                </span>
              </div>

              <div>
                <h3 className="text-2xl font-medium text-[#101214] mb-2 tracking-[0.012em]">
                  Student Mobile Learning App
                </h3>
                <p className="text-[14px] text-[#42526e] leading-[1.5] font-normal">
                  A high-performance, offline-capable Flutter Android client engineered for cost-effective
                  smartphones and low-bandwidth connectivity in Indian environments.
                </p>
              </div>

              <div className="space-y-3 pt-2">
                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">Offline SQLite Outbox:</strong>{" "}
                    Complete study sessions and quizzes without active internet; syncs automatically.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">24/7 AI Socratic Tutor:</strong>{" "}
                    Step-by-step guidance that provides hints and conceptual breakdowns.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">School Homework Integration:</strong>{" "}
                    Directly receive assignments from teachers and submit answers digitally.
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <CheckCircle className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                  <div className="text-[13px] text-[#292a2e] leading-[1.4]">
                    <strong className="font-semibold text-[#101214]">Gamified Motivation:</strong>{" "}
                    Study streaks, XP, gems, and mastery badges to encourage daily consistency.
                  </div>
                </div>
              </div>
            </div>

            <div className="pt-6 border-t border-[#f0f1f2] mt-6 flex items-center justify-between">
              <span className="text-[13px] font-normal text-[#42526e]">
                Lightweight (~30MB APK)
              </span>
              <Button href="/products/qrie-student-app" variant="primary" size="sm">
                View Student App
              </Button>
            </div>
          </div>
        </div>

        {/* Institutional Callout: Inverted dark card */}
        <div className="p-8 rounded-[20px] bg-[#101214] text-white flex flex-col md:flex-row items-center justify-between gap-6 border border-[#292a2e]">
          <div className="space-y-1 text-left">
            <h4 className="text-xl font-medium tracking-[0.012em] text-white">
              Deploy Qrie across your school or institution
            </h4>
            <p className="text-[14px] text-[#b7b9be] max-w-xl font-normal">
              Turnkey teacher training, SIS roster synchronization, on-campus onboarding, and dedicated institutional SLAs.
            </p>
          </div>
          <div className="flex items-center gap-3 shrink-0">
            <Button href="/school-demo" variant="white" size="md">
              Schedule School Demo
            </Button>
            <Button
              href="/get-a-quote"
              variant="outline"
              size="md"
              className="border-[#b7b9be] text-white hover:bg-white/10"
            >
              Get Custom Quote
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
