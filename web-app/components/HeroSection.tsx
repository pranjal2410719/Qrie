import React from 'react';
import { BrandMark } from './BrandMark';
import { BtnFilled } from './BtnFilled';
import { BtnGhost } from './BtnGhost';

export function HeroSection({
  brand = 'Classroom',
  headline = 'Personalize learning for every student',
  description = 'A digital classroom where whitespace, type, and one blue accent do all the work.',
  primaryCta = 'Explore Classroom',
  secondaryCta = 'Watch Demo',
}: {
  brand?: string;
  headline?: string;
  description?: string;
  primaryCta?: string;
  secondaryCta?: string;
}) {
  return (
    <section className="py-20 pb-16 max-w-hero mx-auto text-center px-6">
      <div className="mb-8 flex items-center justify-center gap-3">
        <BrandMark name={brand} />
      </div>
      <h1 className="text-display font-normal leading-[1.09] tracking-[-0.8px] text-charcoal mb-2">
        {headline}
      </h1>
      <p className="text-subheading font-normal text-slate leading-[1.67] max-w-text mx-auto mb-8 tracking-[0.108px]">
        {description}
      </p>
      <div className="flex items-center justify-center gap-4">
        <BtnFilled>{primaryCta}</BtnFilled>
        <BtnGhost>{secondaryCta}</BtnGhost>
      </div>
    </section>
  );
}
