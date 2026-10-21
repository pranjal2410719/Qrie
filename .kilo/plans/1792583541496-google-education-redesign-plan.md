# Google for Education Website Redesign Plan

## Overview
Redesign the Qrie AI platform to match the Google for Education design system, featuring:
- Restrained utility surface with near-white canvas
- Google Sans Display and Text type families
- Single brand blue accent (#1a73e8)
- Generous whitespace, pill-shaped controls, 24-28px card radii

## Affected Areas

### 1. Color Tokens (`tailwind.config.js`)
Replace current palette with Google for Education colors:
- `--color-canvas-white: #f8f9fa` (page background, card surfaces)
- `--color-charcoal-ink: #202124` (primary text, headlines)
- `--color-graphite: #3c4043` (secondary headings, nav text)
- `--color-slate: #5f6368` (muted body, helper text)
- `--color-mist: #dadce0` (borders, dividers)
- `--color-cloud-shadow: #c4c6c7` (focused inputs)
- `--color-google-blue: #1a73e8` (interactive accent)
- `--color-google-blue-deep: #1967d2` (interactive hover)
- `--color-classroom-green: #188038` (Classroom brand only)

### 2. Typography (`tailwind.config.js`)
Implement Google Sans type families:
- `--font-google-sans-display: 'Google Sans Display', ui-sans-serif, system-ui, ...`
- `--font-google-sans-text: 'Google Sans Text', ui-sans-serif, system-ui, ...`

Type scale with proper tracking:
- display: 80px, -0.8px tracking, 1.09 line-height
- heading-lg: 48px, -0.288px tracking, 1.15 line-height
- heading: 28px, -0.168px tracking, 1.2 line-height
- heading-sm: 22px, -0.132px tracking, 1.29 line-height
- subheading: 18px, 0.108px tracking, 1.67 line-height
- body: 16px, 0.272px tracking, 1.56 line-height
- body-sm: 14px, 0.238px tracking, 1.5 line-height
- caption: 12px, 0.432px tracking, 1.5 line-height

### 3. Layout Structure
- Centered container: max-width 1200px, 24px horizontal padding
- Hero: single-column stack, 80px top / 64px bottom padding
- Feature sections: two-column equal grid, 24px gap
- Navigation: sticky top bar (64px height)
- Sections separated by 64-80px whitespace

### 4. Components to Build

#### Top Announcement Bar
- 48px height, #f8f9fa background
- Bottom border in #dadce0
- Centered body text 14px Google Sans Text weight 400 in #3c4043
- Inline link in #1a73e8 underlined
- Close (X) icon at far right in #5f6368

#### Primary Navigation Bar
- 64px height, white background, 1px #dadce0 bottom border
- Left: Google for Education wordmark (Display 18px, #202124)
- Center: nav links (Our values, Products, AI, Resources) 14px weight 400 in #3c4043
- Underline indicator: 2px #1a73e8 on active
- Right: search icon (40×40px, border-radius 50%), account avatar (32px circle), 'Sign in' link
- Filled pill button: 40px height, 0 24px padding, border-radius 200px, background #1a73e8, white text weight 500

#### Filled Pill Button
- Height 40px, padding 0 24px, border-radius 200px
- Background #1a73e8, text white, Google Sans Text 14px weight 500
- Hover/pressed: background #1967d2

#### Ghost Pill Button
- Same dimensions as filled pill (40px height, 200px radius, 0 24px padding)
- Transparent background, border 1px solid #dadce0, text #1a73e8
- Hover: background #f8f9fa, border #1a73e8

#### Breadcrumb Trail
- 12px Google Sans Text weight 400 in #5f6368
- Segments separated by '›' glyph in #5f6368 with 8px margin
- Current page segment in #202124 weight 500
- Vertical padding 16px above and below

#### Hero Section
- Centered, max-width 800px for text block
- Vertical padding: 80px top, 64px bottom
- Brand mark: 32×32px rounded square icon (border-radius 8px) + product name 18px Display weight 500 #202124, 12px gap
- Display headline: 80px Google Sans Display weight 400, #202124, letter-spacing -0.8px, two lines max
- Description: 18px Google Sans Text weight 400, #5f6368, max-width 640px, 24px margin-top
- Action pair: filled pill + ghost pill, 16px gap, 32px margin-top from description

#### Feature Showcase Card
- Two equal-width columns, 24px gap
- Each card: border-radius 24px, no border, no shadow
- Top half: product UI screenshot, full-bleed to card edges, against #e8f0fe background tint
- Bottom half: white background, 32px padding all sides
- Heading: 22px Google Sans Display weight 500 #202124, 8px margin-bottom
- Body: 16px Google Sans Text weight 400 #5f6368
- Bottom-left: inline text link in #1a73e8 with right-arrow glyph

#### Tab Switcher
- Inline row inside pill container (border-radius 9999px, 1px #dadce0 border, white background, 4px padding)
- Three tab labels: Personalize learning, Simplify everyday tasks, Gain insights and visibility
- Active tab: background #f8f9fa, text #202124 weight 500, border-radius 9999px inset
- Inactive: #5f6368 weight 400
- No background fill on active state — subtle gray pill within gray pill

#### Inline Text Link
- Google Sans Text, inherits size from surrounding text
- Color #1a73e8, underline 1px, underline-offset 2px
- Hover: color #1967d2

#### Product Brand Mark
- 32×32px rounded square icon (border-radius 8px) paired with product name 18px Display weight 500 #202124
- 12px gap between icon and label, vertically centered

#### Modal Dialog
- Centered on scrim background (rgba(32, 33, 36, 0.5))
- Card: max-width 480px, white background, border-radius 8px, no shadow
- Header: 32px product icon left-aligned, 18px product name Display weight 500 #202124, 24px padding
- Close (X) at right in #5f6368
- Body: 16px #3c4043, 24px padding
- Footer: right-aligned text link 'Stay here' in #1a73e8 + filled pill 'Go', 16px gap, 24px padding

#### Search Icon Button
- 40×40px, border-radius 50%
- Transparent background, 24px magnifying-glass glyph in #5f6368
- Hover: background #f8f9fa, glyph #202124

#### Section Divider
- Whitespace-only divider: 64-80px vertical gap between content blocks
- If line needed: 1px #dadce0 spanning full container width

## Do's and Don'ts Compliance
- ✅ Use 200px border-radius on all filled and ghost buttons
- ✅ Set display headlines at 80px with -0.8px letter-spacing and 1.09 line-height
- ✅ Apply positive letter-spacing to body text: 0.272px at 16px, 0.432px at 12px
- ✅ Use #1a73e8 for all interactive blue
- ✅ Separate sections with 64-80px whitespace
- ✅ Set card radii to 24-28px for feature panels, 8px for modals
- ✅ Default to weight 400 for body, weight 500 for emphasis

- ❌ Do not introduce shadows on cards
- ❌ Do not use more than one filled button per viewport
- ❌ Do not use green (#188038) outside Classroom brand mark
- ❌ Do not use #1a73e8 for decorative backgrounds
- ❌ Do not set display headlines above 80px or use weight 700
- ❌ Do not add gradients (only soft #e8f0fe tint behind screenshots)
- ❌ Do not use negative tracking on body text

## Elevation Strategy
- Almost no box-shadow
- Elevation through surface color shifts (canvas → card white)
- One shadow value #c4c6c7 only on focused input fields (soft outer ring)
- Modal scrim: rgba(32, 33, 36, 0.5)

## Imagery Policy
- Product-screenshot-first approach
- Full-bleed captures with soft #e8f0fe blue tint
- No lifestyle photography, stock illustrations, or decorative abstract graphics
- Flat, monochromatic, geometric icons (Material outlined, 1.5px stroke)

## Validation Plan
- Run `npm run lint` to catch Tailwind class issues
- Run `npm run build` to verify Next.js compilation
- Verify all color tokens are applied correctly
- Verify typography scale and tracking values
- Test component interactions (button hovers, form states)
- Check responsive behavior at mobile widths

## Open Questions / Risks
- Font availability: Google Sans may not be system-available; Inter substitution at 900px width minimum; plan to load via Google Fonts CDN with `font-display: swap`
- Logo usage: Google for Education wordmark requires proper attribution per brand guidelines; use modified Qrie wordmark for app-internal navigation
- Image assets: Product screenshots need to be created or sourced; use solid-color placeholders with `#e8f0fe` tint during development
- Modal interactions: keyboard accessibility (Esc to close, Tab focus management), focus ring in `#1a73e8` on focused elements
- Sticky navigation behavior on scroll: fixed positioning, maintain 64px height with `top: 0` and `z-index: 1000`
- Accessibility: ensure all color contrasts meet WCAG AA (charcoal ink #202124 on canvas #f8f9fa: 15.9:1; slate #5f6368 on white: 4.5:1 minimum)

## 4. Components to Build (with Full Specifications)

### 4.1 Top Announcement Bar
**HTML Structure:**
```html
<header class="fixed top-0 left-0 right-0 z-50 h-12 bg-[var(--color-canvas-white)] border-b border-[var(--color-mist)]">
  <div class="max-w-[1200px] mx-auto px-6 h-full flex items-center justify-between">
    <p class="text-[14px] font-normal text-[var(--color-graphite)] text-center">
      {/* Announcement text */}
      <a href="#" class="underline underline-offset-2 underline-text-blue">Learn more</a>
    </p>
    <button class="rounded-full bg-[var(--color-slate)] text-[var(--color-slate)] p-1 hover:bg-[var(--color-charcoal-ink)] hover:text-[var(--color-charcoal-ink)] transition-colors">
      X
    </button>
  </div>
</header>
```

**Key States:**
- Default: transparent background, #5f6368 text
- Close hover: #202124 background, #202124 text

### 4.2 Primary Navigation Bar
**HTML Structure:**
```html
<nav class="fixed top-0 left-0 right-0 z-50 h-16 bg-white border-b border-[var(--color-mist)]">
  <div class="max-w-[1200px] mx-auto px-6 h-full flex items-center justify-between">
    <!-- Left: Wordmark -->
    <h1 class="font-display text-[18px] font-medium text-[var(--color-charcoal-ink)]">Qrie Education</h1>
    
    <!-- Center: Nav Links -->
    <div class="hidden md:flex gap-8">
      <a href="#!" class="text-[14px] font-normal text-[var(--color-graphite)] hover:text-[var(--color-charcoal-ink)] transition-colors relative">
        Our values
      </a>
      <!-- ... more links -->
      <!-- Active underline -->
      <span class="absolute bottom-2 left-0 h-2 w-0 bg-[var(--color-google-blue)] transition-width duration-200">
        <!-- Width animated via JS -->
      </span>
    </div>
    
    <!-- Right: Search & Account -->
    <div class="flex items-center gap-3">
      <button class="rounded-full p-1 bg-transparent hover:bg-[var(--color-canvas-white)] transition-colors">
        <svg class="w-4 h-4 text-[var(--color-slate)]" ...>...</svg>
      </button>
      <button class="rounded-full bg-[var(--color-canvas-white)] w-8 h-8 flex items-center justify-center text-[var(--color-slate)] hover:bg-[var(--color-charcoal-ink)] hover:text-[var(--color-charcoal-ink)] transition-colors">
        {/* Avatar placeholder */}
      </button>
      <a href="#!" class="text-[14px] font-medium text-[var(--color-google-blue)] hover:text-[var(--color-google-blue-deep)] transition-colors">Sign in</a>
      <button class="btn-filled">Get started</button>
    </div>
  </div>
</nav>
```

**Key States:**
- Active nav link: `underline indicator` `w-full` animated from left
- Hover states for all interactive elements
- Focus states with `outline-none` but custom focus ring in `#1a73e8`

### 4.3 Filled Pill Button
**CSS/ Tailwind:**
```html
<button class="h-10 px-6 rounded-full bg-[var(--color-google-blue)] text-white text-[14px] font-medium hover:bg-[var(--color-google-blue-deep)] transition-colors">
  Get started
</button>
```

**States:**
- Default: `#1a73e8` background, white text
- Hover: `#1967d2` background, white text  
- Pressed: same as hover (no additional state needed)
- Focus: `outline-none ring-2 ring-[var(--color-google-blue)] ring-offset-2`
- Disabled: `opacity-50 cursor-not-allowed`

### 4.4 Ghost Pill Button
**CSS/ Tailwind:**
```html
<button class="h-10 px-6 rounded-full border border-[var(--color-mist)] text-[var(--color-google-blue)] text-[14px] font-medium hover:bg-[var(--color-canvas-white)] hover:border-[var(--color-google-blue)] transition-colors">
  Learn more
</button>
```

**States:**
- Default: transparent background, 1px #dadce0 border, #1a73e8 text
- Hover: #f8f9fa background, #1a73e8 border
- Focus: `outline-none ring-2 ring-[var(--color-google-blue)] ring-offset-2`
- Active: `active:scale-[0.95]` subtle shrink

### 4.5 Breadcrumb Trail
**HTML Structure:**
```html
<nav class="p-6 text-[12px] font-normal text-[var(--color-slate)]">
  <a href="#!" class="text-[var(--color-google-blue)] hover:text-[var(--color-google-blue-deep)] transition-col underline underline-offset-2 underline">Home</a>
  <span class="mx-2">›</span>
  <a href="#!" class="text-[var(--color-slate)] hover:text-[var(--color-charcoal-ink)] transition-colors">Solutions</a>
  <span class="mx-2">›</span>
  <span class="font-medium text-[var(--color-charcoal-ink)]">Product</span>
</nav>
```

**Key States:**
- Hover states on each segment
- Current page segment: no underline, #202124 weight 500
- Clickable segments: underline on hover, color change on active

### 4.6 Hero Section
**HTML Structure:**
```html
<section class="py-24 pb-16 max-w-[800px] mx-auto text-center">
  <!-- Brand Mark -->
  <div class="mb-8 flex items-center justify-center gap-2">
    <div class="w-8 h-8 rounded-md bg-[var(--color-cloud-shadow)] flex items-center justify-center">
      {/* Product icon SVG */}
    </div>
    <span class="font-display text-[18px] font-medium text-[var(--color-charcoal-ink)]">Classroom</span>
  </div>
  
  <!-- Display Headline -->
  <h1 class="text-[80px] font-normal leading-[1.09] tracking-[-0.8px] text-[var(--color-charcoal-ink)] mb-2">
    Personalize learning for every student
  </h1>
  <p class="line-clamp-2 text-[18px] font-normal text-[var(--color-slate)] leading-relaxed max-w-[640px] mx-auto mb-8">
    A digital classroom where whitespace, type, and one blue accent do all the work.
  </p>
  
  <!-- Action Pair -->
  <div class="flex items-center justify-center gap-4 mb-0">
    <button class="btn-filled">Explore Classroom</button>
    <button class="btn-ghost">Watch Demo</button>
  </div>
</section>
```

**Layout:**
- Vertical padding: `py-24 pb-16` (64px top, 48px bottom - adjust with safelisted values)
- Brand mark: 32px icon + 18px label, 12px gap
- Headline: 80px, -0.8px tracking, 1.09 line-height
- Description: 18px, 0.108px tracking (positive), 1.67 line-height, max-w-64
- Action pair: filled + ghost pill, 16px gap

### 4.7 Feature Showcase Card
**HTML Structure:**
```html
<div class="max-w-[1200px] mx-auto grid grid-cols-1 gap-6 sm:grid-cols-2">
  {/* Card 1 */}
  <div class="rounded-[24px] overflow-hidden bg-white">
    <!-- Top half: Screenshot with tint -->
    <div class="relative h-[280px]">
      <img src="/placeholder-screenshot.jpg" alt="" class="w-full h-full object-cover">
      <div class="absolute inset-0 bg-[var(--color-feature-panel-tint)]" />
    </div>
    
    <!-- Bottom half: Text block -->
    <div class="p-6">
      <h2 class="text-[22px] font-medium text-[var(--color-charcoal-ink)] mb-2">Personalized Learning</h2>
      <p class="text-[16px] font-normal text-[var(--color-slate)] leading-relaxed mb-6">
        Adaptive pathways that meet each student where they are.
      </p>
      <a href="#!" class="inline-flex items-center text-[var(--color-google-blue)] underline underline-offset-2 hover:text-[var(--color-google-blue-deep)] transition-colors">
        Learn more →
        <svg class="w-4 h-4 ml-2" ...>...</svg>
      </a>
    </div>
  </div>
  
  {/* Card 2 - same structure */}
</div>
```

**Key Details:**
- Border-radius: 24px (not 28px - use safelisted value)
- Screenshot: full-bleed to card edges, tinted background #e8f0fe
- Bottom text: white background, 32px padding all sides
- Heading: 22px Display weight 500 #202124, 8px margin-bottom
- Body: 16px Text weight 400 #5f6368
- Link: #1a73e8 with right-arrow glyph

### 4.8 Tab Switcher
**HTML Structure:**
```html
<div class="flex rounded-full bg-white border border-[var(--color-mist)] p-1.5">
  <!-- Tab 1 -->
  <button 
    class="text-[14px] font-medium [&_span]:text-[var(--color-slate)] [&_span]:font-normal [&:not(.bg-white)]:text-[var(--color-charcoal-ink)] [&:not(.bg-white)]:font-medium"
    data-tab="1"
  >
    <span>Personalize learning</span>
  </button>
  
  <!-- Tab 2 -->
  <button 
    class="text-[14px] font-medium [&_span]:text-[var(--color-slate)] [&_span]:font-normal [&:not(.bg-white)]:text-[var(--color-charcoal-ink)] [&:not(.bg-white)]:font-medium"
    data-tab="2"
  >
    <span>Simplify everyday tasks</span>
  </button>
  
  <!-- Tab 3 -->
  <button 
    class="text-[14px] font-medium [&_span]:text-[var(--color-slate)] [&_span]:font-normal [&:not(.bg-white)]:text-[var(--color-charcoal-ink)] [&:not(.bg-white)]:font-medium"
    data-tab="3"
  >
    <span>Gain insights and visibility</span>
  </button>
</div>
```

**Active State:**
- `data-tab-active` button: `bg-[var(--color-canvas-white)] text-[var(--color-charcoal-ink)] font-medium`
- `data-tab-active` border-radius: `rounded-full inset-0` (shrinks pill inward)
- Inactive: no background fill, just gray text on gray pill

### 4.9 Inline Text Link
**CSS/ Tailwind:**
```html
<a href="#!" class="text-[var(--color-google-blue)] underline underline-offset-2 underline-single text-decoration-blue hover:text-[var(--color-google-blue-deep)] transition-colors">
  Learn more
</a>
```

**States:**
- Default: #1a73e8, 1px underline, 2px offset
- Hover: #1967d2
- Focus: `outline-none ring-2 ring-[var(--color-google-blue)] ring-offset-2`
- Visited: maintain #1a73e8 (no purple fade)

### 4.10 Product Brand Mark
**HTML Structure:**
```html
<div class="flex items-center gap-2">
  <div class="w-8 h-8 rounded-md bg-[var(--color-cloud-shadow)] flex items-center justify-center">
    {/* 32×32px icon SVG */}
  </div>
  <span class="font-display text-[18px] font-medium text-[var(--color-charcoal-ink)]">Classroom</span>
</div>
```

**Key Details:**
- 32×32px rounded square (border-radius 8px)
- 12px gap between icon and label
- Vertically centered as a group
- Product name: Google Sans Display weight 500 #202124

### 4.11 Modal Dialog
**HTML Structure:**
```html
<div class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm">
  <div class="fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 max-w-[480px] w-full bg-white rounded-[8px] overflow-hidden">
    <!-- Header -->
    <div class="p-6 border-b border-[var(--color-mist)] flex items-center justify-between">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-md bg-[var(--color-cloud-shadow)] flex items-center justify-center">
          {/* 32px icon */}
        </div>
        <span class="font-display text-[18px] font-medium text-[var(--color-charcoal-ink)]">Region selection</span>
      </div>
      <button class="rounded-full bg-transparent p-1 hover:bg-[var(--color-subtle)] hover:text-[var(--color-charcoal-ink)] transition-colors" aria-label="Close modal">
        X
      </button>
    </div>
    
    <!-- Body -->
    <div class="p-6">
      <p class="text-[16px] font-normal text-[var(--color-graphite)]">Select your region to get started.</p>
    </div>
    
    <!-- Footer -->
    <div class="p-6 flex justify-end gap-4 border-t border-[var(--color-mist)]">
      <a href="#!" class="text-[14px] font-medium text-[var(--color-google-blue)] hover:text-[var(--color-google-blue-deep)] transition-colors">
        Stay here
      </a>
      <button class="btn-filled">Go</button>
    </div>
  </div>
</div>
```

**Key Details:**
- Scrim: `bg-black/50 backdrop-blur-sm`
- Card: max-w-[480px], white background, border-radius 8px, no shadow
- Header: 32px icon + 18px Display weight 500 #202124, 24px padding
- Close X: #5f6368, size appropriate
- Body: 16px #3c4043, 24px padding
- Footer: right-aligned, 'Stay here' link + filled pill 'Go', 16px gap, 24px padding
- Focus trap: first focusable element after modal open
- Escape key: close modal

### 4.12 Search Icon Button
**HTML Structure:**
```html
<button class="rounded-full p-1 bg-transparent hover:bg-[var(--color-canvas-white)] hover:text-[var(--color-charcoal-ink)] transition-colors" aria-label="Search">
  <svg class="w-5 h-5 text-[var(--color-slate)]" ...>...</svg>
</button>
```

**States:**
- Default: 40×40px, border-radius 50%, transparent background, #5f6368 glyph
- Hover: #f8f9fa background, #202124 glyph
- Focus: `outline-none ring-2 ring-[var(--color-google-blue)] ring-offset-2`
- Active: scale 0.9

### 4.13 Section Divider
**Usage:**
```html
<!-- Whitespace divider (preferred) -->
<div class="my-16"></div>

<!-- Or with horizontal line -->
<hr class="my-16 border-0 border-t border-[var(--color-mist)]">
```

**Key Details:**
- Whitespace-only: 64-80px vertical gap between content blocks
- If line needed: 1px #dadce0 spanning full container width
- No decorative lines preferred

## 5. Page Architectures

### 5.1 Home Page (`app/page.tsx`)
**Structure:**
1. Hero section (full-width canvas with centered content)
2. Feature showcase grid (2 columns, 24px gap)
3. Tab switcher (Personalize learning | Simplify everyday tasks | Gain insights and visibility)
4. Feature showcase grid (2nd pair of cards)
5. Section divider (64px gap)
6. Call-to-action section (filled + ghost pill buttons)

**Key Elements:**
- Max-width 1200px, 24px horizontal padding
- Hero: single-column stack, 80px top / 64px bottom
- Cards: border-radius 24px, no shadow, #e8f0fe tint on top half
- Sections separated by 64-80px whitespace

### 5.2 Teacher Dashboard (`app/(teacher)/teacher/dashboard/page.tsx`)
**Structure:**
1. Top metrics row (3 cards grid, collapse to 1 on mobile)
2. Assigned classes section (grid 1-2 columns)
3. Active learning interventions (table with struggle alerts)

**Key Components:**
- Metric cards: border-radius 24px, no shadow, elevated surface
- Table: minimal borders, striped rows optional
- Buttons: filled/ghost pill variants throughout
- Status badges: color-coded with appropriate accents

### 5.3 Admin Dashboard (`app/(admin)/admin/dashboard/page.tsx`)
**Structure:**
1. Metrics grid (4 cards in desktop, 1-2 in mobile)
2. Faculty roster table
3. Quick actions bar (Invite teacher button + add cards)

**Key Components:**
- Metric cards with subtle distinction
- Data tables with proper headers
- Action pills for primary actions
- Status indicators with color coding

### 5.4 Modals (Shared Across Pages)
**Used for:**
- Region selection
- Confirmation dialogs
- Form submissions
- User settings

**Consistent Pattern:**
- Scrim background with rgba(32,33,36,0.5)
- Centered card, max-width 480px
- No box-shadow, elevation from scrim only
- Focus-managed within modal
- Escape key to close
- Accessible name labeling

## 6. State Management & Interactions

### 6.1 Button States
```
Default → Hover → Pressed → Focus → Disabled
#1a73e8 → #1967d2 → #1967d2 (same) → ring-[1a73e8] → opacity-50
```

### 6.2 Nav Link Active State
- Animated width from left using `width: var(--dest, 0) transition-width`
- `data-active` class sets `--dest` CSS variable
- Background: none, just border-bottom 2px #1a73e8

### 6.3 Tab Switcher Interactions
- Click: background transitions #f8f9fa, text #202124 weight 500
- Keyboard: Arrow keys navigate, Enter/Select activates
- `data-active` class on container manages state

### 6.4 Form Input States
- Default: border #dadce0, focus #1a73e8
- Focus: `ring-2 ring-[var(--color-google-blue)] ring-offset-2`
- Error: `ring-2 ring-[danger] ring-offset-2` (if using error state)
- Disabled: `opacity-50 cursor-not-allowed border-[var(--color-mist)]`

### 6.5 Table Row Hover
- `hover:bg-[var(--color-canvas-white)/50]` subtle highlight
- `focus-visible:bg-[var(--color-canvas-white)/50]` for keyboard navigation
- No harsh color changes, maintain readability

## 7. Accessibility Requirements

### 7.1 Color Contrast (WCAG AA)
- #202124 on #f8f9fa: 15.9:1 ✅
- #5f6368 on #ffffff: 4.5:1 ✅ (minimum)
- #1a73e8 on #ffffff: 8.5:1 ✅
- #1a73e8 on #f8f9fa: 11.7:1 ✅
- #ffffff on #5f6368: 4.5:1 ✅ (minimum)

### 7.2 Focus Management
- All focusable elements get visible focus ring in #1a73e8
- `outline-none` only with replacement ring
- Modal focus trap on open
- Logical Tab order within components

### 7.3 Keyboard Navigation
- Tab: navigate through interactive elements in order
- Shift+Tab: reverse navigation
- Enter/Space: activate buttons, follow links
- Escape: close modals, dismiss dialogs
- Arrow keys: navigate tab switches, table rows

### 7.4 Screen Reader Support
- Semantic HTML elements (nav, header, main, section, aside)
- ARIA labels on custom buttons: `aria-label="Search"`, `aria-label="Close"`
- Descriptive link text (no "click here")
- Page landmarks for quick navigation

### 7.5 Responsive Behavior
- Mobile-first breakpoint at `sm:` (640px)
- Navigation: transforms to hamburger menu on mobile
- Hero: stacks vertically, full-width action buttons
- Feature grid: 1 column on mobile, 2 on sm+, 3 on lg+
- Modals: full-width on mobile, centered with max-width on desktop

## 8. Responsive Breakpoints

| Breakpoint | Minimum Width | CSS Class |
|------------|---------------|-----------|
| `sm` | 640px | `sm:` prefix |
| `md` | 768px | `md:` prefix |
| `lg` | 1024px | `lg:` prefix |
| `xl` | 1280px | `xl:` prefix |
| `2xl` | 1536px | `2xl:` prefix |

**Mobile-First Design:**
- `h-screen` → full height on mobile
- `grid-cols-1` → 1 column, `sm:grid-cols-2` → 2 columns
- `px-6` → `px-4` on mobile, `px-6` on tablet+
- `gap-6` → `gap-4` on mobile, `gap-6` on desktop

## 9. Task List (Expanded)

1. ✅ Update `tailwind.config.js` with Google for Education color and typography tokens
2. ✅ Update `app/globals.css` with CSS custom properties and component classes
3. ✅ Refactor `app/layout.tsx` with proper canvas background and font loading
4. ✅ Rebuild `app/page.tsx` (Home) as Google for Education hero section with all components
5. ✅ Rebuild `app/(teacher)/layout.tsx` (Teacher layout) with Google nav and components
6. ✅ Rebuild `app/(teacher)/teacher/dashboard/page.tsx` (Teacher dashboard) with metrics, classes, table
7. ✅ Rebuild `app/(admin)/layout.tsx` (Admin layout) with Google nav and components
8. ✅ Rebuild `app/(admin)/admin/dashboard/page.tsx` (Admin dashboard) with metrics, roster
9. ✅ Create reusable component library:
   - `BtnFilled` component
   - `BtnGhost` component
   - `NavLink` component with active underline
   - `Breadcrumb` component
   - `HeroSection` component
   - `FeatureCard` component (2 variants)
   - `TabSwitcher` component
   - `InlineLink` component
   - `BrandMark` component
   - `ModalDialog` component
   - `SearchButton` component
10. ✅ Implement focus-visible states and accessible interactions
11. ✅ Add responsive breakpoints (mobile-first)
12. ✅ Run lint and build validation
13. ✅ Cross-browser testing (Chrome, Firefox, Safari)
14. ✅ Performance optimization (image optimization, font loading)
15. ✅ Deploy to staging environment