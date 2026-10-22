"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { Search, Package, ArrowRight, ShieldCheck } from "lucide-react";

export default function OrdersPage() {
  const [orderQuery, setOrderQuery] = useState("");
  const router = useRouter();

  const handleLookup = (e: React.FormEvent) => {
    e.preventDefault();
    if (orderQuery.trim()) {
      router.push(`/orders/${encodeURIComponent(orderQuery.trim().toUpperCase())}`);
    }
  };

  return (
    <div className="py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs items={[{ label: "Order Tracking", href: "/orders" }]} />

        <div className="max-w-3xl space-y-3">
          <Badge variant="primary" size="md">
            <Package className="w-3.5 h-3.5 text-[#1868db]" />
            <span>Customer Portal</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-normal font-serif text-[#101214] tracking-[-0.012em] leading-tight">
            Track Your Order & License Status
          </h1>
          <p className="text-base text-[#42526e]">
            Enter your official Qrie order reference to view your license activation status, receipt, and tax invoice.
          </p>
        </div>

        <div className="max-w-xl bg-white rounded-[20px] p-6 sm:p-8 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.08)_0px_1px_2px_0px] space-y-6">
          <form onSubmit={handleLookup} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-[#292a2e] mb-1.5 uppercase tracking-wide">
                Order Reference (e.g. QRIE-ORD-...)
              </label>
              <div className="relative">
                <input
                  type="text"
                  required
                  value={orderQuery}
                  onChange={(e) => setOrderQuery(e.target.value)}
                  placeholder="QRIE-ORD-XXXX-XXXX"
                  className="w-full pl-10 pr-4 py-3 rounded-[8px] border border-[#f0f1f2] bg-white text-sm font-mono focus:outline-none focus:ring-2 focus:ring-[#1868db] focus:border-[#1868db] uppercase"
                />
                <Search className="w-4 h-4 text-[#42526e] absolute left-3.5 top-3.5" />
              </div>
            </div>

            <Button type="submit" variant="primary" size="md" className="w-full" icon={<ArrowRight className="w-4 h-4" />}>
              Find Order Details
            </Button>
          </form>

          <div className="text-center pt-2 text-xs text-[#42526e]">
            Lost your order ID? Check your registration email or contact <a href="mailto:support@qrie.ai" className="text-[#1868db] underline">support@qrie.ai</a>.
          </div>
        </div>
      </div>
    </div>
  );
}
