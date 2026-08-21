---
name: Heritage Tech
colors:
  surface: '#fbf9f2'
  surface-dim: '#dcdad3'
  surface-bright: '#fbf9f2'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f4ec'
  surface-container: '#f0eee7'
  surface-container-high: '#eae8e1'
  surface-container-highest: '#e4e2dc'
  on-surface: '#1b1c18'
  on-surface-variant: '#5d3f3b'
  inverse-surface: '#30312c'
  inverse-on-surface: '#f3f1ea'
  outline: '#926f69'
  outline-variant: '#e7bdb6'
  surface-tint: '#c00402'
  primary: '#900000'
  on-primary: '#ffffff'
  primary-container: '#bd0000'
  on-primary-container: '#ffc9c1'
  inverse-primary: '#ffb4a8'
  secondary: '#a13c3f'
  on-secondary: '#ffffff'
  secondary-container: '#ff8484'
  on-secondary-container: '#751c22'
  tertiary: '#554137'
  on-tertiary: '#ffffff'
  tertiary-container: '#6e584d'
  on-tertiary-container: '#eed0c2'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad4'
  primary-fixed-dim: '#ffb4a8'
  on-primary-fixed: '#410000'
  on-primary-fixed-variant: '#930000'
  secondary-fixed: '#ffdad8'
  secondary-fixed-dim: '#ffb3b1'
  on-secondary-fixed: '#410007'
  on-secondary-fixed-variant: '#82252a'
  tertiary-fixed: '#fbdcce'
  tertiary-fixed-dim: '#dec1b3'
  on-tertiary-fixed: '#281810'
  on-tertiary-fixed-variant: '#574238'
  background: '#fbf9f2'
  on-background: '#1b1c18'
  surface-variant: '#e4e2dc'
  racing-red: '#BD0000'
  black-cherry: '#630D16'
  coffee-beans: '#3C2A21'
  alabaster-grey: '#F2F0E9'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  button:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 20px
  gutter: 16px
---

## Brand & Style

This design system embodies a **Modern Luxury** aesthetic, merging the high-performance precision of technical interfaces with a heritage-inspired color palette. The brand personality is prestigious and decisive, catering to a sophisticated audience that values efficiency and tactile elegance.

The visual style is defined by **Minimalism** with a **Corporate** structure. It utilizes generous whitespace and a "paper-and-ink" contrast logic, where the warmth of the background prevents the interface from feeling sterile. The emotional response is one of confidence and exclusivity, achieved through sharp typography, deep crimson accents, and a highly structured layout.

## Colors

The palette is built on a high-contrast foundation that replaces standard digital neutrals with an editorial, sophisticated spectrum.

- **Primary (Racing Red):** Used exclusively for high-priority actions and critical status indicators.
- **Secondary (Black Cherry):** Reserved for headers and brand-defining accents, providing a deep, luxurious anchor.
- **Tertiary (Coffee Beans):** The primary color for all body text and high-contrast borders, offering a warmer feel than pure black.
- **Neutral (Alabaster Grey):** The universal surface color, serving as a sophisticated canvas that reduces eye strain.

## Typography

The design system utilizes **Inter** (as a high-quality alternative to Helvetica Neue) to maintain a clean, systematic feel. The premium nature is conveyed through tight tracking in headlines and deliberate weight distribution.

- **Editorial Hierarchy:** Headlines use Black Cherry to establish a distinct brand voice, while body text uses Coffee Beans for maximum legibility.
- **Labels:** Use uppercase for utility labels and category headers to provide a structural, organized feel.
- **Interactions:** Button text is always semi-bold to ensure clarity on high-impact Racing Red backgrounds.

## Layout & Spacing

The layout follows a **Fluid Grid** model with a consistent 8px rhythm (2 units).

- **Grid Logic:** Use a 4-column grid for mobile and a 12-column grid for desktop. Margins are generous to emphasize the minimalist, premium feel.
- **Vertical Rhythm:** Spacing between disparate components should favor the `xl` (32px) unit to allow the "Alabaster" surface to breathe.
- **Reflow:** On tablet transitions, gutter widths remain constant while column widths expand.

## Elevation & Depth

Depth is achieved through **Tonal Layers** and **Low-Contrast Outlines** rather than heavy shadows, keeping the design clean and modern.

- **Surface Tiers:** Use subtle desaturations of the Alabaster base to create visual depth and hierarchy.
- **Ghost Borders:** For cards and inputs, use a 1px border in Coffee Beans at 10-15% opacity. This creates a crisp edge without visual noise.
- **Active Elevation:** Only Racing Red primary buttons and modals use a soft, tinted shadow (a low-opacity Racing Red tint) to suggest they sit above the interface.

## Shapes

The shape language is sophisticated and approachable, utilizing consistent rounding to mirror modern OS aesthetics.

- **Base Radius:** A 0.5rem (8px) base is applied to standard buttons and inputs.
- **Container Radius:** Cards and larger surfaces use 1rem or 1.5rem to soften high-contrast color transitions.
- **Pill Elements:** Reserved exclusively for status tags and categorical indicators to differentiate them from actionable rectangular buttons.

## Components

- **Primary Buttons:** Solid Racing Red background with White text. 56px height for mobile; 48px for desktop.
- **Headers:** Navigation bars should use Black Cherry with light-colored icons for a bold entrance.
- **Input Fields:** Alabaster Grey backgrounds with a 1px Coffee Beans border at low opacity. On focus, the border shifts to Racing Red.
- **Cards:** Use a slightly brighter Alabaster surface than the background, defined by a fine Coffee Beans stroke.
- **Selection Controls:** Checkboxes and Radio buttons use Racing Red for the active state to ensure visibility against the warm background.
- **Action Sheets:** Large corner radii (24px) with a prominent grab handle for mobile-first interaction patterns.