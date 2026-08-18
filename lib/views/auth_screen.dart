import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/app_state.dart';
import 'student/main_tab_screen.dart';
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

                // Valid BMU Account Mock (Using safe local icons instead of Network Images)
                _buildGoogleAccountTile(
                  name: 'Chaitanya',
                  email: 'chaitanya.26cse@bmu.edu.in',
                  avatarColor: const Color(0xFF10B981),
                  onTap: () => _processLogin('chaitanya.26cse@bmu.edu.in'),
                ),
                const Divider(color: Color(0xFF334155), height: 1),

                // Invalid Personal Account Mock (To prove the filter works to judges)
                _buildGoogleAccountTile(
                  name: 'Chaitanya (Personal)',
                  email: 'chaitanya.dev@gmail.com',
                  avatarColor: const Color(0xFF6366F1),
                  onTap: () => _processLogin('chaitanya.dev@gmail.com'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Processes the selected email through your app's validation logic
  void _processLogin(String email) async {
    // 1. Grab the state BEFORE the async delay to prevent context loss
    final appState = Provider.of<AppState>(context, listen: false);

    Navigator.pop(context); // Close the bottom sheet
    setState(() => _isLoading = true); // Start spinner

    try {
      // Simulate network delay for realism
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      // 2. Perform the login logic
      final success = appState.login(email, _selectedRole);

      if (success) {
        // 3. Smooth transition: Do NOT turn off the spinner if we are navigating away.
        // Let it keep spinning as it smoothly animates to the next screen.
        Widget nextScreen = _selectedRole == UserRole.student
            ? const MainTabScreen()
            : const PersonnelDashboard();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      } else {
        // If domain fails, stop the spinner and show the error
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Access Restricted: Mendly requires an active @bmu.edu.in university account.';
        });
      }
    } catch (error) {
      // Failsafe: If anything crashes in the background, stop the spinner!
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'System Error: Check your terminal logs.';
        });
      }
    }
  }

  Widget _buildGoogleAccountTile(
      {required String name,
      required String email,
      required Color avatarColor,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
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

                // Role Toggle
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
