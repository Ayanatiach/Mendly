import 'dart:ui';
import 'package:flutter/material.dart';
import '../../stitch_ui/home_dashboard_dark_mode_unified/home_dashboard_screen.dart';
import 'student_dashboard.dart'; // Repairs / Maintenance screen
import 'mess_screen.dart'; // Mess entry & menu screen
import 'shuttle_screen.dart'; // Shuttle transit screen

/// The root tab container for the Student view with a theme-aware glassmorphic dock.
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  // The four core feature screens for the campus super-app
  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    StudentDashboard(),
    MessScreen(),
    ShuttleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF2E0014) : const Color(0xFFFBF9F2);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // The currently selected screen
          _screens[_currentIndex],

          // The Floating Custom Dock with iOS safe area handling
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFloatingDock(isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingDock(bool isDark) {
    final dockBg = isDark ? const Color(0xFF1A0D08) : Colors.white;
    final dockBorder = isDark
        ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
        : const Color(0xFF1A0D08).withValues(alpha: 0.1);

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: dockBg.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: dockBorder, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDockItem(0, Icons.home_outlined, Icons.home_rounded, 'Home', isDark),
                const SizedBox(width: 8),
                _buildDockItem(1, Icons.build_circle_outlined, Icons.build_circle_rounded, 'Repairs', isDark),
                const SizedBox(width: 8),
                _buildDockItem(2, Icons.restaurant_outlined, Icons.restaurant_rounded, 'Mess', isDark),
                const SizedBox(width: 8),
                _buildDockItem(3, Icons.directions_bus_outlined, Icons.directions_bus_rounded, 'Shuttle', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an individual dock item that expands/collapses dynamically
  Widget _buildDockItem(
      int index, IconData outlineIcon, IconData solidIcon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    const racingRed = Color(0xFFD90429);
    final unselectedColor = isDark ? const Color(0xFFE7BCBA) : const Color(0xFF703248);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 14.0 : 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? racingRed.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              color: isSelected ? racingRed : unselectedColor,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: racingRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
