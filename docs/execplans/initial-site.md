# Brand overhaul: align mxd site with Protocol Souk design system

This ExecPlan (execution plan) is a living document. The sections
`Constraints`, `Tolerances`, `Risks`, `Progress`, `Surprises & Discoveries`,
`Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work
proceeds.

Status: COMPLETE

## Purpose / big picture

The mxd website (`mxd/`) was exported from a design tool and converted into
routed HTML pages. The export introduced two categories of problem: internal
inconsistencies between pages (different hover classes, different responsive
padding, different hero heights) and deviations from the Protocol Souk design
system defined in `docs/mxd-design-system.html`. This plan addresses both.

After this work, a visitor browsing the site will experience a consistent
visual language across all twelve pages. A developer maintaining the site will
find shared styles centralized in `mxd/assets/site.css` rather than duplicated
across twelve inline `<style>` blocks. Validation with Playwright snapshots
and `css-view` will confirm that computed styles match the design system tokens.


## Constraints

1. The site remains a static, no-build HTML site. No templating engine, no
   bundler, no npm scripts. All twelve pages are hand-authored HTML files.
2. Tailwind CSS is loaded from CDN (`cdn.tailwindcss.com`). This constraint
   is inherited from the export and will not change in this plan.
3. The design system document (`docs/mxd-design-system.html`) is the
   authoritative source of truth for colours, typography, spacing, and
   component patterns. Where the site diverges, the site must be brought into
   line with the design system, not the other way around.
4. Content and copy must not be altered. This is a visual/structural overhaul
   only.
5. Accessibility features (skip links, ARIA labels, semantic HTML) must be
   preserved or improved, never removed.
6. The existing `mxd/assets/site.css` file and its Block–Element–Modifier (BEM) style `.mxd-*`
   class naming convention is the foundation for shared styles. New shared
   classes must follow the same naming convention.

## Tolerances (exception triggers)

- Scope: if implementation requires changes to more than 15 files (the 12 HTML
  pages + site.css + SVG assets + this plan), stop and escalate.
- Interface: if a change would alter navigation structure or link targets,
  stop and escalate.
- Dependencies: no new external dependencies (CDN scripts, fonts, etc.) may
  be added without escalation.
- Iterations: if Playwright/css-view validation fails after 3 correction
  attempts on any single component, stop and escalate.
- Ambiguity: if the design system is ambiguous about a specific component's
  appearance, document the interpretation in Decision Log and proceed with the
  closest match.

## Risks

- Risk: Tailwind CDN inline styles have higher specificity than site.css
  classes, making migration to shared classes produce unexpected overrides.
  Severity: medium
  Likelihood: medium
  Mitigation: Use `!important` sparingly and only in site.css where a
  Tailwind utility must be overridden. Prefer replacing inline Tailwind
  classes with site.css classes to avoid conflicts. Test each component
  migration with css-view before and after.

- Risk: The twelve pages were exported from different UXPilot revisions and
  may contain subtle HTML structural differences (e.g. `<div>` vs `<section>`
  for the same logical component) that make a uniform CSS class application
  produce different visual results.
  Severity: low
  Likelihood: medium
  Mitigation: Normalize HTML structure as part of the overhaul. Document any
  structural changes in Surprises & Discoveries.

- Risk: Removing inline `<style>` blocks may break page-specific components
  (e.g. `roadmap-item`, `release-card`, `table-row`) that are only used on
  one page.
  Severity: medium
  Likelihood: high
  Mitigation: Audit every inline class before removal. Move page-specific
  classes that appear on only one page to site.css with a comment noting their
  single-page scope. This keeps all CSS in one place without forcing
  unnecessary generalization.

## Progress

- [x] (2026-03-10) Stage A: Audit — identify all inconsistencies and deviations
- [x] (2026-03-10) Stage B: Consolidate shared CSS in site.css
- [x] (2026-03-10) Stage C: Apply design system alignment across all pages
- [x] (2026-03-10) Stage D: Validate with Playwright and css-view
- [x] (2026-03-10) Stage E: Final commit and retrospective

## Surprises & discoveries

- Observation: The installation, deployment, database-backends, roadmap, and changelog
  pages already had responsive padding (`px-4 sm:px-8`) and responsive hero heading
  sizes — only the earlier pages (home, quickstart, architecture, protocol, compatibility)
  needed these fixes.
  Evidence: Code inspection during audit.
  Impact: Reduced scope of C4/C5/C6 changes on newer pages.

- Observation: Axe-core reported contrast violations for design system badge colours
  (mint-tea on green tint, saffron-muted on yellow tint) and footer text. These are
  design system choices, not regressions.
  Evidence: Axe-core audits on home, roadmap, changelog, compatibility pages.
  Impact: No action required — these are pre-existing design choices inherited from the
  authoritative design system document.

## Decision log

- Decision: Pre-existing axe-core contrast violations in design system badge colours
  and footer text were not addressed.
  Rationale: Constraint 3 states the design system is authoritative. The badge colours
  (#4a8c5c on #e8f5ec, #c89430 on #fff4e0) and footer text (#3a3a55 on #12121f) are
  design system prescriptions. Fixing them would violate the constraint.
  Date/Author: 2026-03-10 / agent

- Decision: The `Inter` font was removed from the Tailwind config but left in the
  Google Fonts import URL.
  Rationale: Removing it from the import would change the URL and is unnecessary. The
  font will simply not be referenced by any CSS rule.
  Date/Author: 2026-03-10 / agent

## Context and orientation

### Repository structure

The website lives at `mxd/` relative to repository root:

```plaintext
mxd/
  index.html                  Home page (474 lines)
  assets/
    site.css                  Shared CSS (335 lines, BEM-style .mxd-* classes)
    logo-mark.svg             Brand mark (96x96 diamond motif)
    pattern-hero.svg          Repeating diamond pattern (60x60)
    pattern-section.svg       Smaller repeating pattern variant
  architecture/index.html     Architecture overview
  changelog/index.html        Release changelog
  compatibility/index.html    Client compatibility matrix
  configuration/index.html    TOML/env/CLI configuration
  database-backends/index.html  SQLite vs PostgreSQL
  deployment/index.html       systemd, containers, operations
  installation/index.html     Build toolchains and variants
  protocol/index.html         Wire format specification
  quickstart/index.html       Five-minute getting started
  roadmap/index.html          Delivery phases and constraints
  verification/index.html     TLA+, Stateright, Kani proofs
