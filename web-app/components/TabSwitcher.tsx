'use client';
import React, { useState } from 'react';

const tabs = [
  'Personalize learning',
  'Simplify everyday tasks',
  'Gain insights and visibility',
];

export function TabSwitcher() {
  const [active, setActive] = useState(0);
  return (
    <div className="inline-flex rounded-full bg-white border border-mist p-1.5 gap-1">
      {tabs.map((t, i) => (
        <button
          key={t}
          onClick={() => setActive(i)}
          className={`px-4 py-2 rounded-full text-[14px] transition-colors ${
            active === i
              ? 'bg-canvas text-charcoal font-medium'
              : 'text-slate font-normal hover:text-charcoal'
          }`}
        >
          {t}
        </button>
      ))}
    </div>
  );
}
