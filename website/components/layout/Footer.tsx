import React from "react";
import Link from "next/link";
import Image from "next/image";
import { siteConfig } from "@/lib/seo/siteConfig";
import { ShieldCheck, Mail, MapPin, ExternalLink, Globe2 } from "lucide-react";

export function Footer() {
  const currentYear = 2026;

  return (
    <footer className="bg-[#101214] text-[#b7b9be] border-t border-[#292a2e] pt-16 pb-12 font-sans">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 lg:gap-8 pb-12 border-b border-[#292a2e]">
          {/* Brand Info & Mission */}
          <div className="lg:col-span-2 space-y-4">
            <Link href="/" className="flex items-center gap-2.5 group">
              <div className="relative w-8 h-8 rounded-[8px] overflow-hidden bg-white p-0.5 border border-[#292a2e]">
                <Image
                  src="/Q_logo.png"
                  alt="Qrie AI Logo"
                  fill
                  sizes="32px"
                  className="object-contain"
                />
              </div>
              <span className="font-semibold text-lg text-white tracking-tight">
                Qrie <span className="text-[#1868db]">AI</span>
              </span>
            </Link>

            <p className="text-[14px] text-[#b7b9be] leading-relaxed max-w-sm font-normal">
              Enterprise-grade adaptive learning system powered by the Learning Adaptation Model (LAM).
              Personalizing K-12 NCERT education with continuous Bayesian knowledge tracing and connected
              applications for students, teachers, and school leadership.
            </p>

            <div className="flex items-center gap-2.5 pt-2 text-[13px] text-emerald-400 font-medium">
              <ShieldCheck className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>India DPDP Act 2023 Compliant • Tenant-Isolated Data</span>
            </div>

            {/* Geographic & Contact Details for GEO */}
            <div className="pt-2 text-[13px] text-[#b7b9be] space-y-1.5 font-normal">
              <div className="flex items-start gap-2">
                <MapPin className="w-3.5 h-3.5 text-[#1868db] shrink-0 mt-0.5" />
                <span>Outer Ring Road, Bellandur, Bengaluru, Karnataka 560103, India</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="w-3.5 h-3.5 text-[#1868db] shrink-0" />
                <a
                  href={`mailto:${siteConfig.contactEmail}`}
                  className="hover:text-white transition-colors"
                >
                  {siteConfig.contactEmail}
                </a>
              </div>
              <div className="flex items-center gap-2">
                <Globe2 className="w-3.5 h-3.5 text-[#1868db] shrink-0" />
                <span>Serving CBSE, ICSE & State Board Schools Pan-India</span>
              </div>
            </div>
          </div>

          {/* Column 1: Platform & AI */}
          <div>
            <h3 className="text-[12px] font-bold text-white uppercase tracking-wider mb-4">
              Platform & AI
            </h3>
            <ul className="space-y-2.5 text-[14px]">
              <li>
                <Link href="/platform" className="hover:text-white transition-colors">
                  Platform Overview
                </Link>
              </li>
              <li>
                <Link
                  href="/lam"
                  className="hover:text-white transition-colors flex items-center gap-1.5"
                >
                  <span>LAM (AI Engine)</span>
                  <span className="text-[10px] bg-[#1c2b42] text-[#1868db] px-1.5 py-0.2 rounded font-bold">
                    BKT
                  </span>
                </Link>
              </li>
              <li>
                <Link href="/how-it-works" className="hover:text-white transition-colors">
                  How Qrie Works
                </Link>
              </li>
              <li>
                <Link href="/ai-tutor" className="hover:text-white transition-colors">
                  24/7 Socratic AI Tutor
                </Link>
              </li>
              <li>
                <Link href="/demo" className="hover:text-white transition-colors">
                  Interactive Product Demo
                </Link>
              </li>
              <li>
                <Link
                  href="/products/qrie-student-app"
                  className="hover:text-white transition-colors"
                >
                  Student Android App
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 2: For Schools */}
          <div>
            <h3 className="text-[12px] font-bold text-white uppercase tracking-wider mb-4">
              For Schools
            </h3>
            <ul className="space-y-2.5 text-[14px]">
              <li>
                <Link href="/schools" className="hover:text-white transition-colors">
                  School Software Ecosystem
                </Link>
              </li>
              <li>
                <Link href="/school-demo" className="hover:text-white transition-colors">
                  Request School Demo
                </Link>
              </li>
              <li>
                <Link href="/teachers" className="hover:text-white transition-colors">
                  Teacher Co-Pilot & Rosters
                </Link>
              </li>
              <li>
                <Link href="/parents" className="hover:text-white transition-colors">
                  Parent Progress Portal
                </Link>
              </li>
              <li>
                <Link href="/students" className="hover:text-white transition-colors">
                  Student Learning Experience
                </Link>
              </li>
              <li>
                <Link
                  href="/services/school-onboarding-implementation"
                  className="hover:text-white transition-colors"
                >
                  School Onboarding & Training
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 3: Commercial & Legal */}
          <div>
            <h3 className="text-[12px] font-bold text-white uppercase tracking-wider mb-4">
              Products & Trust
            </h3>
            <ul className="space-y-2.5 text-[14px]">
              <li>
                <Link href="/products" className="hover:text-white transition-colors">
                  Products Catalogue
                </Link>
              </li>
              <li>
                <Link href="/services" className="hover:text-white transition-colors">
                  Services & Implementation
                </Link>
              </li>
              <li>
                <Link href="/pricing" className="hover:text-white transition-colors">
                  Pricing & Plan Comparison
                </Link>
              </li>
              <li>
                <Link href="/get-a-quote" className="hover:text-white transition-colors">
                  Request a Custom Quote
                </Link>
              </li>
              <li>
                <Link href="/resources" className="hover:text-white transition-colors">
                  Research & Articles
                </Link>
              </li>
              <li>
                <Link href="/faq" className="hover:text-white transition-colors">
                  Frequently Asked Questions
                </Link>
              </li>
              <li>
                <Link href="/privacy" className="hover:text-white transition-colors">
                  Privacy Policy (DPDP 2023)
                </Link>
              </li>
              <li>
                <Link href="/terms" className="hover:text-white transition-colors">
                  Terms of Service
                </Link>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Disclaimer & Copyright */}
        <div className="pt-8 flex flex-col md:flex-row items-center justify-between gap-4 text-[13px] text-[#b7b9be]">
          <p>
            © {currentYear} {siteConfig.legalName}. All rights reserved. Built with precision for Indian K-12 education.
          </p>
          <div className="flex items-center gap-6">
            <Link href="/privacy" className="hover:text-white transition-colors">
              Privacy
            </Link>
            <Link href="/terms" className="hover:text-white transition-colors">
              Terms
            </Link>
            <Link href="/contact" className="hover:text-white transition-colors">
              Support Desk
            </Link>
            <a
              href={siteConfig.social.github}
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-white transition-colors inline-flex items-center gap-1"
            >
              <span>GitHub</span>
              <ExternalLink className="w-3 h-3" />
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
