import React from "react";
import type { Metadata } from "next";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { CartView } from "@/components/commerce/CartView";
import { Badge } from "@/components/ui/Badge";
import { ShoppingCart } from "lucide-react";

export const metadata: Metadata = {
  title: "Shopping Cart — Qrie AI",
  description: "Review your selected Qrie AI educational software, subscriptions, and diagnostic licenses.",
};

export default function CartPage() {
  return (
    <div className="py-12 bg-white">
      <div className="max-w-[1200px] mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Shopping Cart", href: "/cart" }]} />

        <div className="max-w-3xl space-y-3">
          <Badge variant="primary" size="md">
            <ShoppingCart className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Review & Order</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-medium text-[#101214] tracking-[0.012em] leading-tight">
            Your Selected Software & Licenses
          </h1>
          <p className="text-base text-[#42526e] leading-[1.5] font-normal">
            Review your selected educational licenses before proceeding to secure payment.
          </p>
        </div>

        <CartView />
      </div>
    </div>
  );
}