```

The design system reference is at `docs/mxd-design-system.html` — a
self-contained HTML document with inline CSS that defines every design token,
component, and pattern.

### Current CSS architecture

Each page loads:
1. Font Awesome CSS + JS from a content delivery network (CDN)
2. Google Fonts (JetBrains Mono, DM Serif Display, Source Serif 4, Inter)
3. Tailwind CSS from CDN with an inline config block
4. An inline `<style>` block with page-specific animations and hover classes
5. `mxd/assets/site.css` with shared component classes

The Tailwind config is identical across all pages and defines four font
families: `primary` (JetBrains Mono), `secondary` (DM Serif Display),
`tertiary` (Source Serif 4), `display` (Inter).

The existing `site.css` defines CSS custom properties and shared components for
the header, navigation, page TOC, route guide cards, and patterns. These are
well-structured and consistent.

### Design system tokens (from `docs/mxd-design-system.html`)

The design system defines the following CSS custom properties:

```css
/* Core palette — Marrakesh */
--terracotta:       #C54B2A;
--terracotta-light: #D4714F;
--terracotta-dark:  #9A3A1F;
--saffron:          #E8A838;
--saffron-light:    #F2C96A;
--saffron-muted:    #C89430;
--indigo:           #2D3A8C;
--indigo-light:     #4A58B0;
--indigo-dark:      #1E2760;

