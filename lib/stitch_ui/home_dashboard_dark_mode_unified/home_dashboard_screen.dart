import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../views/student/create_ticket_screen.dart';
import '../../views/student/mess_screen.dart';
import '../../views/student/shuttle_screen.dart';
import '../../views/student/student_dashboard.dart';
import '../login_dark_mode/login_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens — exact match to the Stitch dark-mode home dashboard HTML
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const surface    = Color(0xFF1A0D08); // coffee-beans
  static const racingRed  = Color(0xFFD90429); // racing-red
  static const redDark    = Color(0xFFBF0022); // gradient bottom
  static const alabaster  = Color(0xFFF2F0E6); // alabaster-grey
  static const surfaceVar = Color(0xFFE7BCBA); // on-surface-variant
  static const surfHigh   = Color(0xFF35352F); // surface-container-highest
  static const outline    = Color(0xFF5D3F3D); // outline-variant
  static const navBg      = Color(0xFF200010); // bottom nav (black-cherry/90)
}

/// The main home dashboard for student users.
/// Mirrors the Stitch `home_dashboard_dark_mode_unified` HTML layout:
///   • Glassmorphic sticky AppBar (avatar + "Mendly" + bell)
///   • Profile setup card (tappable, shows real user name/email)
///   • 2×2 Bento-grid Quick-Access tiles
///   • "Generate Day Pass" primary CTA
///   • Bottom navigation bar (Home / Maintenance / Mess / Shuttle)
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0; // 0 = Home, 1 = Maintenance, 2 = Mess, 3 = Shuttle

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Routing helpers
  // ---------------------------------------------------------------------------
  void _onNavTap(int index) {
    if (index == _navIndex) return;
    setState(() => _navIndex = index);

    Widget? dest;
    switch (index) {
      case 1:
        dest = const StudentDashboard(); // Maintenance / Repairs
        break;
      case 2:
        dest = const MessScreen();
        break;
      case 3:
        dest = const ShuttleScreen();
        break;
    }
    if (dest != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => dest!),
      ).then((_) => setState(() => _navIndex = 0)); // reset on pop
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final user = appState.currentUser;
    final name = user?.name ?? 'Student';
    final email = user?.email ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF2E0014) : const Color(0xFFFBF9F2);
    final surface = isDark ? const Color(0xFF1A0D08) : Colors.white;
    final border = isDark
        ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
        : const Color(0xFF1A0D08).withValues(alpha: 0.08);
    final textPrimary = isDark ? const Color(0xFFF2F0E6) : const Color(0xFF1A0D08);
    final textMuted = isDark ? const Color(0xFFE7BCBA) : const Color(0xFF703248);

    // Derive initials for the avatar fallback
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'S';

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: bg,
      extendBodyBehindAppBar: true,
      // ── Glassmorphic AppBar (iOS Notch & Dynamic Island Safe) ─────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: surface.withValues(alpha: 0.75),
                border: Border(
                  bottom: BorderSide(
                    color: border,
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            // ── Avatar button ────────────────────────────────────
            GestureDetector(
              onTap: () => _showProfileSheet(context, appState),
              child: _Avatar(initials: initials),
            ),
            const SizedBox(width: 10),
            // ── App title ────────────────────────────────────────
            const Text(
              'Mendly',
              style: TextStyle(
                color: _C.racingRed,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          // ── Theme toggle ─────────────────────────────────────
          IconButton(
            onPressed: () => appState.toggleTheme(),
            icon: Icon(
              appState.currentTheme == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: textMuted,
              size: 22,
            ),
            tooltip: 'Toggle Theme',
            splashRadius: 20,
          ),
          // ── Notification bell ────────────────────────────────
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined,
                color: textMuted, size: 24),
            splashRadius: 20,
          ),
          const SizedBox(width: 4),
        ],
      ),
      // ── Body ─────────────────────────────────────────────────────────────
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, topPadding + kToolbarHeight + 16, 16, 120),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Profile setup card ──────────────────────────────────
                  _ProfileCard(
                    name: name,
                    email: email,
                    surface: surface,
                    border: border,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 28),

                  // ── Quick Access label ──────────────────────────────────
                  Text(
                    'Quick Access',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── 2×2 Bento grid ─────────────────────────────────────
                  _BentoGrid(
                    tiles: [
                      _BentoTile(
                        icon: Icons.apartment_rounded,
                        label: 'Hostel\nServices',
                        surface: surface,
                        border: border,
                        textPrimary: textPrimary,
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CreateTicketScreen()),
                        ),
                      ),
                      _BentoTile(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Mess\nQR',
                        surface: surface,
                        border: border,
                        textPrimary: textPrimary,
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MessScreen()),
                        ),
                      ),
                      _BentoTile(
                        icon: Icons.directions_bus_rounded,
                        label: 'Shuttle\nBooking',
                        surface: surface,
                        border: border,
                        textPrimary: textPrimary,
                        isDark: isDark,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ShuttleScreen()),
                        ),
                      ),
                      _BentoTile(
                        icon: Icons.map_rounded,
                        label: 'Campus\nMap',
                        surface: surface,
                        border: border,
                        textPrimary: textPrimary,
                        isDark: isDark,
                        onTap: () {}, // future screen
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── Primary CTA ─────────────────────────────────────────
                  _DayPassButton(),
                ],
              ),
            ),
          ),
        ),
      ),
      // ── Bottom nav bar ───────────────────────────────────────────────────
      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        isDark: isDark,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile bottom sheet
  // ---------------------------------------------------------------------------
  void _showProfileSheet(BuildContext ctx, AppState appState) {
    final user = appState.currentUser;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: _C.outline.withValues(alpha: 0.4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: _C.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(user?.name ?? 'Unknown',
                style: const TextStyle(
                    color: _C.alabaster,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user?.email ?? '',
                style: const TextStyle(color: _C.surfaceVar, fontSize: 13)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded,
                    color: _C.racingRed, size: 18),
                label: const Text('Sign Out',
                    style: TextStyle(
                        color: _C.racingRed, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: _C.racingRed.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  appState.logout();
                  Navigator.of(ctx).popUntil((r) => r.isFirst);
                  Navigator.pushReplacement(
                    ctx,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Circular avatar with initial fallback and red border ring
class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [_C.racingRed, _C.redDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
            color: _C.alabaster.withValues(alpha: 0.1), width: 1),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// The glassmorphic "Setup Profile" card — wired to real user name/email
class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final bool isDark;

  const _ProfileCard({
    required this.name,
    required this.email,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: surface.withValues(alpha: isDark ? 0.7 : 0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? _C.surfHigh : const Color(0xFFE4E3D9),
                  border: Border.all(
                      color: border),
                ),
                child: Icon(Icons.person_add_outlined,
                    color: textMuted, size: 20),
              ),
              const SizedBox(width: 14),
              // User info — wired to AppState
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: _C.racingRed,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2×2 bento-grid layout wrapper
class _BentoGrid extends StatelessWidget {
  final List<_BentoTile> tiles;
  const _BentoGrid({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: tiles,
    );
  }
}

/// Individual bento tile — glassmorphic card with icon + label
class _BentoTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final bool isDark;
  final VoidCallback onTap;

  const _BentoTile({
    required this.icon,
    required this.label,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<_BentoTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _pressed
                    ? Colors.white.withValues(alpha: widget.isDark ? 0.05 : 0.3)
                    : widget.surface.withValues(alpha: widget.isDark ? 0.7 : 0.95),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _pressed
                      ? _C.racingRed.withValues(alpha: 0.35)
                      : widget.border,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: widget.isDark ? 0.35 : 0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pressed
                          ? _C.racingRed.withValues(alpha: 0.2)
                          : (widget.isDark ? _C.surfHigh : const Color(0xFFE4E3D9)),
                      border: Border.all(
                        color: _pressed
                            ? _C.racingRed.withValues(alpha: 0.3)
                            : widget.border,
                        width: 0.5,
                      ),
                    ),
                    child: Icon(widget.icon,
                        color: _C.racingRed, size: 22),
                  ),
                  const Spacer(),
                  // Label
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Generate Day Pass" primary CTA button
class _DayPassButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_C.racingRed, _C.redDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _C.racingRed.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.confirmation_number_rounded,
                    color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Generate Day Pass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom nav bar — faithfully matches Stitch: Home / Maintenance / Mess / Shuttle
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final navBg = isDark ? _C.navBg : const Color(0xFFF2F0E6);
    final border = isDark
        ? _C.alabaster.withValues(alpha: 0.15)
        : _C.surface.withValues(alpha: 0.08);
    final textMuted = isDark ? _C.surfaceVar : const Color(0xFF703248);

    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (Icons.build_rounded, Icons.build_outlined, 'Maintenance'),
      (Icons.restaurant_rounded, Icons.restaurant_outlined, 'Mess'),
      (Icons.directions_bus_rounded, Icons.directions_bus_outlined, 'Shuttle'),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: navBg.withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                  color: border, width: 0.5),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                children: List.generate(items.length, (i) {
                  final isActive = currentIndex == i;
                  final (solidIcon, outlineIcon, label) = items[i];
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: AnimatedOpacity(
                        opacity: isActive ? 1.0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isActive ? solidIcon : outlineIcon,
                              color: isActive ? _C.racingRed : textMuted,
                              size: 22,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              label,
                              style: TextStyle(
                                color: isActive ? _C.racingRed : textMuted,
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
