'use client';
import { Search } from 'lucide-react';

export function SearchButton() {
  return (
    <button
      aria-label="Search"
      className="w-10 h-10 rounded-full flex items-center justify-center bg-transparent hover:bg-canvas transition-colors focus:outline-none focus:ring-2 focus:ring-google-blue focus:ring-offset-2"
    >
      <Search className="w-5 h-5 text-slate hover:text-charcoal" />
    </button>
  );
}
