import React, { Suspense } from "react";
import type { Metadata } from "next";
import Link from "next/link";
import { Breadcrumbs } from "@/components/layout/Breadcrumbs";
import { Button } from "@/components/ui/Button";
import { Badge } from "@/components/ui/Badge";
import { CheckCircle2, Clock, Package, Download, ShieldCheck, Mail } from "lucide-react";

export async function generateStaticParams() {
  return [{ id: "sample" }];
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  return {
    title: `Order Status: ${id} — Qrie AI`,
    description: `Official order details and license activation status for reference ${id}.`,
  };
}

export default async function OrderDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  return (
    <div className="py-12 bg-white">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <Breadcrumbs
          items={[
            { label: "Orders", href: "/orders" },
            { label: id, href: `/orders/${id}` },
          ]}
        />

        <div className="bg-white rounded-[20px] p-6 sm:p-10 border border-[#f0f1f2] shadow-[rgba(9,30,66,0.08)_0px_1px_2px_0px] space-y-8">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-[#f0f1f2] pb-6">
            <div>
              <span className="text-[11px] font-bold text-[#42526e] uppercase tracking-wider">
                Order Tracking Record
              </span>
              <h1 className="text-2xl sm:text-3xl font-normal font-serif text-[#101214]">{id}</h1>
            </div>
            <span className="px-3 py-1 rounded-[10000px] bg-emerald-50 text-emerald-800 border border-emerald-200 text-xs font-medium flex items-center gap-1.5 w-fit">
              <CheckCircle2 className="w-4 h-4 text-emerald-600" />
              <span>ACTIVE & VERIFIED</span>
            </span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 text-xs">
            <div className="space-y-1">
              <span className="text-[#42526e] font-medium uppercase">Fulfillment Status</span>
              <div className="font-bold text-[#101214] text-sm">License Provisioned</div>
            </div>
            <div className="space-y-1">
              <span className="text-[#42526e] font-medium uppercase">Payment Gateway</span>
              <div className="font-bold text-[#101214] text-sm">Verified Server Record</div>
            </div>
            <div className="space-y-1">
              <span className="text-[#42526e] font-medium uppercase">Platform App</span>
              <div className="font-bold text-[#101214] text-sm">Qrie Student App (Android)</div>
            </div>
          </div>

          <div className="p-4 rounded-[8px] bg-slate-50 border border-[#f0f1f2] space-y-2 text-xs">
            <div className="font-bold text-[#101214]">License Activation Instructions:</div>
            <p className="text-[#42526e] leading-relaxed">
              Open the Qrie Student Android App on your device. Sign in using the exact email address
              provided during checkout. Your Student Pro tier benefits and unlimited AI Tutor sessions
              will be unlocked automatically across your devices.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-4 border-t border-[#f0f1f2]">
            <Button href="/demo" variant="primary" size="md">
              Access Web Demo
            </Button>
            <Button href="/orders" variant="outline" size="md">
              Track Another Order
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