/* Neutrals — Kohl and Sandstone */
--kohl:             #12121F;
--kohl-lighter:     #1A1A2E;
--kohl-mid:         #2A2A42;
--kohl-soft:        #3A3A55;
--sandstone:        #F5E6D0;
--sandstone-light:  #FAF3EA;
--sandstone-dark:   #E8D5B8;
--parchment:        #FDF8F0;

/* Semantic — Protocol signals */
--mint-tea:         #4A8C5C;
--mint-tea-light:   #6AAF7A;
--amber-signal:     #FFB347;
--error-red:        #C43A3A;
--xor-magenta:      #A855A0;
```

Typography:
- Display: DM Serif Display — page titles, section headings, hero text. Never
  below 1.44rem.
- Body: Source Serif 4 — editorial prose. 0.833rem-1.2rem, line-height 1.7.
- Mono: JetBrains Mono — code, protocol data, labels, badges, UI chrome.
  Never exceeds 1rem in running text.
- (Inter is NOT in the design system. It appears only in the export.)

Key components:
- Express Line: 4px gradient bar (terracotta → saffron → indigo), 8s shimmer
  animation. Appears at hero top and footer top.
- Transaction Frame Stripe: colour-coded byte display per the design system's
  field-to-colour mapping.
- Terminal Window (frame-card): Kohl background, traffic-light dots, syntax
  highlighting from the palette.
- Callout: 3px left border in terracotta, sandstone-light background.
- Buttons: primary (terracotta fill), outline (terracotta border), ghost
  (sandstone-dark border), dark (kohl fill).
- Badges: supported (mint-tea on light green), partial (saffron-muted on
  light yellow), planned (indigo on light indigo), rust (terracotta fill).
- Zellij pattern: nested diamond SVG at opacity ≤ 0.12, only on parchment or
  sandstone backgrounds.

Transition easing: `cubic-bezier(0.22, 1, 0.36, 1)` — the design system
calls this the slightly-overshooting ease-out. Duration: 150ms (fast), 300ms
(medium), 600ms (slow).


## Plan of work

### Stage A: Audit — catalogue of inconsistencies

This stage produces the detailed audit below. No files are modified.

#### A1. Internal inconsistencies between pages

**Hero section heights differ without apparent reason:**
- Home: `style="height: 639px;"` (fixed pixel)
- Quickstart, Architecture, Protocol, Compatibility: `style="height: 480px;"`
- Roadmap, Changelog: `style="height: 400px;"`
The design system does not prescribe fixed pixel heights. The hero's height
should be determined by content and padding, not an inline style override.

**Responsive padding inconsistency:**
- Home, Quickstart, Architecture, Protocol, Compatibility pages use `px-8`
  for all content wrappers.
- Roadmap and Changelog pages use `px-4 sm:px-8` for content wrappers,
  hero sections, and footer.
The roadmap/changelog approach (mobile-first responsive padding) is the
correct pattern. The older pages omit the mobile breakpoint.

**Hero heading responsive sizing inconsistency:**
- Home, Quickstart, Architecture, Protocol, Compatibility: fixed
  `text-[68.80px]` with no responsive scaling.
- Roadmap, Changelog: responsive
  `text-4xl sm:text-5xl md:text-[68.80px]` with proper breakpoints.
The roadmap/changelog pattern is correct and should be applied everywhere.

**Hero subtitle element type:**
- Home: `<p>` element for subtitle.
- Architecture, Protocol: `<div>` wrapper with `<p>` children and
  `space-y-4`.
This is a legitimate structural difference where architecture/protocol have
multi-paragraph subtitles. No action needed.

**Section padding inconsistency:**
- Most pages: `py-20` for content sections.
- Roadmap, Changelog: `py-16 sm:py-20`.
Again, roadmap/changelog is more mobile-considerate. Apply everywhere.

**Inline style class naming divergence:**
Each page's `<style>` block defines different hover/transition classes:
- Home: `.card-feature`, `.btn-tertiary`
- Quickstart: `.code-block`
- Architecture: `.card-hover`
- Roadmap: `.card-hover`, `.roadmap-item`
- Changelog: `.card-hover`, `.release-card`
- Compatibility: `.table-row`
- Protocol: (no page-specific classes beyond shared)

These should be consolidated into site.css with consistent naming.

**Button font-weight inconsistency:**
- Home, Quickstart, Architecture, Protocol, Compatibility:
  `font-normal` on buttons.
- Roadmap, Changelog: `font-bold` on buttons.
The design system specifies `font-weight: 600` for buttons. Neither
`font-normal` (400) nor `font-bold` (700) is correct. Should be
`font-semibold` (600).

**Footer CTA section missing from some pages:**
- Home, Quickstart, Architecture, Protocol, Compatibility: have a
  `#footer-cta` section with CTA buttons before the dark footer.
