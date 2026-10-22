"use client";

import React, { useState } from "react";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { siteConfig } from "@/lib/seo/siteConfig";
import {
  Mail,
  MapPin,
  Clock,
  CheckCircle2,
  AlertCircle,
  MessageSquare,
} from "lucide-react";

export default function ContactPage() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    category: "General Inquiry",
    subject: "",
    message: "",
  });

  const [isLoading, setIsLoading] = useState(false);
  const [submittedTicket, setSubmittedTicket] = useState<string | null>(null);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage(null);
    setIsLoading(true);

    try {
      const res = await fetch("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await res.json();
      if (!res.ok || !data.success) {
        throw new Error(data.error || "Failed to submit message.");
      }

      setSubmittedTicket(data.ticketId);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : "Error sending message.";
      setErrorMessage(msg);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Contact Us", href: "/contact" }]} />

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
          {/* Left: Contact Info */}
          <div className="lg:col-span-5 space-y-6">
            <Badge variant="primary" size="md">
              <MessageSquare className="w-3.5 h-3.5 text-[#1868db]" />
              <span>Get in Touch</span>
            </Badge>

            <h1 className="text-4xl sm:text-5xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
              Contact Qrie AI
            </h1>

            <p className="text-base text-[#42526e] leading-[1.5] font-normal">
              Have questions about our Learning Adaptation Model, school software deployment, or student
              subscriptions? Our team is here to support you.
            </p>

            <div className="space-y-4 pt-4 border-t border-[#f0f1f2] text-[13px] text-[#42526e] font-normal">
              <div className="flex items-start gap-3">
                <MapPin className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                <div>
                  <strong className="text-[#101214] block font-semibold">Bengaluru Technology Office:</strong>
                  <span>Outer Ring Road, Bellandur, Bengaluru, Karnataka 560103</span>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <Mail className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                <div>
                  <strong className="text-[#101214] block font-semibold">Support & Inquiry:</strong>
                  <a href={`mailto:${siteConfig.contactEmail}`} className="hover:text-[#1868db] underline">
                    {siteConfig.contactEmail}
                  </a>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <Clock className="w-4 h-4 text-[#1868db] shrink-0 mt-0.5" />
                <div>
                  <strong className="text-[#101214] block font-semibold">Operating Hours:</strong>
                  <span>Monday – Friday: 9:00 AM – 6:30 PM IST</span>
                </div>
              </div>
            </div>
          </div>

          {/* Right: Functional Form in 20px card */}
          <div className="lg:col-span-7 bg-white rounded-[20px] p-6 sm:p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px]">
            {submittedTicket ? (
              <div className="py-12 text-center space-y-4 animate-in fade-in">
                <div className="w-16 h-16 rounded-[20px] bg-[#e3fcef] text-[#006644] flex items-center justify-center mx-auto">
                  <CheckCircle2 className="w-8 h-8" />
                </div>
                <h3 className="text-2xl font-medium tracking-[0.012em] text-[#101214]">Message Delivered!</h3>
                <p className="text-[14px] text-[#42526e] max-w-sm mx-auto leading-relaxed font-normal">
                  Your ticket has been logged under reference:
                </p>
                <div className="inline-block px-4 py-2 rounded-[28px] bg-[#f0f1f2] font-mono text-sm font-bold text-[#1868db]">
                  {submittedTicket}
                </div>
                <p className="text-[13px] text-[#42526e] pt-2 font-normal">
                  A representative will review your message and reply via email within 24 hours.
                </p>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
                <h3 className="text-lg font-medium text-[#101214] mb-2 tracking-[0.012em]">Send Us a Message</h3>

                {errorMessage && (
                  <div className="p-3.5 rounded-[8px] bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-center gap-2">
                    <AlertCircle className="w-4 h-4 shrink-0" />
                    <span>{errorMessage}</span>
                  </div>
                )}

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-[12px] font-bold text-[#292a2e] mb-1 uppercase tracking-wide">
                      Your Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      placeholder="Rohit Verma"
                      className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] bg-white text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                    />
                  </div>

                  <div>
                    <label className="block text-[12px] font-bold text-[#292a2e] mb-1 uppercase tracking-wide">
                      Your Email *
                    </label>
                    <input
                      type="email"
                      required
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      placeholder="rohit@example.com"
                      className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] bg-white text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-[12px] font-bold text-[#292a2e] mb-1 uppercase tracking-wide">
                      Inquiry Category
                    </label>
                    <select
                      value={formData.category}
                      onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                      className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] bg-white text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                    >
                      <option value="General Inquiry">General Inquiry</option>
                      <option value="School Onboarding">School Onboarding & Software</option>
                      <option value="Student App Support">Student App & Subscriptions</option>
                      <option value="LAM Research">LAM Research & Partnerships</option>
                      <option value="Security / DPDP">Data Privacy & Security</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-[12px] font-bold text-[#292a2e] mb-1 uppercase tracking-wide">
                      Subject *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.subject}
                      onChange={(e) => setFormData({ ...formData, subject: e.target.value })}
                      placeholder="Question regarding..."
                      className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] bg-white text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-[12px] font-bold text-[#292a2e] mb-1 uppercase tracking-wide">
                    Your Message *
                  </label>
                  <textarea
                    rows={4}
                    required
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    placeholder="Provide details about your query..."
                    className="w-full px-3.5 py-2.5 rounded-[8px] border border-[#b7b9be] bg-white text-[14px] focus:outline-none focus:border-[#1868db] focus:ring-1 focus:ring-[#1868db]"
                  />
                </div>

                <Button
                  type="submit"
                  variant="primary"
                  size="lg"
                  className="w-full"
                  isLoading={isLoading}
                >
                  Send Message
                </Button>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
