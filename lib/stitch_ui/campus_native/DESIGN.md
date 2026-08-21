---
name: Campus Native
colors:
  surface: '#fcf9ef'
  surface-dim: '#dcdad0'
  surface-bright: '#fcf9ef'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f4ea'
  surface-container: '#f0eee4'
  surface-container-high: '#eae8de'
  surface-container-highest: '#e4e3d9'
  on-surface: '#1b1c16'
  on-surface-variant: '#5d3f3d'
  inverse-surface: '#30312a'
  inverse-on-surface: '#f3f1e7'
  outline: '#926e6c'
  outline-variant: '#e7bcba'
  surface-tint: '#bf0022'
  primary: '#ac001e'
  on-primary: '#ffffff'
  primary-container: '#d90429'
  on-primary-container: '#ffeae8'
  inverse-primary: '#ffb3af'
  secondary: '#795744'
  on-secondary: '#ffffff'
  secondary-container: '#ffd0b9'
  on-secondary-container: '#7a5745'
  tertiary: '#78435c'
  on-tertiary: '#ffffff'
  tertiary-container: '#935b75'
  on-tertiary-container: '#ffe9f0'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad7'
  primary-fixed-dim: '#ffb3af'
  on-primary-fixed: '#410005'
  on-primary-fixed-variant: '#930018'
  secondary-fixed: '#ffdbca'
  secondary-fixed-dim: '#eabda6'
  on-secondary-fixed: '#2d1507'
  on-secondary-fixed-variant: '#5f3f2e'
  tertiary-fixed: '#ffd8e7'
  tertiary-fixed-dim: '#f7b3d0'
  on-tertiary-fixed: '#350b22'
  on-tertiary-fixed-variant: '#69374f'
  background: '#fcf9ef'
  on-background: '#1b1c16'
  surface-variant: '#e4e3d9'
  racing-red: '#D90429'
  coffee-beans: '#4B2E1E'
  black-cherry: '#31081F'
  alabaster-grey: '#F2F0E6'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 34px
    fontWeight: '700'
    lineHeight: 41px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  button:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '600'
    lineHeight: 22px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 16px
  margin-desktop: 32px
  gutter: 16px
---

## Brand & Style

The design system is engineered for the fast-paced, high-utility environment of a modern campus. It adopts a **Corporate / Modern** style heavily influenced by the **Native iOS Human Interface Guidelines (HIG)**, prioritizing familiarity, speed, and reliability. The aesthetic is clean and functional, yet warmth is injected through a refined academic palette, moving away from sterile defaults toward a more prestigious, collegiate feel.

The personality is helpful and efficient, evoking an emotional response of organized control. To achieve this, the system utilizes **Glassmorphism** for navigation elements—providing spatial context—and a **Minimalist** approach to layout that ensures students can find information at a glance. It bridges the gap between a high-tech utility and a trusted campus institution.

## Colors

The color palette balances urgent utility with campus heritage. 

- **Primary (Racing Red):** A high-energy, high-visibility red used strictly for calls-to-action, alerts, and critical system feedback.
- **Secondary (Coffee Beans):** A grounded, organic brown used for secondary UI elements, strokes, and card backgrounds to provide a tactile, paper-like quality.
- **Tertiary (Black Cherry):** A deep, sophisticated dark tone used for dark mode surfaces and high-level structural hierarchy.
- **Neutral (Alabaster Grey):** The primary light-mode surface color. It is warmer than pure white, reducing eye strain during long study sessions.

In **Light Mode**, Alabaster Grey serves as the canvas with Coffee Beans providing structure. In **Dark Mode**, Black Cherry becomes the primary surface, with Alabaster Grey transitioning to a high-contrast text color.

## Typography

The system utilizes **Inter** as a systematic, highly legible alternative to Helvetica Neue, maintaining the "Standard iOS" feel while offering better performance on high-density displays.

The hierarchy follows the Apple San Francisco scale to ensure it feels native to the device. Headlines use tighter tracking and heavier weights to establish clear content anchors. Body text is optimized for 17pt (iOS Standard) to ensure maximum accessibility for students moving between campus locations. Labels use a subtle uppercase treatment to differentiate metadata from primary content.

## Layout & Spacing

This design system employs a **Fluid Grid** model based on a 4px baseline rhythm.

- **Mobile:** A 4-column grid with 16px side margins. Components should span the full width or 2 columns.
- **Desktop:** A 12-column grid with 32px side margins. Content is typically centered in a maximum 1200px container.
- **Vertical Rhythm:** Spacing between sections should default to 24px (lg) or 32px (xl) to maintain the airy, modern iOS feel.

The layout should prioritize the "Safe Area" on mobile devices, ensuring critical navigation is always within the thumb's reach in the bottom half of the screen.

## Elevation & Depth

Hierarchy is communicated through a mix of **Glassmorphism** and **Ambient Shadows**.

- **Glassmorphism:** Navigation bars and Tab bars must use a backdrop-filter blur (20px-30px) with a semi-transparent layer of Alabaster Grey (light mode) or Black Cherry (dark mode). This maintains a sense of place as the user scrolls.
- **Ambient Shadows:** Surfaces like cards and modals use very soft, diffused shadows with a large blur radius (12px-24px) and low opacity (5-10%). Shadows should be tinted with a hint of the secondary color (Coffee Beans) to avoid "muddy" greys.
- **Tonal Stacking:** Higher-level surfaces (like popovers) should be visually lighter in light mode and visually darker in dark mode to simulate physical proximity to the user.

## Shapes

The shape language is defined by **Rounded** corners, mirroring the hardware aesthetics of modern smartphones.

- **Standard Elements:** Buttons and input fields use a 0.5rem (8px) radius.
- **Container Elements:** Large cards and top-level containers use a 1rem (16px) radius to create a soft, inviting frame for content.
- **Full Rounding:** Search bars and specific "Pill" tags use a maximum radius for distinct visual categorization.
- **Modals:** Bottom sheets use a 1.5rem (24px) radius on top corners only to suggest they are docked to the bottom of the screen.

## Components

- **Buttons:** Primary buttons are solid Racing Red with White text. Secondary buttons use a Coffee Beans outline or a subtle Alabaster-tinted fill. All buttons feature a 50px-56px touch target height for mobile ergonomics.
- **Cards:** Cards should use a subtle Coffee Beans border (10% opacity) or a soft ambient shadow to separate from the Alabaster background.
- **Input Fields:** Use an inset style with a very light neutral fill. On focus, the border transitions to a 2px Racing Red stroke.
- **Navigation Bars:** Must feature glassmorphism with a thin bottom-border separator (1px Coffee Beans at 5% opacity).
- **Chips & Tags:** Small, rounded-full elements using Coffee Beans with low opacity for categorization without competing with primary actions.
- **Lists:** iOS-style "Inward-inset" lists with horizontal separators that stop before the icon/text margin.
- **Selection Controls:** Checkboxes and Radio buttons are circular and use Racing Red for the "on" state to ensure clear visual confirmation.