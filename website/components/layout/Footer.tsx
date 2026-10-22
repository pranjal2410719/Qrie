import React from "react";
import Link from "next/link";
import Image from "next/image";
import { siteConfig } from "@/lib/seo/siteConfig";
import { ShieldCheck, Mail, Phone, MapPin, ExternalLink } from "lucide-react";

export function Footer() {
  const currentYear = 2026;

  return (
    <footer className="bg-slate-950 text-slate-300 border-t border-slate-900 pt-16 pb-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 lg:gap-8 pb-12 border-b border-slate-800/80">
          {/* Brand Info & Mission */}
          <div className="lg:col-span-2 space-y-4">
            <Link href="/" className="flex items-center gap-3 group">
              <div className="relative w-9 h-9 rounded-xl overflow-hidden bg-white p-1">
                <Image
                  src="/Q_logo.png"
                  alt="Qrie AI Logo"
                  fill
                  className="object-contain"
                />
              </div>
              <span className="font-extrabold text-xl text-white tracking-tight">
                Qrie <span className="text-sky-400">AI</span>
              </span>
            </Link>

            <p className="text-sm text-slate-400 leading-relaxed max-w-sm">
              Adaptive, school-ready educational platform powered by the Learning Adaptation Model (LAM).
              Transforming NCERT K-12 education with personalized learning, continuous Bayesian mastery tracking,
              and connected apps for students, teachers, and school administrators.
            </p>

            <div className="flex items-center gap-3 pt-2 text-xs text-emerald-400 font-medium">
              <ShieldCheck className="w-4 h-4 text-emerald-400 shrink-0" />
              <span>Compliant with India DPDP Act 2023 & Student Data Protections</span>
            </div>

            <div className="pt-2 text-xs text-slate-400 space-y-1">
              <div className="flex items-center gap-2">
                <MapPin className="w-3.5 h-3.5 text-slate-500" />
                <span>Outer Ring Road, Bellandur, Bengaluru, Karnataka 560103</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="w-3.5 h-3.5 text-slate-500" />
                <a href={`mailto:${siteConfig.contactEmail}`} className="hover:text-white transition-colors">
                  {siteConfig.contactEmail}
                </a>
              </div>
            </div>
          </div>

          {/* Column 1: Platform & AI */}
          <div>
            <h3 className="text-xs font-bold text-white uppercase tracking-wider mb-4">
              Platform & AI
            </h3>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/platform" className="hover:text-white transition-colors">
                  Platform Overview
                </Link>
              </li>
              <li>
                <Link href="/lam" className="hover:text-white transition-colors flex items-center gap-1.5">
                  <span>LAM (AI Engine)</span>
                  <span className="text-[10px] bg-sky-950 text-sky-400 px-1.5 py-0.5 rounded border border-sky-800 font-bold">
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
                  24/7 AI Tutor
                </Link>
              </li>
              <li>
                <Link href="/demo" className="hover:text-white transition-colors">
                  Interactive Product Demo
                </Link>
              </li>
              <li>
                <Link href="/products/qrie-student-app" className="hover:text-white transition-colors">
                  Student Android App
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 2: For Schools */}
          <div>
            <h3 className="text-xs font-bold text-white uppercase tracking-wider mb-4">
              For Schools
            </h3>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/schools" className="hover:text-white transition-colors">
                  School Software Ecosystem
                </Link>
              </li>
              <li>
                <Link href="/school-demo" className="hover:text-white transition-colors">
                  Book School Demonstration
                </Link>
              </li>
              <li>
                <Link href="/teachers" className="hover:text-white transition-colors">
                  For Teachers & Co-Pilot
                </Link>
              </li>
              <li>
                <Link href="/parents" className="hover:text-white transition-colors">
                  For Parents
                </Link>
              </li>
              <li>
                <Link href="/students" className="hover:text-white transition-colors">
                  For Students
                </Link>
              </li>
              <li>
                <Link href="/services/school-onboarding-implementation" className="hover:text-white transition-colors">
                  School Onboarding Service
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 3: Commercial & Legal */}
          <div>
            <h3 className="text-xs font-bold text-white uppercase tracking-wider mb-4">
              Products & Legal
            </h3>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/products" className="hover:text-white transition-colors">
                  Products Catalogue
                </Link>
              </li>
              <li>
                <Link href="/services" className="hover:text-white transition-colors">
                  Services Catalogue
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
                  Articles & Resources
                </Link>
              </li>
              <li>
                <Link href="/faq" className="hover:text-white transition-colors">
                  Frequently Asked Questions
                </Link>
              </li>
              <li>
                <Link href="/privacy" className="hover:text-white transition-colors">
                  Privacy Policy (DPDP Act)
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
        <div className="pt-8 flex flex-col md:flex-row items-center justify-between gap-4 text-xs text-slate-500">
          <p>
            © {currentYear} {siteConfig.legalName}. All rights reserved. Qrie and Learning Adaptation Model (LAM) are proprietary educational technology systems.
          </p>
          <div className="flex items-center gap-6">
            <Link href="/privacy" className="hover:text-slate-400 transition-colors">
              Privacy
            </Link>
            <Link href="/terms" className="hover:text-slate-400 transition-colors">
              Terms
            </Link>
            <Link href="/contact" className="hover:text-slate-400 transition-colors">
              Support Desk
            </Link>
            <a
              href={siteConfig.social.github}
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-slate-400 transition-colors inline-flex items-center gap-1"
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
