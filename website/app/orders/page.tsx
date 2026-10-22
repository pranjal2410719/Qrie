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
            <Package className="w-3.5 h-3.5 text-sky-600" />
            <span>Customer Portal</span>
          </Badge>
          <h1 className="text-3xl sm:text-4xl font-black text-slate-900 tracking-tight leading-tight">
            Track Your Order & License Status
          </h1>
          <p className="text-sm text-slate-600">
            Enter your official Qrie order reference to view your license activation status, receipt, and tax invoice.
          </p>
        </div>

        <div className="max-w-xl bg-slate-50 rounded-3xl p-6 sm:p-8 border border-slate-200 space-y-6">
          <form onSubmit={handleLookup} className="space-y-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 mb-1.5 uppercase tracking-wide">
                Order Reference (e.g. QRIE-ORD-...)
              </label>
              <div className="relative">
                <input
                  type="text"
                  required
                  value={orderQuery}
                  onChange={(e) => setOrderQuery(e.target.value)}
                  placeholder="QRIE-ORD-XXXX-XXXX"
                  className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-300 bg-white text-sm font-mono focus:outline-none focus:ring-2 focus:ring-sky-500 uppercase"
                />
                <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
              </div>
            </div>

            <Button type="submit" variant="primary" size="md" className="w-full" icon={<ArrowRight className="w-4 h-4" />}>
              Find Order Details
            </Button>
          </form>

          <div className="text-center pt-2 text-xs text-slate-400">
            Lost your order ID? Check your registration email or contact <a href="mailto:support@qrie.ai" className="text-sky-600 underline">support@qrie.ai</a>.
          </div>
        </div>
      </div>
    </div>
  );
}
