import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/app_state.dart';
import '../../stitch_ui/login_dark_mode/login_screen.dart';

class AccountProfileView extends StatelessWidget {
  const AccountProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    final bool isStudent = user?.role == UserRole.student;
    final Color roleAccent =
        isStudent ? const Color(0xFF818CF8) : const Color(0xFF10B981);
    final String roleLabel =
        isStudent ? 'Student Account' : 'Maintenance Personnel';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'Account & Session Info',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: roleAccent.withValues(alpha: 0.15),
                    child: Icon(
                      isStudent
                          ? Icons.school_rounded
                          : Icons.engineering_rounded,
                      size: 40,
                      color: roleAccent,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.name ?? 'University Member',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'No email authenticated',
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: roleAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: roleAccent.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      roleLabel,
                      style: TextStyle(
                          color: roleAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Authentication & Verification Details
            Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SESSION & DOMAIN VERIFICATION',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.domain_verification_rounded,
                    title: 'Domain Status',
                    value: 'Verified University Domain',
                    valueColor: const Color(0xFF10B981),
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  _buildInfoRow(
                    icon: Icons.badge_outlined,
                    title: 'Account ID',
                    value: user?.id ?? 'UNASSIGNED',
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  _buildInfoRow(
                    icon: Icons.shield_outlined,
                    title: 'Access Level',
                    value: isStudent
                        ? 'Standard Campus Reporter'
                        : 'Authorized Field Technician',
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),
                  _buildInfoRow(
                    icon: Icons.vpn_key_outlined,
                    title: 'Auth Provider',
                    value: 'Google SSO (@bmu.edu.in)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Session Sign Out Action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  appState.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded,
                    color: Color(0xFFF87171), size: 18),
                label: const Text(
                  'End Active Session',
                  style: TextStyle(
                      color: Color(0xFFF87171), fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFEF4444).withValues(alpha: 0.12),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFEF4444), width: 0.8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = Colors.white,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF818CF8)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: valueColor)),
          ],
        ),
      ],
    );
  }
}
