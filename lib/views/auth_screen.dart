import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/app_state.dart';
import '../stitch_ui/home_dashboard_dark_mode_unified/home_dashboard_screen.dart';
import 'personnel/personnel_dashboard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  UserRole _selectedRole = UserRole.student;
  String? _errorMessage;
  bool _isLoading = false;

  /// Simulates the Google Account Picker for the hackathon demo
  void _triggerGoogleSignIn() {
    setState(() => _errorMessage = null);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose an account',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('to continue to Mendly',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                const SizedBox(height: 24),

                // --- Student accounts ---
                _buildGoogleAccountTile(
                  name: 'Chaitanya',
                  email: 'chaitanya.26cse@bmu.edu.in',
                  avatarColor: const Color(0xFF10B981),
                  onTap: () => _processLogin('chaitanya.26cse@bmu.edu.in'),
                ),
                const Divider(color: Color(0xFF334155), height: 1),

                // --- Invalid personal account (shows domain filter to judges) ---
                _buildGoogleAccountTile(
                  name: 'Chaitanya (Personal)',
                  email: 'chaitanya.dev@gmail.com',
                  avatarColor: const Color(0xFF64748B),
                  onTap: () => _processLogin('chaitanya.dev@gmail.com'),
                ),
                const Divider(color: Color(0xFF334155), height: 1),

                // --- Personnel account (locked to personnel@enviro.in) ---
                _buildGoogleAccountTile(
                  name: 'Enviro Personnel',
                  email: 'personnel@enviro.in',
                  avatarColor: const Color(0xFF6366F1),
                  badge: '🔧 Personnel Only',
                  onTap: () => _processLogin('personnel@enviro.in'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Processes the selected email through the app's validation logic.
  /// Personnel are exclusively authenticated via personnel@enviro.in.
  void _processLogin(String email) async {
    final appState = Provider.of<AppState>(context, listen: false);

    Navigator.pop(context);
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      final success = appState.login(email, _selectedRole);
      if (success) {
        final nextScreen = _selectedRole == UserRole.student
            ? const HomeDashboardScreen()
            : const PersonnelDashboard();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = _selectedRole == UserRole.personnel
              ? 'Personnel access is restricted. Use the personnel@enviro.in account.'
              : 'Access Restricted: Only @bmu.edu.in accounts are permitted.';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'System Error: Check your terminal logs.';
        });
      }
    }
  }

  Widget _buildGoogleAccountTile({
    required String name,
    required String email,
    required Color avatarColor,
    required VoidCallback onTap,
    String? badge,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Row(
        children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
              ),
              child: Text(badge,
                  style: const TextStyle(
                      color: Color(0xFF818CF8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      subtitle: Text(email, style: const TextStyle(color: Color(0xFF94A3B8))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.build_circle_rounded,
                        size: 48, color: Color(0xFF818CF8)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Mendly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1)),
                const SizedBox(height: 6),
                const Text('Campus Super-App & Dispatch',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                const SizedBox(height: 28),

                // Role Toggle — Student / Personnel only
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Student')),
                          selected: _selectedRole == UserRole.student,
                          selectedColor: const Color(0xFF6366F1),
                          labelStyle: TextStyle(
                              color: _selectedRole == UserRole.student
                                  ? Colors.white
                                  : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.bold),
                          onSelected: (_) =>
                              setState(() => _selectedRole = UserRole.student),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('Personnel')),
                          selected: _selectedRole == UserRole.personnel,
                          selectedColor: const Color(0xFF6366F1),
                          labelStyle: TextStyle(
                              color: _selectedRole == UserRole.personnel
                                  ? Colors.white
                                  : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.bold),
                          onSelected: (_) => setState(
                              () => _selectedRole = UserRole.personnel),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error Display
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              const Color(0xFFEF4444).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.gpp_bad_outlined,
                            color: Color(0xFFF87171), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(_errorMessage!,
                                style: const TextStyle(
                                    color: Color(0xFFF87171), fontSize: 12))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Single Google Sign-In Button (Using safe local icon)
                _isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF818CF8)))
                    : ElevatedButton(
                        onPressed: _triggerGoogleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.g_mobiledata,
                                color: Colors.blue, size: 32),
                            SizedBox(width: 8),
                            Text('Sign in with Google',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ],
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
