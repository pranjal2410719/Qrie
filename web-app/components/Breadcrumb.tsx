import React from 'react';

export type BreadcrumbItem = { label: string; href?: string };

export function Breadcrumb({ items }: { items: BreadcrumbItem[] }) {
  return (
    <nav className="py-4 text-[12px] font-normal text-slate">
      {items.map((item, i) => (
        <span key={i}>
          {i > 0 && <span className="mx-2">›</span>}
          {item.href ? (
            <a
              href={item.href}
              className="text-google-blue hover:text-google-blue-deep transition-colors underline underline-offset-2"
            >
              {item.label}
            </a>
          ) : (
            <span className="font-medium text-charcoal">{item.label}</span>
          )}
        </span>
      ))}
    </nav>
  );
}
