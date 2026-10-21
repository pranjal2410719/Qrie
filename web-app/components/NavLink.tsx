import Link from 'next/link';
import React from 'react';

export function NavLink({
  href,
  children,
  active = false,
  className = '',
}: {
  href: string;
  children: React.ReactNode;
  active?: boolean;
  className?: string;
}) {
  return (
    <Link
      href={href}
      className={`relative text-[14px] font-normal text-graphite hover:text-charcoal transition-colors ${className}`}
    >
      {children}
      {active && (
        <span className="absolute left-0 -bottom-1 h-[2px] w-full bg-google-blue" />
      )}
    </Link>
  );
}
