# Mendly: Design to Flutter Handoff Guide (Antigravity IDE)

This document provides the technical specifications, design tokens, and structural mapping required to implement the Mendly UI in Flutter.

## 1. Core Design Tokens (Theme Data)

Implement these values in your `ThemeData` or a custom `AppColors` class.

### Color Palette
- **Alabaster Grey (Surface):** `#FBF9F2` (Primary Background)
- **Black Cherry (Dark Surface/Primary):** `#2E0014` (Dark Mode Background)
- **Racing Red (Action):** `#BD0000` (Buttons, CTA, High Alert)
- **Coffee Beans (Text/Secondary):** `#13140E` (Deep contrast text)

### Typography
- **Primary Font:** Helvetica Neue
- **Heading 1:** 24px Bold, Coffee Beans
- **Body Text:** 16px Regular, Coffee Beans
- **Action Labels:** 14px Semi-bold, Racing Red or White (on Red)

### Layout Constants
- **Container Margin:** 16px (Standard iOS padding)
- **Border Radius:** 12px (Rounded containers/cards)
- **Glassmorphism:** `BackdropFilter` with `ImageFilter.blur(sigmaX: 10, sigmaY: 10)` and `Colors.white.withOpacity(0.1)`.

---

## 2. Screen Mapping & Flutter Structure

| Design Screen | Flutter Widget Path | Key Logic / Features |
| :--- | :--- | :--- |
| Home Dashboard | `lib/screens/home/dashboard.dart` | `ListView` with Horizontal Cards for Alerts |
| Shuttle Booking | `lib/screens/shuttle/booking.dart` | Bus Number List, Real-time status polling |
| Mess Management | `lib/screens/mess/management.dart` | QR Code Generator (`qr_flutter` package) |
| Worker Task Queue | `lib/screens/worker/task_queue.dart` | High-priority Task Cards, Image Upload |
| Warden Dashboard | `lib/screens/warden/dashboard.dart` | Approval Workflow, Broadcast management |

---

## 3. Implementation Checklist for Antigravity IDE

1. **Asset Management:**
   - Add `Helvetica Neue` to your `pubspec.yaml`.
   - Export icons as SVGs and use the `flutter_svg` package for resolution-independent rendering.

2. **Dark/Light Mode:**
   - Use `Theme.of(context).colorScheme` to ensure seamless switching between Alabaster Grey and Black Cherry themes.

3. **QR Implementation:**
   - For the Mess and Day Pass screens, use `QrImageView` to render the student IDs dynamically from your backend API.

4. **Glassmorphic AppBars:**
   - Use `SliverAppBar` with a `BackdropFilter` as the `flexibleSpace` to achieve the premium iOS look designed in Stitch.

---

## 4. API Integration Suggestions

- **Auth:** Standardize headers using the Login/Sign-up templates.
- **Maintenance:** Link the "Upload Proof" button to a `MultipartRequest` for image hosting.
- **Shuttle:** Fetch bus occupancy and numbers via a `StreamBuilder` for live updates.