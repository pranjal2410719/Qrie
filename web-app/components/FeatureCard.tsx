import React from 'react';

export function FeatureCard({
  title,
  body,
  linkLabel = 'Learn more',
  linkHref = '#!',
}: {
  title: string;
  body: string;
  linkLabel?: string;
  linkHref?: string;
}) {
  return (
    <div className="rounded-[24px] overflow-hidden bg-white">
      <div className="relative h-[280px] bg-feature-tint">
        <div className="absolute inset-0 bg-feature-tint" />
      </div>
      <div className="p-8">
        <h2 className="text-[22px] font-medium text-charcoal mb-2">{title}</h2>
        <p className="text-[16px] font-normal text-slate leading-relaxed mb-6">{body}</p>
        <a
          href={linkHref}
          className="inline-flex items-center text-google-blue underline underline-offset-2 hover:text-google-blue-deep transition-colors"
        >
          {linkLabel} →
        </a>
      </div>
    </div>
  );
}
