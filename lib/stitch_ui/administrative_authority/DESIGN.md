---
name: Administrative Authority
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#524347'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#847377'
  outline-variant: '#d6c1c6'
  surface-tint: '#8c4960'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#3a061d'
  on-primary-container: '#b86e86'
  inverse-primary: '#ffb1c8'
  secondary: '#5e5f57'
  on-secondary: '#ffffff'
  secondary-container: '#e4e3d9'
  on-secondary-container: '#65655d'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#410005'
  on-tertiary-container: '#fc2d3d'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffd9e2'
  primary-fixed-dim: '#ffb1c8'
  on-primary-fixed: '#3a061d'
  on-primary-fixed-variant: '#703248'
  secondary-fixed: '#e4e3d9'
  secondary-fixed-dim: '#c8c7bd'
  on-secondary-fixed: '#1b1c16'
  on-secondary-fixed-variant: '#474740'
  tertiary-fixed: '#ffdad7'
  tertiary-fixed-dim: '#ffb3af'
  on-tertiary-fixed: '#410005'
  on-tertiary-fixed-variant: '#930018'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 57px
    fontWeight: '700'
    lineHeight: 64px
    letterSpacing: -0.25px
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-sm:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
    letterSpacing: 0.15px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-max: 1440px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 32px
---

## Brand & Style

The design system is engineered for high-stakes administrative environments, specifically tailored for the warden's dashboard of a college management system. The brand personality is authoritative, decisive, and exceptionally organized. It draws heavily from **Corporate Modern** aesthetics and **Material Design 3 (M3)** principles, focusing on functional clarity and rapid information processing.

The target audience consists of administrative staff who manage high volumes of requests (leave permissions, room allocations, disciplinary logs). The UI evokes a sense of calm control through expansive whitespace, structured hierarchies, and a palette that signals professional gravity.

**Style Guidelines:**
- **Rational Grid:** Every element is placed with mathematical intent.
- **Controlled Urgency:** High-contrast accents are reserved for critical decision points.
- **Structured Surfaces:** Depth is used to separate high-level metrics from granular data tables.

## Colors

The palette is rooted in a professional, neutral foundation with high-contrast structural accents.

- **Background (Alabaster Grey):** Used for the global application background to reduce eye strain during long sessions.
- **Primary (Black Cherry):** Used for primary navigation, headers, and high-level structural components. It provides a sophisticated alternative to pure black.
- **Secondary (Coffee Bean):** Reserved for secondary text and icons, ensuring legibility while maintaining a professional "ink" feel.
- **Action States:**
    - **Racing Red:** Exclusively for "Deny," "Reject," or "Alert" actions.
    - **Emerald Green:** Exclusively for "Approve," "Grant," or "Success" states.
- **Surface:** Pure white is used for cards and containers to pop against the Alabaster background.

## Typography

This design system utilizes **Inter** for its exceptional legibility in data-dense environments. The type scale follows a systematic approach to ensure clear information architecture.

- **Headlines:** Use Bold or Semi-Bold weights to anchor the page.
- **Body:** Standardized at 16px for readability, using the Regular weight.
- **Labels:** Used for table headers, form captions, and status chips.
- **Numerical Data:** For dashboards, ensure tabular lining figures are used to allow easy comparison of student IDs or room numbers.

## Layout & Spacing

The layout is based on an **8px linear scale**, ensuring consistent alignment across all components.

**Grid System:**
- **Desktop:** 12-column fluid grid with 24px gutters. A fixed side navigation bar (280px) remains anchored to the left.
- **Tablet:** 8-column grid with 16px gutters. Side navigation collapses into a hamburger menu.
- **Mobile:** 4-column grid with 16px margins. Content stacks vertically.

**Spacing Philosophy:**
Use `lg` (24px) for padding within major dashboard cards. Use `sm` (8px) for spacing between related input fields or list items.

## Elevation & Depth

Consistent with M3, elevation is used to communicate surface hierarchy. In this design system, elevation is achieved through a combination of **Tonal Layers** and **Soft Ambient Shadows**.

- **Level 0 (Base):** Alabaster Grey (#F2F2F2). Global background.
- **Level 1 (Cards):** White (#FFFFFF). Surface for list items and minor widgets. Shadow: 0px 1px 3px rgba(0,0,0,0.05).
- **Level 2 (Active/Hover):** White (#FFFFFF). Shadow: 0px 4px 8px rgba(0,0,0,0.08).
- **Level 3 (Modals/Popovers):** White (#FFFFFF). Shadow: 0px 12px 24px rgba(0,0,0,0.12).

Avoid heavy black shadows. Tint shadows with a hint of Coffee Bean (#1B1C16) to maintain the palette's warmth.

## Shapes

The shape language balance authority with modern approachability.

- **Standard Components:** Buttons, Input Fields, and Chips use a `0.5rem` (8px) radius.
- **Containers:** Large dashboard cards and modal windows use `1rem` (16px) radius.
- **Selection Indicators:** Use "Pill" shapes for status badges (e.g., "Active," "Pending") to differentiate them from functional buttons.

## Components

**Buttons:**
- **Primary:** Black Cherry background with White text. Used for "Add New," "Submit," or primary dashboard actions.
- **Success/Approve:** Emerald Green background with White text.
- **Destructive/Deny:** Racing Red background with White text.
- **Ghost:** Transparent background with Coffee Bean border and text for secondary actions.

**Input Fields:**
- Outlined style with a 1px border in Coffee Bean (30% opacity). On focus, the border thickens to 2px and color changes to Black Cherry.

**Chips (Status Badges):**
- Use a light tint of the state color for the background (e.g., 10% Emerald Green) with dark-toned text for the label.

**Cards:**
- All cards must have a 1px subtle stroke (#E0E0E0) to define boundaries against the Alabaster background, in addition to Level 1 elevation.

**Data Tables:**
- Use "Zebra Striping" with Alabaster Grey on even rows. Header row should have a solid Coffee Bean bottom border.

**Additional Recommended Components:**
- **Stat Widget:** A card displaying a single large number (e.g., "Total Students In") with a small trend indicator.
- **Timeline:** A vertical list with dots to track "Leave History" or "Disciplinary Actions."