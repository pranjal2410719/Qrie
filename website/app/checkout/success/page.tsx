"use client";

import React, { Suspense } from "react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { Button } from "@/components/ui/Button";
import { CheckCircle2, Download, ArrowRight, ShieldCheck, Mail } from "lucide-react";

function SuccessContent() {
  const searchParams = useSearchParams();
  const orderId = searchParams.get("orderId") || "QRIE-ORD-VERIFIED";

  return (
    <div className="max-w-2xl mx-auto bg-white rounded-3xl border border-slate-200 p-8 sm:p-12 text-center space-y-6 shadow-sm">
      <div className="w-20 h-20 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto animate-in zoom-in">
        <CheckCircle2 className="w-10 h-10" />
      </div>

      <div className="space-y-2">
        <span className="text-xs font-bold uppercase tracking-wider text-emerald-600 bg-emerald-50 px-3 py-1 rounded-full border border-emerald-200">
          Payment Authoritatively Verified
        </span>
        <h1 className="text-3xl font-black text-slate-900">
          Thank You for Joining Qrie AI!
        </h1>
        <p className="text-sm text-slate-600 leading-relaxed">
          Your educational software license has been activated. A verified tax invoice and access key
          have been dispatched to your registered email address.
        </p>
      </div>

      {/* Order Reference Box */}
      <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200 text-xs space-y-1">
        <div className="text-slate-400 font-semibold uppercase tracking-wider">
          Official Order Reference
        </div>
        <div className="font-mono text-sm font-bold text-slate-900">{orderId}</div>
      </div>

      {/* Next Steps */}
      <div className="text-left bg-sky-50/60 rounded-2xl p-5 border border-sky-100 text-xs space-y-2.5">
        <div className="font-bold text-sky-900">Next Steps to Begin Learning:</div>
        <ul className="space-y-1.5 text-slate-700">
          <li className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-sky-600 mt-1.5 shrink-0" />
            <span>Install the Qrie Student Android App on your smartphone or tablet.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-sky-600 mt-1.5 shrink-0" />
            <span>Sign in with your registered email to automatically unlock unlimited AI Tutor access.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-sky-600 mt-1.5 shrink-0" />
            <span>Take the initial diagnostic check to calibrate your personalized LAM learning curve.</span>
          </li>
        </ul>
      </div>

      <div className="flex flex-col sm:flex-row items-center justify-center gap-3 pt-4">
        <Button href="/demo" variant="primary" size="md">
          Open Web Demonstration
        </Button>
        <Button href={`/orders/${encodeURIComponent(orderId)}`} variant="outline" size="md">
          Track Order Status
        </Button>
      </div>

      <div className="pt-4 text-[11px] text-slate-400 flex items-center justify-center gap-1.5">
        <Mail className="w-3.5 h-3.5 text-slate-400" />
        <span>Need help? Contact support@qrie.ai quoting your order ID.</span>
      </div>
    </div>
  );
}

export default function CheckoutSuccessPage() {
  return (
    <div className="py-16 bg-slate-50/50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <Suspense fallback={<div className="py-12 text-center text-sm text-slate-500">Loading order receipt...</div>}>
          <SuccessContent />
        </Suspense>
      </div>
    </div>
  );
}
