import React from "react";
import { featureComparisonMatrix } from "@/lib/data/pricing";
import { Check, X } from "lucide-react";

export function PlanComparisonTable() {
  return (
    <div className="overflow-x-auto pb-6">
      <table className="w-full text-left border-collapse min-w-[700px]">
        <thead>
          <tr className="border-b border-[#f0f1f2]">
            <th className="py-4 px-6 text-[14px] font-medium text-[#101214] w-2/5">
              Features & Capabilities
            </th>
            <th className="py-4 px-4 text-[13px] font-medium text-[#42526e] text-center w-[15%]">
              Starter
            </th>
            <th className="py-4 px-4 text-[13px] font-medium text-[#1868db] text-center w-[15%] bg-[#e9f2fe]/60 rounded-t-[12px]">
              Student Pro
            </th>
            <th className="py-4 px-4 text-[13px] font-medium text-[#101214] text-center w-[15%]">
              School Essential
            </th>
            <th className="py-4 px-4 text-[13px] font-medium text-[#101214] text-center w-[15%]">
              Enterprise
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-[#f0f1f2] text-[13px]">
          {featureComparisonMatrix.map((cat) => (
            <React.Fragment key={cat.category}>
              <tr className="bg-[#f0f1f2]/60">
                <td
                  colSpan={5}
                  className="py-2.5 px-6 font-bold text-[#101214] uppercase tracking-wider text-[11px]"
                >
                  {cat.category}
                </td>
              </tr>
              {cat.items.map((item, idx) => (
                <tr key={idx} className="hover:bg-[#f0f1f2]/30 transition-colors">
                  <td className="py-3 px-6 font-normal text-[#292a2e]">
                    {item.feature}
                  </td>
                  <td className="py-3 px-4 text-center">
                    {renderValue(item.starter)}
                  </td>
                  <td className="py-3 px-4 text-center bg-[#e9f2fe]/20 font-medium">
                    {renderValue(item.pro)}
                  </td>
                  <td className="py-3 px-4 text-center">
                    {renderValue(item.school)}
                  </td>
                  <td className="py-3 px-4 text-center">
                    {renderValue(item.enterprise)}
                  </td>
                </tr>
              ))}
            </React.Fragment>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function renderValue(val: string | boolean) {
  if (typeof val === "boolean") {
    return val ? (
      <Check className="w-4 h-4 text-[#1868db] mx-auto" />
    ) : (
      <X className="w-4 h-4 text-[#b7b9be] mx-auto" />
    );
  }
  return <span className="text-[#292a2e] text-[13px]">{val}</span>;
}
