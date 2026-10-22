"use client";

import React, { Suspense } from "react";
import { useSearchParams } from "next/navigation";
import { Button } from "@/components/ui/Button";
import { CheckCircle2 } from "lucide-react";

function SuccessContent() {
  const searchParams = useSearchParams();
  const orderId = searchParams.get("orderId") || "QRIE-ORD-VERIFIED";

  return (
    <div className="max-w-2xl mx-auto bg-white rounded-[20px] border border-[#f0f1f2] p-8 sm:p-12 text-center space-y-6 shadow-[rgba(9,30,66,0.31)_0px_0px_1px_0px,rgba(9,30,66,0.25)_0px_1px_1px_0px]">
      <div className="w-16 h-16 rounded-[20px] bg-[#e3fcef] text-[#006644] flex items-center justify-center mx-auto">
        <CheckCircle2 className="w-8 h-8" />
      </div>

      <div className="space-y-2">
        <span className="text-[12px] font-bold uppercase tracking-wider text-[#006644] bg-[#e3fcef] px-3 py-1 rounded-full">
          Payment Authoritatively Verified
        </span>
        <h1 className="text-3xl font-medium tracking-[0.012em] text-[#101214]">
          Thank You for Joining Qrie AI!
        </h1>
        <p className="text-[14px] text-[#42526e] leading-[1.6] font-normal">
          Your educational software license has been activated. A verified tax invoice and access key
          have been dispatched to your registered email address.
        </p>
      </div>

      {/* Order Reference Box */}
      <div className="p-4 rounded-[12px] bg-[#f0f1f2] text-xs space-y-1">
        <div className="text-[#42526e] font-medium uppercase tracking-wider text-[11px]">
          Official Order Reference
        </div>
        <div className="font-mono text-base font-bold text-[#101214]">{orderId}</div>
      </div>

      {/* Next Steps */}
      <div className="text-left bg-[#e9f2fe] rounded-[16px] p-5 text-xs space-y-2.5 font-normal">
        <div className="font-bold text-[#1868db] text-[13px]">Next Steps to Begin Learning:</div>
        <ul className="space-y-1.5 text-[#292a2e] text-[13px]">
          <li className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
            <span>Install the Qrie Student Android App on your smartphone or tablet.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
            <span>Sign in with your registered email to automatically unlock unlimited AI Tutor access.</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="w-1.5 h-1.5 rounded-full bg-[#1868db] mt-2 shrink-0" />
            <span>Take the initial diagnostic check to calibrate your personalized LAM learning curve.</span>
          </li>
        </ul>
      </div>

      <div className="flex flex-col sm:flex-row items-center justify-center gap-3 pt-4">
        <Button href="/demo" variant="primary" size="md">
          Explore Student Dashboard
        </Button>
        <Button href="/products" variant="outline" size="md">
          Explore More Products
        </Button>
      </div>
    </div>
  );
}

export default function CheckoutSuccessPage() {
  return (
    <div className="py-16 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8">
        <Suspense fallback={<div className="py-20 text-center text-sm text-[#42526e]">Loading receipt...</div>}>
          <SuccessContent />
        </Suspense>
      </div>
    </div>
  );
}
