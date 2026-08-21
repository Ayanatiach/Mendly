---
name: Heritage Tech Dark
colors:
  surface: '#13140e'
  surface-dim: '#13140e'
  surface-bright: '#393a33'
  surface-container-lowest: '#0e0f09'
  surface-container-low: '#1b1c16'
  surface-container: '#1f201a'
  surface-container-high: '#2a2a24'
  surface-container-highest: '#35352f'
  on-surface: '#e4e3d9'
  on-surface-variant: '#e7bcba'
  inverse-surface: '#e4e3d9'
  inverse-on-surface: '#30312a'
  outline: '#ae8885'
  outline-variant: '#5d3f3d'
  surface-tint: '#ffb3af'
  primary: '#ffb3af'
  on-primary: '#68000e'
  primary-container: '#d90429'
  on-primary-container: '#ffeae8'
  inverse-primary: '#bf0022'
  secondary: '#ffb1c8'
  on-secondary: '#551c32'
  secondary-container: '#703248'
  on-secondary-container: '#ef9eb7'
  tertiary: '#dbc1b8'
  on-tertiary: '#3d2d26'
  tertiary-container: '#7d6860'
  on-tertiary-container: '#ffebe5'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdad7'
  primary-fixed-dim: '#ffb3af'
  on-primary-fixed: '#410005'
  on-primary-fixed-variant: '#930018'
  secondary-fixed: '#ffd9e2'
  secondary-fixed-dim: '#ffb1c8'
  on-secondary-fixed: '#3a061d'
  on-secondary-fixed-variant: '#703248'
  tertiary-fixed: '#f9ddd3'
  tertiary-fixed-dim: '#dbc1b8'
  on-tertiary-fixed: '#271813'
  on-tertiary-fixed-variant: '#55433c'
  background: '#13140e'
  on-background: '#e4e3d9'
  surface-variant: '#35352f'
  racing-red: '#D90429'
  black-cherry: '#2E0014'
  coffee-beans: '#1A0D08'
  alabaster-grey: '#F2F0E6'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 30px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 26px
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
    letterSpacing: 0.06em
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
  xl: 40px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 64px
---

## Brand & Style

This design system is a sophisticated evolution into high-performance dark mode aesthetics. It targets a premium demographic that values the intersection of heritage craftsmanship and cutting-edge technology. The brand personality is powerful, nocturnal, and prestigious.

The design style is a hybrid of **Minimalism** and **Glassmorphism**, drawing heavily from high-end iOS patterns. The interface feels like a precision instrument—dark, deep, and focused—utilizing translucent layers and vibrant crimson accents to create a sense of depth and exclusivity. The emotional response is one of "stealth luxury": calm, authoritative, and deeply immersive.

## Colors

The palette is anchored in deep, warm dark tones, avoiding pure black in favor of rich organic hues that provide more depth for glass effects.

- **Primary (Racing Red):** A high-energy, technical red used for calls to action, active states, and critical data points.
- **Secondary (Black Cherry):** The primary canvas color. This deep burgundy provides the foundation for the entire application.
- **Tertiary (Coffee Beans):** The surface color for containers and cards. It is slightly warmer and lighter than the background to create a tiered hierarchy.
- **Neutral (Alabaster Grey):** Used sparingly for primary text and high-contrast foreground elements to ensure readability against the dark substrate.

Color applications rely on translucency; use alpha variations of these hex codes (e.g., 80% opacity) for glass containers to allow the Black Cherry background to bleed through.

## Typography

This design system uses **Inter** to achieve the precision and legibility associated with high-end iOS environments. The typographic scale is optimized for high-contrast reading in low-light environments.

- **Contrast Management:** Primary text uses Alabaster Grey at 100% opacity. Secondary text and metadata should use Alabaster Grey at 60-70% opacity to establish visual weight without introducing new colors.
- **Technical Precision:** Labels and utility text use increased letter spacing and uppercase styling to mimic technical instrumentation.
- **Refinement:** Headlines are tightly tracked to maintain a "bold" and "impactful" presence, essential for the premium narrative.

## Layout & Spacing

The layout is governed by a **Fluid Grid** with an 8px base rhythm. It prioritizes content density within spacious container margins to maintain a premium feel.

- **Grid System:** 12-column grid for desktop with wide 64px margins; 4-column grid for mobile with 20px margins.
- **Rhythm:** Use the `xl` (40px) unit for vertical sectioning to ensure the glass containers have enough "air" to be perceived as distinct layers.
- **Consistency:** All internal container padding should default to `lg` (24px) to provide a luxurious, uncrowded internal layout.

## Elevation & Depth

Hierarchy is established through **Glassmorphism** and **Ambient Shadows** that utilize tinted light rather than darkness.

- **Backdrop Blurs:** Card surfaces (Coffee Beans) should use a 20px - 32px backdrop blur with a 60-80% opacity fill. This allows the Black Cherry background colors to glow through the containers.
- **Inner Borders:** Every elevated container must have a 0.5px solid inner border (stroke) using Alabaster Grey at 15% opacity. This "rim light" effect is crucial for defining edges in a dark environment.
- **Shadows:** Use large, diffused shadows with a color tint of `#000000` at 40% opacity. Primary elements (like Racing Red buttons) use a subtle red outer glow to signify their active state.

## Shapes

The shape language is defined by large, "squircle"-inspired radii that reflect the premium iOS aesthetic.

- **Standard Radius:** 0.5rem (8px) for buttons, small inputs, and chips.
- **Container Radius:** 1rem (16px) for standard cards. 1.5rem (24px) for prominent modals and large dashboard tiles.
- **Pill Shapes:** Exclusively for search bars and notification badges to provide a distinct visual departure from the structural grid.

## Components

- **Glass Cards:** The signature component. Coffee Beans background at 70% opacity with a 20px backdrop blur and a fine 0.5pt Alabaster rim stroke.
- **Primary Buttons:** Solid Racing Red with Alabaster Grey text. Use a subtle top-down gradient (Racing Red to a slightly darker shade) to add tactile depth.
- **Input Fields:** Semi-transparent Black Cherry background with an Alabaster border at 20% opacity. On focus, the border glows Racing Red.
- **Segmented Controls:** A glass-filled track with a solid Tertiary (Coffee Beans) sliding thumb.
- **Lists:** Separated by "hairline" dividers—1px Alabaster Grey at 10% opacity, inset by 16px from the edges.
- **Checkboxes & Radios:** High-contrast Racing Red fills for selected states, with a distinct Alabaster Grey check/dot.
- **Bottom Sheets:** Mobile-specific containers with a 32px top-radius and a subtle Alabaster "grab bar" at 30% opacity.