- Roadmap, Changelog: embed CTA within the last content section instead.
This is a content/layout choice, not an inconsistency. No action needed.

**Footer padding inconsistency:**
- Home, Quickstart, Architecture, Protocol, Compatibility: `px-8`.
- Roadmap, Changelog: `px-4 sm:px-8`.
Same mobile-first pattern gap as above.

#### A2. Deviations from the design system

**D1. Font family "display" uses Inter instead of a design system font.**
The Tailwind config defines `"display": ["Inter", "sans-serif"]`. Inter does
not appear anywhere in the design system. It is used in the site for inline
code references (e.g. `font-display` on `<span>` and `<code>` elements
referencing function names or file paths). The design system prescribes
JetBrains Mono for "code, protocol data, field labels, badges, and UI chrome."
All `font-display` usages should become `font-primary` (JetBrains Mono).

**D2. Section labels use `font-normal` weight instead of `font-bold`.**
The design system's `.section-label` specifies `font-weight: 600` and
`letter-spacing: 0.2em`. The site's section labels use
`text-[11.10px] font-normal font-primary uppercase`. The weight should be
`font-semibold` (600) or `font-bold` (700, since 600 maps to semibold in
Tailwind) and letter-spacing should be `tracking-[0.2em]`.

**D3. Section heading (h2) size deviates.**
The design system specifies `--text-3xl: 2.488rem` (≈39.8px) for `h2`. The
site uses `text-[39.80px]` which is correct in absolute terms but expressed
as a magic number. Not a deviation per se, but it should use the design system
variable if possible.

**D4. The Express Line gradient endpoint colours differ.**
Design system hero: `from terracotta via saffron to indigo` with a shimmer.
Design system footer: `from terracotta via saffron to indigo` (no shimmer,
static).
Site hero top: `from-[#c54b2a] via-[#e8a838] to-[#2d3a8c]` — correct.
Site hero bottom: `from-[#c54b2a] via-[#e8a838] to-[#c54b2a]` — ends with
terracotta, not indigo. This is inconsistent with the design system's footer
gradient which ends with indigo.

**D5. Code block text uses Inter (`font-display`) instead of JetBrains Mono.**
Terminal window code content on quickstart/architecture/protocol uses
`font-display` (Inter) for `<pre>` content. The design system's frame-card
body specifies `font-family: 'JetBrains Mono', monospace` and
`font-size: var(--text-sm)`. All code block `<pre>` content should use
`font-primary`.

**D6. Badge colour mapping has a cross-wiring error.**
The design system specifies:
- Supported: `background: #E8F5EC; color: var(--mint-tea); border: #C4E5CC`
- Partial: `background: #FFF4E0; color: var(--saffron-muted); border: #F2DCA8`
- Planned: `background: #E8EAF6; color: var(--indigo); border: #C5CAE9`

