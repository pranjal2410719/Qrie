import React from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Button } from "@/components/ui/Button";
import { XCircle, ArrowLeft, ShoppingCart, HelpCircle } from "lucide-react";

export const metadata: Metadata = {
  title: "Payment Cancelled — Qrie AI",
  description: "Your payment attempt was cancelled. No charges were made to your account.",
};

export default function PaymentCancelledPage() {
  return (
    <div className="py-20 bg-slate-50/50">
      <div className="max-w-md mx-auto px-4 text-center space-y-6 bg-white p-8 sm:p-10 rounded-3xl border border-slate-200">
        <div className="w-16 h-16 rounded-3xl bg-amber-100 text-amber-600 flex items-center justify-center mx-auto">
          <XCircle className="w-8 h-8" />
        </div>

        <div className="space-y-2">
          <h1 className="text-2xl font-bold text-slate-900">Payment Cancelled</h1>
          <p className="text-xs text-slate-600 leading-relaxed">
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

        <div className="text-[11px] text-slate-400">
          Encountering payment issues? Contact <a href="mailto:support@qrie.ai" className="text-sky-600 underline">support@qrie.ai</a>.
        </div>
      </div>
    </div>
  );
}
