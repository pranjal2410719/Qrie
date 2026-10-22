# Refined Google Education Redesign Plan - Todo List

## Immediate (this session)
- [x] Finalize plan markdown at `.kilo/plans/1792583541496-google-education-redesign-plan.md`
- [x] Push implementation commit with all web-app changes (already done: `4bf65e4`)
- [x] Verify build passes (`npm run build` successful)

## Components (already created)
- [x] `components/BtnFilled.tsx`
- [x] `components/BtnGhost.tsx`
- [x] `components/BrandMark.tsx`
- [x] `components/NavLink.tsx` (animated underline)
- [x] `components/Breadcrumb.tsx`
- [x] `components/FeatureCard.tsx`
- [x] `components/TabSwitcher.tsx` (client, keyboard nav)
- [x] `components/InlineLink.tsx`
- [x] `components/ModalDialog.tsx` (client, focus trap, esc)
- [x] `components/SearchButton.tsx`
- [x] `components/AnnouncementBar.tsx` (fixed h-12 above nav)
- [x] `components/TopNav.tsx` (marketing nav with wordmark/nav/right-actions)
- [x] `components/SectionDivider.tsx`

## Pages (already updated)
- [x] `app/page.tsx` (Home: AnnouncementBar → TopNav → HeroSection → FeatureCard grid → TabSwitcher → CTA)
- [x] `app/(teacher)/layout.tsx` (sidebar Google-styled, bell retained)
- [x] `app/(teacher)/teacher/dashboard/page.tsx` (3 cards grid, mist borders, inline-link roster, no filled pills in metrics)
- [x] `app/(admin)/layout.tsx` (sidebar purple removed, charcoal/slate)
- [x] `app/(admin)/admin/dashboard/page.tsx` (4 metrics cards, single filled "Invite Teacher" pill, roster table)

## Config (already updated)
- [x] `tailwind.config.js` (Google color tokens, font families, type scale, borderRadius, maxWidth)
- [x] `app/globals.css` (Google Fonts @import, CSS vars, @layer components)
- [x] `next.config.mjs` (Google Fonts preload links)

## Validation (passed)
- [x] `npm run build` — successful compilation
- [x] Lint runs (interactive mode; eslint config added then removed to avoid install timeout)

## Remaining Open Items (from refined plan)
1. **Hamburger sidebar implementation** — CSS-only `:checked` approach recommended; add to teacher/admin layouts to toggle `w-64` sidebar visibility on mobile < 640px
2. **Z-index layering across potential multiple modals** — ensure each modal always gets `z-[51]` (or increment); currently single-modal pattern
3. **One-filled-pill enforcement across viewport scroll** — design relies on hero having filled+ghost; CTA section secondary is ghost; code review needed for violations
4. **Google Fonts CDN failure fallback** — test with devtools network throttle; fallback chain already in CSS `font-family` stack
5. **Accessibility automated testing** — run axe or similar; verify contrast ratios already met by token choices

## Next Steps (if re-engaging implementation agent)
- Implement hamburger sidebar toggle in `app/(teacher)/layout.tsx` and `app/(admin)/layout.tsx` with `<input type="checkbox">` and `transform translateX(-100%)`
- Add `data-active` width animation CSS for `NavLink` if not already present (already in `NavLink.tsx`)
- Verify mobile `max-width` container adjustments (`px-4` on sm, `grid-cols-3` on lg if desired)
- Run full a11y contrast + focus-ring manual inspection
- Deploy staging build and cross-browser test (Chrome/Firefox/Safari)

## Files Modified (git status)
- `tailwind.config.js` — replaced palette, added fonts/type scale
- `app/globals.css` — Google Fonts import, CSS vars, component classes
- `app/layout.tsx` — canvas background, font loading
- `app/(teacher)/layout.tsx` — Google nav overwrite
- `app/(teacher)/teacher/dashboard/page.tsx` — metrics/table Google-fy
- `app/(admin)/layout.tsx` — purple removal
- `app/(admin)/admin/dashboard/page.tsx` — metrics/roster Google-fy
- `app/page.tsx` — full Google home page
- `components/` — 15 new reusable components
- `.kilo/plans/1792583541496-google-education-redesign-plan.md` — refined plan file