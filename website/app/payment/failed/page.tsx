import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Button } from "@/components/ui/Button";
import { AlertTriangle, ArrowRight, RotateCcw, Mail } from "lucide-react";

export const metadata: Metadata = {
  title: "Payment Failed — Qrie AI",
  description: "Troubleshooting guidance for failed payment transactions on Qrie AI.",
};

export default function PaymentFailedPage() {
  return (
    <div className="py-20 bg-[#ffffff]">
      <div className="max-w-md mx-auto px-4 text-center space-y-6 bg-white p-8 sm:p-10 rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.08)_0px_1px_2px_0px]">
        <div className="w-16 h-16 rounded-[20px] bg-rose-50 text-rose-600 border border-rose-100 flex items-center justify-center mx-auto">
          <AlertTriangle className="w-8 h-8" />
        </div>

        <div className="space-y-2">
          <h1 className="text-2xl font-normal font-serif text-[#101214]">Payment Unsuccessful</h1>
          <p className="text-sm text-[#42526e] leading-relaxed">
            The payment gateway declined the transaction. This can occur due to bank OTP timeouts,
            insufficient funds, or card international/online transaction restrictions.
          </p>
        </div>

        <div className="text-left bg-slate-50 p-4 rounded-[8px] border border-[#f0f1f2] text-xs space-y-2 text-[#292a2e]">
          <div className="font-bold text-[#101214]">Recommended Troubleshooting:</div>
          <ul className="space-y-1 list-disc pl-4 text-xs text-[#42526e]">
            <li>Try paying via an alternative UPI app (e.g. PhonePe or Google Pay).</li>
            <li>Ensure online e-commerce transactions are enabled on your debit/credit card.</li>
            <li>Contact your issuing bank if payment verification fails repeatedly.</li>
          </ul>
        </div>

        <div className="flex flex-col gap-2.5 pt-2">
          <Button href="/checkout" variant="primary" size="md" icon={<RotateCcw className="w-4 h-4" />}>
            Retry Checkout
          </Button>
          <Button href="/contact" variant="outline" size="md" icon={<Mail className="w-4 h-4" />}>
            Contact Support Desk
          </Button>
        </div>
      </div>
    </div>
  );
}
