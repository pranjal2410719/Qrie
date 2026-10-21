import React from 'react';
import { BrandMark } from './BrandMark';
import { SearchButton } from './SearchButton';
import { BtnFilled } from './BtnFilled';
import Link from 'next/link';

export function TopNav() {
  const links = ['Our values', 'Products', 'AI', 'Resources'];
  return (
    <nav className="h-16 bg-white border-b border-mist">
      <div className="max-w-container mx-auto px-6 h-full flex items-center justify-between">
        <BrandMark name="Qrie Education" />
        <div className="hidden md:flex gap-8">
          {links.map((l) => (
            <a
              key={l}
              href="#!"
              className="text-[14px] font-normal text-graphite hover:text-charcoal transition-colors relative"
            >
              {l}
            </a>
          ))}
        </div>
        <div className="flex items-center gap-3">
          <SearchButton />
          <div className="w-8 h-8 rounded-full bg-canvas flex items-center justify-center text-slate">
            <span className="text-[12px] font-medium">U</span>
          </div>
          <Link
            href="#!"
            className="text-[14px] font-medium text-google-blue hover:text-google-blue-deep transition-colors"
          >
            Sign in
          </Link>
          <BtnFilled>Get started</BtnFilled>
        </div>
      </div>
    </nav>
  );
}
