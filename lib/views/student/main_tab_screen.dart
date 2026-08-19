import 'package:flutter/material.dart';
import 'student_dashboard.dart'; // Repairs screen
import 'mess_screen.dart'; // New mess screen
import 'shuttle_screen.dart'; // New shuttle screen

/// The root screen for the Student view containing the animated floating dock.
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  // The three core feature screens for the campus super-app
  final List<Widget> _screens = const [
    StudentDashboard(),
    MessScreen(),
    ShuttleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      // We use a Stack so the dock floats seamlessly OVER the active screen
      body: Stack(
        children: [
          // The currently selected screen
          _screens[_currentIndex],

          // The Floating Custom Dock
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: _buildFloatingDock(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingDock() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B)
              .withValues(alpha: 0.9), // Glassmorphism base
          borderRadius: BorderRadius.circular(30),
          border:
              Border.all(color: const Color(0xFF334155).withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDockItem(
                0, Icons.build_circle_outlined, Icons.build_circle, 'Repairs'),
            const SizedBox(width: 12),
            _buildDockItem(
                1, Icons.restaurant_outlined, Icons.restaurant, 'Mess'),
            const SizedBox(width: 12),
            _buildDockItem(2, Icons.directions_bus_outlined,
                Icons.directions_bus, 'Shuttle'),
          ],
        ),
      ),
    );
  }

  /// Builds an individual dock item that expands/collapses dynamically
  Widget _buildDockItem(
      int index, IconData outlineIcon, IconData solidIcon, String label) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16.0 : 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? solidIcon : outlineIcon,
              color: isSelected
                  ? const Color(0xFF818CF8)
                  : const Color(0xFF94A3B8),
              size: 24,
            ),
            // The text only shows if this specific tab is selected
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF818CF8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
