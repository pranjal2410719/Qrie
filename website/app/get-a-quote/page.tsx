"use client";

import React, { useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import {
  FileText,
  CheckCircle2,
  AlertCircle,
  Clock,
} from "lucide-react";

function QuoteFormContent() {
  const searchParams = useSearchParams();
  const initialProduct = searchParams.get("product") || searchParams.get("service") || "Qrie School Platform";

  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    organization: "",
    role: "School Administrator / Principal",
    productOrService: initialProduct,
    studentCount: "500",
    timeline: "Within 30 days",
    requirements: "",
  });

  const [isLoading, setIsLoading] = useState(false);
  const [submittedRef, setSubmittedRef] = useState<string | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setIsLoading(true);

    try {
      const res = await fetch("/api/quote", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await res.json();
      if (!res.ok || !data.success) {
        throw new Error(data.error || "Failed to submit quotation request.");
      }

      setSubmittedRef(data.quoteReference);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : "Submission error occurred.";
      setErrorMessage(msg);
    } finally {
      setIsLoading(false);
    }
  };

  if (submittedRef) {
    return (
      <div className="py-12 text-center space-y-4 animate-in fade-in">
        <div className="w-16 h-16 rounded-3xl bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto">
          <CheckCircle2 className="w-8 h-8" />
        </div>
        <h3 className="text-2xl font-bold text-slate-900">Quotation Request Registered!</h3>
        <p className="text-xs text-slate-600 max-w-sm mx-auto leading-relaxed">
          Your request has been logged under formal reference:
        </p>
        <div className="inline-block px-4 py-2 rounded-xl bg-white border border-slate-200 font-mono text-sm font-bold text-sky-700">
          {submittedRef}
        </div>
        <p className="text-xs text-slate-500 pt-2">
          Our institutional sales desk is reviewing your requirements and will email an official
          breakdown and scheduling follow-up.
        </p>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <h3 className="text-lg font-bold text-slate-900 mb-2">Institutional Details</h3>

      {errorMessage && (
        <div className="p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-center gap-2">
          <AlertCircle className="w-4 h-4 shrink-0" />
          <span>{errorMessage}</span>
        </div>
      )}

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
            Contact Name *
          </label>
          <input
            type="text"
            required
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            placeholder="Principal / Academic Head"
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
            placeholder="office@school.edu.in"
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
            Phone Number
          </label>
          <input
            type="tel"
            value={formData.phone}
            onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
            placeholder="+91 98765 43210"
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
            School / Organization *
          </label>
          <input
            type="text"
            required
            value={formData.organization}
            onChange={(e) => setFormData({ ...formData, organization: e.target.value })}
            placeholder="St. Xavier's High School"
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
            Product or Service of Interest *
          </label>
          <input
            type="text"
            required
            value={formData.productOrService}
            onChange={(e) => setFormData({ ...formData, productOrService: e.target.value })}
            placeholder="Qrie School Platform"
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
            Estimated Student Count
          </label>
          <select
            value={formData.studentCount}
            onChange={(e) => setFormData({ ...formData, studentCount: e.target.value })}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 bg-white text-sm focus:outline-none focus:ring-2 focus:ring-sky-500"
          >
            <option value="150-300">150 to 300 Students</option>
            <option value="300-800">300 to 800 Students</option>
            <option value="800-2000">800 to 2,000 Students</option>
            <option value="2000+">2,000+ Students (School Chain / Trust)</option>
          </select>
        </div>
      </div>

      <div>
        <label className="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">
          Specific Requirements or Curriculum Needs
        </label>
        <textarea
          rows={3}
          value={formData.requirements}
          onChange={(e) => setFormData({ ...formData, requirements: e.target.value })}
          placeholder="Mention custom ERP integrations, specific board exams, or preferred teacher training dates."
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
        Generate Official Proposal
      </Button>
    </form>
  );
}

export default function GetAQuotePage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Get a Custom Quote", href: "/get-a-quote" }]} />

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          {/* Left: Info */}
          <div className="lg:col-span-5 space-y-6">
            <Badge variant="primary" size="md">
              <FileText className="w-3.5 h-3.5 text-sky-600" />
              <span>Institutional Proposal</span>
            </Badge>

            <h1 className="text-4xl sm:text-5xl font-black text-slate-900 tracking-tight leading-tight">
              Request a Custom Institutional Quote
            </h1>

            <p className="text-base text-slate-600 leading-relaxed">
              Every educational institution has unique student enrollment figures, syllabus modifications,
              and deployment timetables. Share your requirements to receive a formal commercial proposal.
            </p>

            <div className="space-y-3 pt-4 border-t border-slate-100 text-xs text-slate-600">
              <div className="flex items-start gap-2.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                <span>Volume licensing discounts based on active student enrollment.</span>
              </div>
              <div className="flex items-start gap-2.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                <span>Includes teacher workshops, admin portal setup, and custom school branding.</span>
              </div>
              <div className="flex items-start gap-2.5">
                <Clock className="w-4 h-4 text-sky-600 shrink-0 mt-0.5" />
                <span>Formal PDF proposal delivered to your email within 1 business day.</span>
              </div>
            </div>
          </div>

          {/* Right: Quotation Form */}
          <div className="lg:col-span-7 bg-slate-50 rounded-3xl p-6 sm:p-8 border border-slate-200">
            <Suspense fallback={<div className="py-12 text-center text-sm text-slate-500">Loading form...</div>}>
              <QuoteFormContent />
            </Suspense>
          </div>
        </div>
      </div>
    </div>
  );
}
