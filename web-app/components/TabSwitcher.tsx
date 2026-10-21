'use client';
import React, { useState, useRef } from 'react';

const tabs = [
  'Personalize learning',
  'Simplify everyday tasks',
  'Gain insights and visibility',
];

export function TabSwitcher() {
  const [active, setActive] = useState(0);
  const containerRef = useRef<HTMLDivElement>(null);

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
      e.preventDefault();
      setActive((prev) => (prev + 1) % tabs.length);
    } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
      e.preventDefault();
      setActive((prev) => (prev - 1 + tabs.length) % tabs.length);
    } else if (e.key === 'Home') {
      e.preventDefault();
      setActive(0);
    } else if (e.key === 'End') {
      e.preventDefault();
      setActive(tabs.length - 1);
    }
  };

  return (
    <div
      ref={containerRef}
      className="inline-flex rounded-full bg-white border border-mist p-1.5 gap-1"
      role="tablist"
      onKeyDown={handleKeyDown}
    >
      {tabs.map((t, i) => (
        <button
          key={t}
          role="tab"
          aria-selected={active === i}
          tabIndex={active === i ? 0 : -1}
          onClick={() => setActive(i)}
          className={`px-4 py-2 rounded-full text-[14px] transition-colors focus:outline-none focus:ring-2 focus:ring-google-blue focus:ring-offset-2 ${
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
