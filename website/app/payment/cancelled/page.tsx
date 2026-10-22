import React from "react";
import type { Metadata } from "next";
import { Button } from "@/components/ui/Button";
import { XCircle, ArrowLeft, ShoppingCart } from "lucide-react";

export const metadata: Metadata = {
  title: "Payment Cancelled — Qrie AI",
  description: "Your payment attempt was cancelled. No charges were made to your account.",
};

export default function PaymentCancelledPage() {
  return (
    <div className="py-20 bg-[#ffffff]">
      <div className="max-w-md mx-auto px-4 text-center space-y-6 bg-white p-8 sm:p-10 rounded-[20px] border border-[#f0f1f2] shadow-[rgba(9,30,66,0.08)_0px_1px_2px_0px]">
        <div className="w-16 h-16 rounded-[20px] bg-amber-50 text-amber-600 border border-amber-200 flex items-center justify-center mx-auto">
          <XCircle className="w-8 h-8" />
        </div>

        <div className="space-y-2">
          <h1 className="text-2xl font-normal font-serif text-[#101214]">Payment Cancelled</h1>
          <p className="text-sm text-[#42526e] leading-relaxed">
            Your transaction was interrupted before completion. No charges have been made to your payment
            card or UPI account. Your selected items remain saved in your cart.
          </p>
        </div>

        <div className="flex flex-col gap-2.5 pt-2">
          <Button href="/cart" variant="primary" size="md" icon={<ShoppingCart className="w-4 h-4" />}>
            Return to Cart & Retry
          </Button>
          <Button href="/pricing" variant="outline" size="md" icon={<ArrowLeft className="w-4 h-4" />}>
            Review Pricing Plans
          </Button>
        </div>

        <div className="text-[11px] text-[#42526e]">
          Encountering payment issues? Contact <a href="mailto:support@qrie.ai" className="text-[#1868db] underline">support@qrie.ai</a>.
        </div>
      </div>
    </div>
  );
}
