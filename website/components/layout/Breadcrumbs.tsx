import React from "react";
import Link from "next/link";
import { ChevronRight, Home } from "lucide-react";
import { generateBreadcrumbSchema } from "@/lib/seo/jsonLd";

export interface BreadcrumbItem {
  label: string;
  href: string;
}

export function Breadcrumbs({ items }: { items: BreadcrumbItem[] }) {
  const schemaItems = [
    { name: "Home", url: "/" },
    ...items.map((it) => ({ name: it.label, url: it.href })),
  ];

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(generateBreadcrumbSchema(schemaItems)),
        }}
      />
      <nav aria-label="Breadcrumb" className="py-2 text-[13px] text-[#42526e] font-normal">
        <ol className="flex items-center space-x-1.5 flex-wrap">
          <li>
            <Link
              href="/"
              className="inline-flex items-center gap-1 hover:text-[#1868db] transition-colors"
            >
              <Home className="w-3.5 h-3.5" />
              <span>Home</span>
            </Link>
          </li>
          {items.map((item, index) => {
            const isLast = index === items.length - 1;
            return (
              <li key={item.href} className="flex items-center space-x-1.5">
                <ChevronRight className="w-3.5 h-3.5 text-[#b7b9be] shrink-0" />
                {isLast ? (
                  <span className="font-medium text-[#101214] truncate max-w-xs">
                    {item.label}
                  </span>
                ) : (
                  <Link
                    href={item.href}
                    className="hover:text-[#1868db] transition-colors"
                  >
                    {item.label}
                  </Link>
                )}
              </li>
            );
          })}
        </ol>
      </nav>
    </>
  );
}
