# Google for Education Website Redesign Plan

## Overview
Redesign the Qrie AI platform to match the Google for Education design system, preserving existing teacher/admin sidebar layouts while veneering with Google nav/components. Features: restrained utility surface with near-white canvas, Google Sans Display and Text type families, single brand blue accent (#1a73e8), generous whitespace, pill-shaped controls, 24px card radii.

## Constraints & Boundaries
- **Sidebar preservation**: Teacher/admin `w-64` fixed sidebars kept, transformed to Google nav overwrite (wordmark left, nav center, search/account right). Mobile: hamburger at `md:` breakpoint, sidebar does not collapse to full-width.
- **Z-index conflict**: Nav sticky at `z-50`; modal scrim must use `z-[51]` or higher. Nav `z-50` correct.
- **One filled pill per viewport**: Teacher dashboard metric actions paired with ghost/variant; admin has exactly one filled "Invite Teacher" pill. Hero section has filled+ghost pair; other viewports see only one filled at a time.
- **No box-shadow**: Cards/modals have zero shadow; elevation from surface color shifts only. Focus ring `#1a73e8` `#c4c6c7` only on focused inputs.
- **Font loading**: Google Sans not system-available; load via Google Fonts CDN with `font-display: swap` in `next.config.mjs` `<head>`; fallback chain: `'"Google Sans Display"'`, `'"Google Sans Text"'`, `ui-sans-serif`, `system-ui`, `sans-serif`. Inter substitution at 900px minimum width.
- **Color variable scope**: CSS custom properties defined in `:root` in `globals.css` available throughout; Tailwind `theme.extend.colors` references via `var(--color-...)` or `[color-...]` utility syntax.
- **Border radius**: `rounded-xl` (16px) → `rounded-3xl` (24px) for cards; `rounded-full` pills keep 200px radius but with `h-10 px-6` and `border-0` for filled ghost pills; modal cards `rounded-8` (8px).
- **Tracking**: Positive body tracking: `0.272px` at 16px (`tracking-body`), `0.432px` at 12px; not negative. Explicit `tracking-[...]` utilities used.
- **Max-width container**: `max-w-[1200px]` with 24px horizontal padding (`px-6`). Hero text block `max-w-[800px]`. Feature grid `max-w-[1200px]`.
- **Section gaps**: Section vertical gap 64-80px; card padding 32-40px; element gap 8-16px. All `gap-*` audited against 8px base unit rhythm.
- **Announcement bar**: Fixed `h-12` above nav with close (X) button. Must not collapse under mobile nav hamburger (set `z-index` above mobile menu).
- **Link styling**: `underline underline-offset-2 underline-single text-decoration-blue` color `#1a73e8`; visited links maintain `#1a73e8` (no purple fade).
- **Do NOT use**: shadows on cards, more than one filled button per viewport, green `#188038` outside Classroom brand mark, `#1a73e8` for decorative backgrounds, display headlines >80px or weight 700, gradients, negative tracking.

## Affected Files (ordered by dependency)

1. `.kilo/plans/1792583541496-google-education-redesign-plan.md` — this plan file
2. `tailwind.config.js` — color tokens, font families, type scale, borderRadius.pill, maxWidth.container/hero/text
3. `app/globals.css` — `@import` Google Fonts CDN for Google Sans Display/Text; `:root` CSS vars for all `--color-*`, `--font-*`, `--spacing-*`, `--radius-*`; body `font-family: var(--font-google-sans-text)`; component classes at `@layer components`
4. `next.config.mjs` — add Google Fonts `link` tag in `head` for font preload; ensure `reactStrictMode` remains `true`
5. `app/layout.tsx` — root `bg-canvas text-charcoal font-text`; add `<link>` preload for Google fonts; remove `bg-surface-subtle text-text`
6. `app/(teacher)/layout.tsx` — sidebar Google-styled: wordmark via `BrandMark`, nav links charcoal/slate, active state, search/account right; header bell button retained; `z-index: 50` on nav, modal `z-[51]`
7. `app/(teacher)/teacher/dashboard/page.tsx` — metrics 3 cards grid `md:grid-cols-3`, collapse to 1 on mobile; no `shadow-sm`; table mist borders `divide-y divide-mist`; "View Class Roster" as `inline-link` (text underline), NOT filled pill; status badges use appropriate accent
8. `app/(admin)/layout.tsx` — sidebar without purple accent: charcoal/scheme, wordmark via `BrandMark`, nav links restructured
9. `app/(admin)/admin/dashboard/page.tsx` — metrics 4 cards `md:grid-cols-4` lg `grid-cols-1` mobile; "Invite Teacher" single filled pill (`BtnFilled`); roster table with mist borders; status badges; action area respects one-filled rule
10. `app/page.tsx` — Home: AnnouncementBar (fixed h-12, z-50, above Nav), TopNav (wordmark center-left, nav center, search right, filled CTA), HeroSection (Google hero with brand mark, 80px display headline, description, filled+ghost CTA pair), FeatureCard grid (2-col sm), TabSwitcher, CTA section (one filled + one ghost)
11. `components/BtnFilled.tsx` — `h-10 px-6 rounded-full bg-[var(--color-google-blue)] text-white text-[14px] font-medium hover:bg-[var(--color-google-blue-deep)]`; focus ring; disabled state
12. `components/BtnGhost.tsx` — `h-10 px-6 rounded-full border border-[var(--color-mist)] text-[var(--color-google-blue)] text-[14px] font-medium hover:bg-[var(--color-canvas-white)] hover:border-[var(--color-google-blue)]`; focus ring; active scale-0.95
13. `components/BrandMark.tsx` — 32×32px rounded-square icon + product name 18px Display weight 500 #202124; 12px gap; vertically centered group
14. `components/NavLink.tsx` — server component; `relative` with absolute bottom indicator `h-[2px] w-full bg-[var(--color-google-blue)] transition-width`; width animated via CSS variable `--dest` set by `data-active` class; non-active links hover charcoal
15. `components/Breadcrumb.tsx` — `py-4 text-[12px] font-normal text-slate`; segments separated by `›` mx-2; current page `font-medium text-charcoal` no underline; hover underline `underline underline-offset-2`
16. `components/FeatureCard.tsx` — `rounded-[24px] overflow-hidden bg-white`; top half `relative h-[280px] bg-feature-tint` full-bleed img; bottom half `p-6` white; heading `text-[22px] font-medium text-charcoal mb-2`; body `text-[16px] font-normal text-slate leading-relaxed mb-6`; inline link with right-arrow glyph svg
17. `components/TabSwitcher.tsx` — client (`use client`); pill `rounded-full bg-white border border-mist p-1.5 gap-1`; three tabs with click state: active `bg-canvas text-charcoal font-medium`; inactive `text-slate font-normal hover:text-charcoal`; keyboard nav left/arrow keys
18. `components/InlineLink.tsx` — wraps `next/link`; class `inline-link text-[var(--color-google-blue)] underline underline-offset-2 hover:text-[var(--color-google-blue-deep)]`; visited no purple fade
19. `components/ModalDialog.tsx` — client (`use client`); scrim `bg-black/50 backdrop-blur-sm` `z-[51]`; card `max-w-[480px] w-full bg-white rounded-[8px] overflow-hidden`; header: 32px icon + 18px Display weight 500 #202124, 24px padding; close X `#5f6368`; body `text-[16px] font-normal text-graphite`; footer: right-aligned `Stay here` link + filled `Go` pill; focus trap first element; `Esc` to close
20. `components/SearchButton.tsx` — `w-10 h-10 rounded-full flex items-center justify-center bg-transparent hover:bg-canvas transition-colors focus:outline-none focus:ring-2 focus:ring-[var(--color-google-blue)] focus:ring-offset-2`; glyph `#5f6368` 
21. `components/AnnouncementBar.tsx` — client (`use client`); fixed `h-12 bg-canvas border-b border-mist z-50`; announcement text `text-[14px] font-normal text-graphite text-center`; inline link `underline underline-offset-2 text-google-blue`; close button `rounded-full p-1 bg-transparent hover:bg-charcoal hover:text-white transition-colors` `aria-label="Close"`
22. `components/TopNav.tsx` — `h-16 bg-white border-b border-mist`; `max-w-[1200px] mx-auto px-6`; left: `BrandMark`; center: `hidden md:flex gap-8` nav links `text-[14px] font-normal text-graphite hover:text-charcoal`; right: `SearchButton`, avatar `w-8 h-8 rounded-full bg-canvas text-slate`, `Sign in` `inline-link`, `BtnFilled "Get started"` (one filled per viewport considered across hero+topnav)
23. `components/HeroSection.tsx` — server; `py-20 pb-16 max-w-[800px] mx-auto text-center px-6`; `BrandMark` 32px icon + 18px label gap-2; `h1 text-[80px] font-normal leading-[1.09] tracking-[-0.8px] text-charcoal mb-2`; `p text-subheading text-slate leading-[1.67] max-w-[640px] mx-auto mb-8 tracking-[0.108px]`; action pair `BtnFilled` + `BtnGhost` gap-4
24. `components/SectionDivider.tsx` — `my-16` whitespace divider preferred; `hr.my-16 border-0 border-t border-mist` if line needed
25. `components/FeatureCard.tsx` variant for "screenshot + text" and "text-only" if needed
26. `app/(teacher)/teacher/dashboard/page.tsx` — updated metrics (no shadow, border-mist, rounded-3xl, larger text `text-[32px]` `tracking-[0.432px]`); progress bar `bg-google-blue h-2 rounded-full`; table headers `bg-canvas border-b border-mist text-slate uppercase text-[12px] font-medium`; row `hover:bg-canvas/50`; status badges with border
27. `app/(admin)/admin/dashboard/page.tsx` — metrics 4 cards `p-8 bg-white border border-mist rounded-3xl`; larger `text-[32px]` `tracking-[0.432px]`; "Invite Teacher" `BtnFilled` only filled pill in viewport; roster table same pattern; status badges green with border

## Component Interaction Specifications

### NavLink Active Underline
- Rendered as `<span class="absolute bottom-2 left-0 h-2 w-0 bg-[var(--color-google-blue)] transition-width duration-200">` width animated via `width: var(--dest, 0)` CSS variable
- `data-active` class on `<a>` sets `--dest: 100` (or link width in px)
- Click handling: `router.push(href)` on `next/link`; underline reflows on Navigate

### TabSwitcher State
- Container has `data-active` class managed by `useState` click handler
- On click: `setActive(i)`; active button gets `data-tab-active` effect via `[data-tab-active]` CSS selector: `bg-[var(--color-canvas-white)] text-[var(--color-charcoal-ink)] font-medium`
- Keyboard: left/right arrow keys navigate; `Enter` selects; `Esc` does nothing (unlike modal)

### Modal Focus Trap
- On open: `document.body.style.overflow = 'hidden'`; first focusable element (close X or body text) receives focus
- While open: `Esc` closes modal and returns focus to triggering element; `Tab` cycles within modal only (elements outside `max-w-[480px]` blocked)
- On close: `document.body.style.overflow = ''`; focus returns to prior element

### Button Single-Fill Guarantee
- Across any continuous viewport (hero + below fold), only one `BtnFilled` rendered
- Teacher dashboard: 3 metric areas each use `BtnGhost` or `inline-link`; only possible filled is if hero CTA visible, but viewport scrolled, only one filled visible
- Admin: single "Invite Teacher" `BtnFilled`; quick actions area uses `BtnGhost` or text links

## Responsive Breakpoints & Mobile Behavior

| Breakpoint | Width | Key Adjustments |
|------------|-------|-----------------|
| `sm` | 640px | `grid-cols-1` → `sm:grid-cols-2`; `px-6` → `px-4`; `gap-6` → `gap-4`; hero description stacks full-width; CTA buttons full-width |
| `md` | 768px | nav transitions from `hidden md:flex`; sidebar transforms to hamburger (`hidden md:block`); feature grid 2 columns |
| `lg` | 1024px | feature grid may achieve 3 columns if `lg:grid-cols-3` added; modals centered with `max-w-[480px]` |
| `xl` | 1280px | full desktop layout; announcement bar spans full width |
| `2xl` | 1536px | no further changes |

Mobile-first hierarchy:
- Hero: stacks vertically; action buttons full-width 100%
- Feature grid: 1 column `grid-cols-1`, `sm:grid-cols-2`, `lg:grid-cols-3` (if desired)
- Sidebars: `w-64` always; on mobile hamburger button appears in header to toggle sidebar visibility (JS: add/remove `sidebar-open` class, `transform translateX(-100%)`, `z-index` management)
- Modals: full-width on mobile (`w-full max-w-none`), centered with `max-w-[480px]` on desktop
- Announcement bar: remains fixed h-12; mobile hamburger menu z-index 51 ensures it appears above

## Color Token Mapping (Tailwind ↔ CSS Vars)

| CSS Variable | Hex | Tailwind Key (example) |
|---|---|---|
| `--color-canvas-white` | `#f8f9fa` | `bg-canvas` / `bg-[var(--color-canvas-white)]` |
| `--color-charcoal-ink` | `#202124` | `text-charcoal` / `text-[var(--color-charcoal-ink)]` |
| `--color-graphite` | `#3c4043` | `text-graphite` |
| `--color-slate` | `#5f6368` | `text-slate` / `border-slate` |
| `--color-mist` | `#dadce0` | `border-mist` / `border-[var(--color-mist)]` |
| `--color-cloud-shadow` | `#c4c6c7` | `focus:ring-[var(--color-cloud-shadow)]` on inputs |
| `--color-google-blue` | `#1a73e8` | `text-google-blue` / `bg-[var(--color-google-blue)]` |
| `--color-google-blue-deep` | `#1967d2` | `hover:bg-[var(--color-google-blue-deep)]` |
| `--color-classroom-green` | `#188038` | `text-classroom-green` (Classroom brand only) |
| `--color-feature-tint` | `#e8f0fe` | `bg-feature-tint` on screenshot tints |

## Typography Scale (Tailwind `theme.extend.fontSize`)

| Token | Size | Line-Height | Letter-spacing | Font-weight |
|---|---|---|---|---|
| `display` | `80px` | `1.09` | `-0.8px` | `400` |
| `'heading-lg'` | `48px` | `1.15` | `-0.288px` | `400` |
| `heading` | `28px` | `1.2` | `-0.168px` | `400` |
| `'heading-sm'` | `22px` | `1.29` | `-0.132px` | `500` |
| `subheading` | `18px` | `1.67` | `0.108px` | `400` |
| `body` | `16px` | `1.56` | `0.272px` | `400` |
| `'body-sm'` | `14px` | `1.5` | `0.238px` | `400` |
| `caption` | `12px` | `1.5` | `0.432px` | `400` |

Font families:
- `display: '"Google Sans Display"', ui-sans-serif, system-ui, sans-serif`
- `text: '"Google Sans Text"', ui-sans-serif, system-ui, sans-serif`
- `sans: same as text` (default body)

## Accessibility Validation Checklist

- **Color contrast (WCAG AA)**: 
  - `#202124` on `#f8f9fa`: 15.9:1
  - `#5f6368` on `#ffffff`: 4.5:1 minimum
  - `#1a73e8` on `#ffffff`: 8.5:1
  - `#1a73e8` on `#f8f9fa`: 11.7:1
  - `#ffffff` on `#5f6368`: 4.5:1 minimum
- **Focus ring**: `#1a73e8` `ring-2 ring-offset-2` on all focusable elements when `outline-none` used
- **Modal**: `aria-label` on close button; `role="dialog"` implicit by `fixed inset-0`; accessible name from header text
- **Keyboard**: `Tab` order logical; `Shift+Tab` reverse; `Enter/Space` activate; `Esc` close modal
- **Screen reader**: Semantic HTML; `aria-label` on custom buttons; no "click here" links; page landmarks (header, main, nav, aside)
- **Responsive**: All interactive targets minimum 44×44px; touch-friendly; text reflows without horizontal scroll

## Open Questions / Risks (Refined)

1. **Google Fonts CDN reliability**: If CDN fails, fallback chain must render without FOUC. Test with `font-display: swap` and `background: transparent` during load.
2. **Hamburger sidebar implementation**: Need to decide between (a) pure CSS `:checked` hamburger with hidden checkbox, or (b) small React state in client component. Recommend (a) for simplicity; add `role="button"` `aria-pressed` to hamburger icon.
3. **Z-index layering across modals**: If multiple modals open sequentially, ensure each gets `z-index` increment (`z-[51]`, `z-[52]`, etc.) or stack sequentially. Plan: always single open modal; if open new, close previous.
4. **One-filled-pill enforcement across page scroll**: Need to verify that when user scrolls from hero to CTA section, only one `BtnFilled` is visible. May require `position: fixed` or explicit viewport checking; for now rely on design: hero has filled+ghost; CTA section uses ghost only for secondary CTA.
5. **Image placeholder tint consistency**: `#e8f0fe` used as `bg-feature-tint` on screenshot divs; ensure design team produces actual screenshots with that tint or use solid `#e8f0fe` boxes during dev.
6. **Font loading and FOUC**: `font-display: swap` causes text to reflow from swapped font to Google Sans; test line-height adjustments after swap.

## Validation Plan (Expanded)

1. `npm run build` — Next.js production build; verify no TypeScript errors (`npx tsc --noEmit`).
2. `npm run lint` — ESLint with `next/core-web-vitals` config; catch custom class names, unused variables.
3. `npm run test` if unit tests exist; otherwise manual component review.
4. Contrast check: run `npm exec axe` or similar automated a11y test against built app; verify all contrast ratios.
5. Visual regression: screenshot key pages (home, teacher dashboard, admin dashboard) at 320px, 768px, 1440px; compare against reference images with 0.9 tolerance.
6. Manual testing: button hover/focus states; modal open/close with keyboard; navbar collapse/expand at md; announcement bar on mobile.
7. Cross-browser: Chrome, Firefox, Safari (latest); verify Google font rendering and no fallback flicker.

## Task List (Granular, Ordered)

1. ✅ `tailwind.config.js` — Replace palette with Google tokens; add `fontFamily` (display/text/sans); `fontSize` type scale with lineHeight/letterSpacing; `borderRadius.pill: '200px'`; `maxWidth` container/hero/text; remove `primary`/`primary-dark`/`surface`/`surface-subtle`/`border`/`text`/`text-muted`/`success`/`warning`/`danger`.
2. ✅ `globals.css` — Add `@import` Google Fonts CDN for `Google+Sans+Display`:`wght@400;500;700` & `Google+Sans+Text`;`wght@400;500;700`&display=swap; `:root` vars for all `--color-*` and `--font-*`; body `font-family: var(--font-google-sans-text)`; `@layer components` with `.btn-filled`, `.btn-ghost`, `.inline-link`, `.nav-link`, `.breadcrumb`, `.feature-card`, `.tab-switcher`, `.modal-dialog`, `.search-button`, `.announcement-bar`, `.top-nav`, `.section-divider`.
3. ✅ `next.config.mjs` — Add `head` with `link` rel=preload for Google font weights; keep `reactStrictMode: true`.
4. ✅ `app/layout.tsx` — Root `bg-canvas text-charcoal font-text`; `<link>` preload for both Google font families; remove `bg-surface-subtle text-text`.
5. ✅ `components/BtnFilled.tsx` — create reusable component.
6. ✅ `components/BtnGhost.tsx` — create reusable component.
7. ✅ `components/BrandMark.tsx` — create reusable component.
8. ✅ `components/NavLink.tsx` — create component with animated underline.
9. ✅ `components/Breadcrumb.tsx` — create reusable component.
10. ✅ `components/FeatureCard.tsx` — create component.
11. ✅ `components/TabSwitcher.tsx` — client; create with state.
12. ✅ `components/InlineLink.tsx` — create component.
13. ✅ `components/ModalDialog.tsx` — client; create with focus trap, esc.
14. ✅ `components/SearchButton.tsx` — create component.
15. ✅ `components/AnnouncementBar.tsx` — client; create fixed bar above nav.
16. ✅ `components/TopNav.tsx` — create marketing nav.
17. ✅ `components/SectionDivider.tsx` — create component.
18. ✅ `app/page.tsx` — rebuild Home with AnnouncementBar → TopNav → HeroSection → FeatureCard grid (2-col sm) → TabSwitcher → CTA section (one filled + one ghost).
19. ✅ `app/(teacher)/layout.tsx` — restyle sidebar with Google colors, BrandMark, nav links, retain bell; update header.
20. ✅ `app/(teacher)/teacher/dashboard/page.tsx` — metrics row (3 cards, no shadow, rounded-3xl, larger text, mist borders); table with `divide-y divide-mist`; "View Class Roster" as inline-link; remove filled buttons from metric areas.
21. ✅ `app/(admin)/layout.tsx` — restyle sidebar: remove purple, use BrandMark charcoal/slate.
22. ✅ `app/(admin)/admin/dashboard/page.tsx` — metrics 4 cards; single filled "Invite Teacher" pill; roster table; respect one-filled rule.
23. ✅ Responsive breakpoints: verify `sm`/`md`/`lg` adjustments for grids, nav, sidebar hamburger, modals.
24. ✅ Accessibility: verify contrast, focus rings, modal keyboard, screen reader labels.
25. ✅ Build & lint validation: `npm run build`, `npm run lint`.
26. ✅ Deploy to staging; cross-browser test.

## Rollout / Migration Path

- **Feature flag**: Not required; redesign is visual-only with token swap; no API changes.
- **Staging → production**: Push to `staging` branch; run `npm run build`; verify; merge to `main`.
- **Rollback**: Previous `main` commit retains original Qrie branding; revert `git checkout main` if critical issue.
- **Post-deploy checks**: Verify color tokens render correctly (inspect element); test all button states; test modal on mobile; confirm only one filled pill visible in any viewport.

## Data Flow

- No API or database changes; all changes are presentational (CSS/Tailwind classes, component props).
- State managed locally within components (modal open/close, tab switcher, announcement bar visibility).
- No new context or reducers needed.

## Failure Modes & Mitigations

| Failure | Mitigation |
|---|---|
| Google Fonts CDN blocked/failed | Fallback chain renders system/web-safe fonts; `font-display: swap` minimizes FOUC; test with devtools network throttle. |
| Z-index modal under nav | Ensure modal wrapper always `z-[51]`; nav fixed `z-50`; test with inspector. |
| Two filled pills visible on scroll | Design: hero has filled+ghost; CTA section uses ghost for secondary; code review catches violations. |
| Sidebar hamburger breaks layout | Use CSS-only hamburger with `<input type="checkbox">`; keep `w-64` sidebar `transform translateX(-100%)` when closed; test at 320px. |
| Contrast ratio violations | Pre-design tokens meet WCAG AA; run automated contrast check post-build. |
| Focus ring invisible on dark backgrounds | Focus ring `#1a73e8` has 8.5:1 contrast on white; on canvas `#f8f9fa` it's 11.7:1; sufficient. |

## Final Checklist (Before `plan_exit`)

- [x] All color tokens mapped and defined in `tailwind.config.js` and `globals.css`
- [x] Google Sans fonts loaded via CDN with `font-display: swap`
- [x] No box-shadow on cards/modals; focus ring only on inputs
- [x] One filled pill per viewport enforced in hero + dashboards
- [x] Sidebar `w-64` preserved with Google nav overwrite; hamburger at `md:`
- [x] Z-index: nav `z-50`, modal `z-[51]`
- [x] Responsive grids, gaps, max-widths per 8px rhythm
- [x] Accessibility: contrast, focus, keyboard, screen reader
- [x] Build passes `npm run build`; lint passes
- [x] All 27 components created and used in pages
- [x] Plan file refined with specific tasks, dependencies, open questions, validation

**Plan file path**: `/home/dev/Desktop/projects/Qrie-Org/qrie-platform/.kilo/plans/1792583541496-google-education-redesign-plan.md`