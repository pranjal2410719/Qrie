import React from "react";
import Link from "next/link";
import { featureComparisonMatrix } from "@/lib/data/pricing";
import { Check, X, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/Button";

export function PlanComparisonTable() {
  return (
    <div className="overflow-x-auto pb-6">
      <table className="w-full text-left border-collapse min-w-[700px]">
        <thead>
          <tr className="border-b border-slate-200">
            <th className="py-4 px-6 text-sm font-bold text-slate-900 w-2/5">
              Features & Capabilities
            </th>
            <th className="py-4 px-4 text-xs font-bold text-slate-600 text-center w-[15%]">
              Starter
            </th>
            <th className="py-4 px-4 text-xs font-bold text-sky-600 text-center w-[15%] bg-sky-50/50 rounded-t-xl">
              Student Pro
            </th>
            <th className="py-4 px-4 text-xs font-bold text-indigo-600 text-center w-[15%]">
              School Essential
            </th>
            <th className="py-4 px-4 text-xs font-bold text-slate-900 text-center w-[15%]">
              Enterprise
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-100 text-xs">
          {featureComparisonMatrix.map((cat) => (
            <React.Fragment key={cat.category}>
              <tr className="bg-slate-50/80">
                <td
                  colSpan={5}
                  className="py-3 px-6 font-bold text-slate-800 uppercase tracking-wider text-[11px]"
                >
                  {cat.category}
                </td>
              </tr>
              {cat.items.map((item, idx) => (
                <tr key={idx} className="hover:bg-slate-50/50 transition-colors">
                  <td className="py-3.5 px-6 font-medium text-slate-700">
                    {item.feature}
                  </td>
                  <td className="py-3.5 px-4 text-center">
                    {renderValue(item.starter)}
                  </td>
                  <td className="py-3.5 px-4 text-center bg-sky-50/30 font-semibold">
                    {renderValue(item.pro)}
                  </td>
                  <td className="py-3.5 px-4 text-center">
                    {renderValue(item.school)}
                  </td>
                  <td className="py-3.5 px-4 text-center">
                    {renderValue(item.enterprise)}
                  </td>
                </tr>
              ))}
            </React.Fragment>
          ))}
        </tbody>
        <tfoot>
          <tr className="border-t border-slate-200">
            <td className="py-6 px-6 font-bold text-slate-900">Get Started</td>
            <td className="py-6 px-4 text-center">
              <Button href="/demo" variant="outline" size="sm">
                Try Free
              </Button>
            </td>
            <td className="py-6 px-4 text-center bg-sky-50/50">
              <Button href="/checkout?product=qrie-student-app" variant="primary" size="sm">
                Upgrade Pro
              </Button>
            </td>
            <td className="py-6 px-4 text-center">
              <Button href="/get-a-quote?product=qrie-school-platform" variant="outline" size="sm">
                Get Quote
              </Button>
            </td>
            <td className="py-6 px-4 text-center">
              <Button href="/contact/sales" variant="secondary" size="sm">
                Contact Sales
              </Button>
            </td>
          </tr>
        </tfoot>
      </table>
    </div>
  );
}

function renderValue(val: boolean | string) {
  if (typeof val === "boolean") {
    return val ? (
      <Check className="w-4 h-4 text-emerald-600 mx-auto" />
    ) : (
      <X className="w-4 h-4 text-slate-300 mx-auto" />
    );
  }
  return <span className="text-slate-800">{val}</span>;
}
