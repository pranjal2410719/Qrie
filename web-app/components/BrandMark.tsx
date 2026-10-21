import React from 'react';

export function BrandMark({ name = 'Qrie Education' }: { name?: string }) {
  return (
    <div className="flex items-center gap-3">
      <div className="w-8 h-8 rounded-md bg-cloud-shadow flex items-center justify-center">
        <span className="text-[14px] font-medium text-charcoal">Q</span>
      </div>
      <span className="font-display text-[18px] font-medium text-charcoal">{name}</span>
    </div>
  );
}