The site uses:
- Supported: `bg-[#e8eaf6]` (indigo background!) with `border-[#c4e5cc]`
  (green border) and `text-[#4a8c5c]` (green text).
- Partial: `bg-[#e8eaf6]` (indigo background!) with `border-[#f2dca8]`
  (yellow border) and `text-[#c89430]` (yellow text).
- Planned: `bg-[#e8eaf6]` (indigo background!) with `border-[#c5cae9]`
  (indigo border) and `text-[#2d3a8c]` (indigo text).

All three badge types use `bg-[#e8eaf6]` (the indigo tint) regardless of
status. The correct backgrounds per the design system are:
- Supported: `bg-[#e8f5ec]` (green tint)
- Partial: `bg-[#fff4e0]` (yellow tint)
- Planned: `bg-[#e8eaf6]` (indigo tint — only this one is correct)

**D7. Callout component border-left width.**
The design system specifies `border-left: 3px solid var(--terracotta)`. The
site uses `border-l-2` (2px). Should be `border-l-[3px]`.

**D8. Callout component border-radius.**
The design system specifies `border-radius: 0 var(--radius-md) var(--radius-md) 0`
(4px top-right and bottom-right). The site uses `rounded-tr rounded-br` which
is `border-radius: 0.25rem` (4px) — this is actually correct.

**D9. Button border-radius.**
The design system specifies `border-radius: var(--radius-md)` (4px). The site
uses `rounded` which is `border-radius: 0.25rem` (4px). This is correct.

**D10. Card border-radius.**
The design system specifies `border-radius: var(--radius-lg)` (8px). The site
uses `rounded-lg` which is `border-radius: 0.5rem` (8px). This is correct.

**D11. Card shadow on hover.**
The design system specifies `--shadow-card: 0 4px 16px rgba(18,18,31,0.10)`
on hover. The site's `.card-feature:hover` uses
`box-shadow: 0 12px 32px rgba(18,18,31,0.15)` which is closer to
`--shadow-deep`. The default card state should use `--shadow-card` and hover
should elevate to `--shadow-deep`.

**D12. Transaction stripe layout.**
The design system uses a CSS Grid (`grid-template-columns: repeat(auto-fit, minmax(80px, 1fr))`)
for the transaction byte stripe. The site uses `flex flex-wrap` instead. The
visual result is similar but the bytes in the site use `min-w-[81.79px]` as a
floor width rather than the grid's `minmax(80px, 1fr)`. The protocol page
uses `flex-1` without a min-width. These should be standardized to match the
design system's grid approach.

