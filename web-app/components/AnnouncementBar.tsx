'use client';
import React, { useState } from 'react';
import { X } from 'lucide-react';

export function AnnouncementBar() {
  const [visible, setVisible] = useState(true);
  if (!visible) return null;
  return (
    <div className="h-12 bg-canvas border-b border-mist">
      <div className="max-w-container mx-auto px-6 h-full flex items-center justify-between">
        <p className="text-[14px] font-normal text-graphite text-center flex-1">
          New: Explore Qrie AI for Education.{' '}
          <a href="#!" className="text-google-blue underline underline-offset-2">
            Learn more
          </a>
        </p>
        <button
          aria-label="Close"
          onClick={() => setVisible(false)}
          className="rounded-full p-1 text-slate hover:bg-charcoal hover:text-white transition-colors"
        >
          <X className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}
