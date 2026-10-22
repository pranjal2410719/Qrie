import React, { Suspense } from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { CheckoutForm } from "@/components/commerce/CheckoutForm";
import { Badge } from "@/components/ui/Badge";
import { Lock } from "lucide-react";

export const metadata: Metadata = {
  title: "Checkout — Qrie AI",
  description: "Secure payment checkout for Qrie AI educational software and subscriptions.",
};

export default function CheckoutPage() {
  return (
    <div className="py-12 bg-slate-50/50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs
          items={[
            { label: "Cart", href: "/cart" },
            { label: "Checkout", href: "/checkout" },
          ]}
        />

        <div className="max-w-3xl space-y-3">
          <Badge variant="primary" size="md">
            <Lock className="w-3.5 h-3.5 text-sky-600" />
            <span>Secure 256-Bit SSL Checkout</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight leading-tight">
            Complete Your Educational License Purchase
          </h1>
          <p className="text-sm text-slate-600">
            Provide customer registration and billing details to activate your software license immediately.
          </p>
        </div>

        <Suspense fallback={<div className="py-12 text-center text-sm text-slate-500">Loading checkout...</div>}>
          <CheckoutForm />
        </Suspense>
      </div>
    </div>
  );
}