**D13. Missing design system CSS custom properties.**
The site's `site.css` defines `--mxd-*` variables that are a subset of the
design system tokens but with different names. The design system uses
`--terracotta`, `--saffron`, etc. The site uses `--mxd-accent`, `--mxd-gold`,
etc. The mapping is:
- `--mxd-paper` = `--parchment` (#fdf8f0)
- `--mxd-ink` = `--kohl` (#12121f)
- `--mxd-muted` = `--kohl-soft` (#3a3a55)
- `--mxd-accent` = `--terracotta` (#c54b2a)
- `--mxd-accent-dark` = `--terracotta-dark` (#9a3a1f)
- `--mxd-gold` = `--saffron` (#e8a838)
- `--mxd-border` = `--sandstone-dark` (#e8d5b8)

Missing from site.css:
- `--terracotta-light` (#D4714F), `--saffron-light` (#F2C96A),
  `--saffron-muted` (#C89430), `--indigo` (#2D3A8C), `--indigo-light`
  (#4A58B0), `--indigo-dark` (#1E2760), `--kohl-lighter` (#1A1A2E),
  `--kohl-mid` (#2A2A42), `--sandstone` (#F5E6D0), `--sandstone-light`
  (#FAF3EA), `--mint-tea` (#4A8C5C), `--mint-tea-light` (#6AAF7A),
  `--amber-signal` (#FFB347), `--error-red` (#C43A3A), `--xor-magenta`
  (#A855A0).

The inline Tailwind classes hardcode these hex values (e.g. `bg-[#2d3a8c]`,
`text-[#4a8c5c]`). Extending the site.css variables and Tailwind config to
reference them would improve maintainability but is a large change.
The minimum action is to add the missing variables to site.css `:root` so
they are available for future use and for the new shared classes.

#### A3. Shared utilities to extract to site.css

The following patterns are repeated across multiple pages and should become
shared classes in site.css:

1. **`.mxd-express-line`** — the shimmer animation and gradient. Currently
   defined identically in every page's `<style>` block.

2. **`.mxd-btn--primary`**, **`.mxd-btn--outline`**, **`.mxd-btn--ghost`** —
   button variants with hover states. Currently `.btn-primary`,
   `.btn-secondary`, `.btn-tertiary` in inline styles (names also don't match
   the design system which uses primary/outline/ghost/dark).

3. **`.mxd-code-block`** — terminal window hover effect. Currently
   `.code-block` on quickstart only.

4. **`.mxd-card-hover`** — card lift-on-hover. Currently `.card-feature` on
   home, `.card-hover` on architecture/roadmap/changelog.

5. **`.mxd-badge--supported`**, **`.mxd-badge--partial`**,
   **`.mxd-badge--planned`** — status badges with correct colours per D6.

6. **`.mxd-callout`** — callout/aside component with 3px left border.

7. **`.mxd-section-label`** — the section eyebrow labels (e.g. "01 — Overview").

8. **`.mxd-hero`** — hero section base styles (dark background, overflow
   hidden, pattern overlay, express lines).

9. **`.mxd-content`** — the `max-w-[900px] mx-auto px-4 sm:px-8` content
   wrapper used on every page.

10. **`.mxd-footer`** — dark footer with gradient bar.

11. **`.mxd-footer-cta`** — the white CTA section above the footer.

12. **`.mxd-frame-card`** — terminal window component (kohl background,
    traffic-light header, code body).

13. **`.mxd-tx-stripe`** — transaction frame byte stripe.

14. **Page-specific classes** moved to site.css:
    - `.mxd-roadmap-item` — roadmap item hover.
    - `.mxd-release-card` — changelog release card hover.
    - `.mxd-table-row` — compatibility table row hover.


### Stage B: Consolidate shared CSS

In this stage, `mxd/assets/site.css` is modified to add the complete design
system token set and all shared component classes identified in A3.

**B1.** Add the full design system colour palette as CSS custom properties
in `:root`, using `--mxd-*` naming convention (preserving the existing names,
adding the missing ones).

**B2.** Add the shared animation (`@keyframes mxd-shimmer`) and the
`.mxd-express-line` class.

**B3.** Add button classes: `.mxd-btn--primary`, `.mxd-btn--outline`,
`.mxd-btn--ghost`, `.mxd-btn--dark`. Follow the design system's specifications
for colours, border, padding, and hover behaviour (translateY(-1px) for
primary, translateY(-2px) for others per design system; use consistent
`cubic-bezier(0.22, 1, 0.36, 1)` easing).

**B4.** Add `.mxd-card-hover` for the shared card lift effect.

**B5.** Add `.mxd-code-block` for terminal window hover.

**B6.** Add badge classes with correct background colours per D6.

**B7.** Add `.mxd-callout` with 3px border per D7.

**B8.** Add `.mxd-section-label` for section eyebrow labels.

**B9.** Add `.mxd-content` for the content wrapper.

**B10.** Add `.mxd-footer` and `.mxd-footer-cta`.

**B11.** Add `.mxd-frame-card`, `.mxd-frame-card__header`,
`.mxd-frame-card__body` for terminal windows.

**B12.** Add page-specific classes that live in site.css:
`.mxd-roadmap-item`, `.mxd-release-card`, `.mxd-table-row`.

**B13.** Remove the `Inter` font family from the Tailwind config. Map
`display` to JetBrains Mono, or simply remove it and use `font-primary`
everywhere.


### Stage C: Apply design system alignment

In this stage, all twelve HTML pages are modified.

**C1.** Remove inline `<style>` blocks from all pages. All styles now live in
site.css. The only remaining inline content is the Tailwind config `<script>`.

**C2.** Update the Tailwind config on all pages: remove the `display` font
family mapping to Inter. If any page still needs Inter for a specific purpose,
escalate (tolerance: no new fonts).

**C3.** Remove `style="height: Npx"` from all hero sections. Let content +
padding determine height.

**C4.** Standardize responsive padding: `px-4 sm:px-8` everywhere (content
wrappers, heroes, footers). Replace bare `px-8` on home, quickstart,
architecture, protocol, compatibility pages.

**C5.** Standardize responsive hero heading sizes:
`text-4xl sm:text-5xl md:text-[68.80px]` on all pages.

**C6.** Standardize section padding: `py-16 sm:py-20` on all content sections.

**C7.** Fix all `font-display` usages → `font-primary` (D1, D5).

**C8.** Fix section label weight: `font-semibold` + `tracking-[0.2em]` (D2).

**C9.** Fix hero bottom Express Line gradient: change
`from-[#c54b2a] via-[#e8a838] to-[#c54b2a]` to
`from-[#c54b2a] via-[#e8a838] to-[#2d3a8c]` (D4).

On re-reading the design system, the hero has the shimmer animation at the
bottom and the footer has a static gradient. The hero bottom bar on the site
uses a different gradient (terracotta → saffron → terracotta) which does not
match the hero. The design system shows the same tri-colour gradient at both
top and bottom of the hero. Cross-checking: the design system's `.hero::after`
uses `background: linear-gradient(90deg, var(--terracotta), var(--saffron),
var(--indigo), var(--terracotta))` with shimmer. The site's hero top has the
shimmer; the bottom does not and uses terracotta as the end colour. The correct
fix: both hero bars should use the tri-colour gradient. The bottom bar should
match the footer's static gradient (terracotta → saffron → indigo).

**C10.** Fix badge background colours (D6):
- Supported: `bg-[#e8eaf6]` → `bg-[#e8f5ec]`
- Partial: `bg-[#e8eaf6]` → `bg-[#fff4e0]`
- Planned: already correct (`bg-[#e8eaf6]`)

**C11.** Fix callout border width: `border-l-2` → `border-l-[3px]` (D7).

**C12.** Fix button font-weight: all buttons should use `font-semibold` (600)
per the design system.

**C13.** Replace inline class names with site.css class names:
- `.btn-primary` → `.mxd-btn--primary`
- `.btn-secondary` → `.mxd-btn--outline`
- `.btn-tertiary` → `.mxd-btn--ghost`
- `.card-feature` → `.mxd-card-hover`
- `.card-hover` → `.mxd-card-hover`
- `.code-block` → `.mxd-code-block`
- `.roadmap-item` → `.mxd-roadmap-item`
- `.release-card` → `.mxd-release-card`
- `.table-row` → `.mxd-table-row`

**C14.** Apply `.mxd-express-line` class and remove inline `.express-line`
definitions.

**C15.** Ensure the `<title>` on each page includes the site name:
e.g. `<title>Architecture — mxd</title>` instead of just
`<title>Architecture</title>`.


### Stage D: Validate with Playwright and css-view

**D1.** Serve the site locally with `python3 -m http.server` from the `mxd/`
directory.

**D2.** Use Playwright to take accessibility snapshots and screenshots of each
page to verify visual consistency.

**D3.** Use `css-view` to capture computed styles and verify:
- Badge background colours match design system.
- Button font-weight is 600.
- Callout border-left width is 3px.
- Section labels have letter-spacing 0.2em and font-weight 600.
- Code blocks use JetBrains Mono, not Inter.
- Hero heights are not fixed pixels.

**D4.** Run accessibility tests with the Playwright MCP accessibility tools.

**D5.** Fix any issues found during validation.


### Stage E: Final commit and retrospective

**E1.** Commit all changes.
**E2.** Update this plan's Outcomes & Retrospective section.


## Concrete steps

(Will be populated during execution. Each stage will record the exact commands
run and their outputs.)


## Validation and acceptance

Quality criteria:
- All twelve pages render with consistent visual language.
- Badge colours match design system: supported=green tint, partial=yellow tint,
  planned=indigo tint.
- Buttons use font-weight 600, correct border-radius (4px), correct hover
  behaviour.
- Code blocks use JetBrains Mono, not Inter.
- Section labels use font-weight 600 and letter-spacing 0.2em.
- Callouts have 3px left border.
- Hero sections have no fixed pixel heights.
- All responsive padding uses `px-4 sm:px-8`.
- All hero headings use responsive sizing.
- No inline `<style>` blocks remain in any page.
- Express Line gradient is consistent (terracotta → saffron → indigo).
- css-view confirms computed styles match expectations.
- Playwright accessibility tests show no regressions.

Quality method:
- Serve site with `python3 -m http.server` from `mxd/`.
- Playwright screenshots of all pages.
- css-view snapshots of badge, button, callout, section-label, code-block
  elements.
- Axe-core accessibility audit via MCP tool.


## Idempotence and recovery

All changes are to static HTML and CSS files tracked in git. If any stage
produces unexpected results, `git checkout -- mxd/` restores the previous
state. Each milestone will be committed separately so partial rollback is
possible.


## Artifacts and notes

(Will be populated during execution.)


## Interfaces and dependencies

No new interfaces or dependencies. The site continues to use:
- Tailwind CSS CDN
- Google Fonts CDN (JetBrains Mono, DM Serif Display, Source Serif 4)
- Font Awesome CDN
- `mxd/assets/site.css` (extended, not replaced)

The `Inter` font will be removed from the Tailwind config but not from the
Google Fonts import (harmless; removing it from the import would change the
URL and is unnecessary).

## Outcomes & retrospective

All five stages completed successfully. The mxd website now presents a
consistent visual language across all twelve pages, aligned with the Protocol
Souk design system.

**What was achieved:**

- All 12 inline `<style>` blocks removed; styles consolidated in site.css.
- 14 shared component classes added to site.css with `.mxd-*` BEM naming.
- Complete design system colour palette added as CSS custom properties.
- Badge colours corrected: Supported=#e8f5ec, Partial=#fff4e0, Planned=#e8eaf6.
- Inter font removed from Tailwind config; all `font-display` usages migrated
  to `font-primary` (JetBrains Mono).
- Button font-weight standardized to 600 (font-semibold) per design system.
- Callout border-left width corrected to 3px per design system.
- Hero bottom gradient corrected to terracotta→saffron→indigo.
- Fixed pixel hero heights removed; content determines height.
- Responsive padding (`px-4 sm:px-8`) and heading sizes applied consistently.
- Express Line shimmer animation centralized as `.mxd-express-line`.
- All page titles include `— mxd` suffix.

**Validation results:**

- css-view confirms: buttons use font-weight 600, JetBrains Mono. Section
  labels use font-weight 600, JetBrains Mono. Callout borders are 3px.
  Badge backgrounds match design system. Zero elements use Inter.
- Axe-core accessibility audits show no regressions. Pre-existing contrast
  issues in badge colours and footer text are design system choices.
- Playwright screenshots confirm visual consistency across pages.

**Lessons learned:**

- Parallelizing page edits across 11 background agents was effective. The
  cross-cutting verification step afterwards caught the few items that
  individual agents missed (border-l-2 on 3 pages).
- Systematic grep-based verification after agent work is essential — it
  catches inconsistencies that individual agents may overlook.
