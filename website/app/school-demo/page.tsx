"use client";

import React, { useState } from "react";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  School,
  CheckCircle2,
  Calendar,
  Users,
  ShieldCheck,
  AlertCircle,
  Clock,
  Sparkles,
} from "lucide-react";

export default function SchoolDemoPage() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    schoolName: "",
    city: "",
    gradeLevels: "Classes 6–10",
    preferredDate: "",
    comments: "",
  });

  const [isLoading, setIsLoading] = useState(false);
  const [submittedRef, setSubmittedRef] = useState<string | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setIsLoading(true);

    try {
      const res = await fetch("/api/school-demo", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await res.json();
      if (!res.ok || !data.success) {
        throw new Error(data.error || "Failed to schedule demonstration.");
      }

      setSubmittedRef(data.reference);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : "Submission error occurred.";
      setErrorMessage(msg);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "For Schools", href: "/schools" }, { label: "Request a School Demo", href: "/school-demo" }]} />

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          {/* Left Column: Context & What Demo Includes */}
          <div className="lg:col-span-6 space-y-6">
            <Badge variant="primary" size="md">
              <School className="w-3.5 h-3.5 text-sky-600" />
              <span>Institutional Consultation</span>
            </Badge>

            <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
              Request a School Demonstration & Pilot
            </h1>

            <p className="text-base text-slate-600 leading-relaxed">
              Experience how Qrie transforms academic operations in your classrooms. Schedule a personalized
              virtual or on-campus walk-through with our educational deployment team.
            </p>

            <div className="space-y-4 pt-4 border-t border-slate-100">
              <h2 className="text-sm font-bold uppercase tracking-wider text-slate-900">
                What Your School Demo Includes:
              </h2>

              <ul className="space-y-3 text-xs text-slate-600">
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <span>
                    <strong>Teacher Co-Pilot Walkthrough:</strong> Automated homework creation and class
                    mastery struggle heatmaps.
                  </span>
                </li>
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <span>
                    <strong>Student Mobile Experience:</strong> Live demonstration of the offline-first
                    Android app and Socratic AI tutor.
                  </span>
                </li>
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <span>
                    <strong>Curriculum Mapping Review:</strong> Aligning NCERT/CBSE/ICSE syllabus blueprints
                    with your school calendar.
                  </span>
                </li>
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                  <span>
                    <strong>30-Day Institutional Pilot:</strong> Evaluation terms and teacher enablement
                    workshop options.
                  </span>
                </li>
              </ul>
            </div>

            <div className="p-4 rounded-2xl bg-sky-50 border border-sky-100 text-xs text-sky-800 space-y-1">
              <div className="font-bold flex items-center gap-1.5">
                <Clock className="w-4 h-4 text-sky-600" />
                <span>Response Time Commitment</span>
              </div>
              <p>
                Our academic partnerships desk contacts school administrators within 1 business day to confirm
                session timing and invite participating department heads.
              </p>
            </div>
          </div>

          {/* Right Column: Functional Demo Form */}
          <div className="lg:col-span-6 bg-slate-50/80 rounded-3xl p-6 sm:p-8 border border-slate-200">
            {submittedRef ? (
              <div className="py-12 text-center space-y-4 animate-in fade-in">
                <div className="w-16 h-16 rounded-3xl bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto">
                  <CheckCircle2 className="w-8 h-8" />
                </div>
                <h3 className="text-2xl font-bold text-slate-900">Demonstration Requested!</h3>
                <p className="text-xs text-slate-600 max-w-sm mx-auto leading-relaxed">
                  Your request has been registered under reference:
                </p>
                <div className="inline-block px-4 py-2 rounded-xl bg-white border border-slate-200 font-mono text-sm font-bold text-sky-700">
                  {submittedRef}
                </div>
                <p className="text-xs text-slate-500 pt-2">
                  A Qrie academic coordinator will contact you via email and phone to confirm the meeting link
                  and prepare your customized school preview.
                </p>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
                <h3 className="text-lg font-bold text-slate-900 mb-2">Schedule Your School Demo</h3>

                {errorMessage && (
                  <div className="p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-center gap-2">
                    <AlertCircle className="w-4 h-4 shrink-0" />
                    <span>{errorMessage}</span>
                  </div>
                )}

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                      Your Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      placeholder="Dr. S. K. Verma"
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                      Official Work Email *
                    </label>
                    <input
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      placeholder="principal@dps-school.edu.in"
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                      Phone Number *
                    </label>
                    <input
                      type="tel"
                      required
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      placeholder="+91 98765 43210"
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                      School / Institution Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.schoolName}
                      onChange={(e) => setFormData({ ...formData, schoolName: e.target.value })}
                      placeholder="Delhi Public School, R.K. Puram"
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                      City & State *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.city}
                      onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                      placeholder="New Delhi, Delhi"
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                      Target Grade Levels
                    </label>
                    <select
                      value={formData.gradeLevels}
                      onChange={(e) => setFormData({ ...formData, gradeLevels: e.target.value })}
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                    >
                      <option value="Classes 6–8">Middle School (Classes 6–8)</option>
                      <option value="Classes 9–10">Secondary (Classes 9–10)</option>
                      <option value="Classes 11–12">Senior Secondary (Classes 11–12)</option>
                      <option value="Classes 6–12">Complete School (Classes 6–12)</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
                    Additional Requirements / Preferred Timeline
                  </label>
                  <textarea
                    rows={3}
                    value={formData.comments}
                    onChange={(e) => setFormData({ ...formData, comments: e.target.value })}
                    placeholder="Tell us about your student population, board affiliation (CBSE/ICSE), or specific diagnostic goals."
                    className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
                  />
                </div>

                <Button
                  type="submit"
                  variant="primary"
                  size="lg"
                  className="w-full"
                  isLoading={isLoading}
                >
                  Confirm & Schedule School Demo
                </Button>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
