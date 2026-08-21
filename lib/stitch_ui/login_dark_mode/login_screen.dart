import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/app_state.dart';
import '../../views/personnel/personnel_dashboard.dart';
import '../home_dashboard_dark_mode_unified/home_dashboard_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Design tokens extracted from the Stitch dark-mode HTML
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const background  = Color(0xFF2E0014); // Black Cherry
  static const surface     = Color(0xFF1A0D08); // Coffee Beans
  static const racingRed   = Color(0xFFD90429); // Racing Red
  static const redDark     = Color(0xFFB00320); // Gradient end
  static const alabaster   = Color(0xFFF2F0E6); // Alabaster Grey
  static const onSurface   = Color(0xFFE4E3D9);
  static const surfaceVar  = Color(0xFFE7BCBA); // on-surface-variant
  static const outline     = Color(0xFF5D3F3D); // outline-variant
}

/// Functional login screen converted from the Stitch dark-mode HTML design.
/// Handles email/password input, role selection, form validation and
/// routing into the correct dashboard via [AppState.login].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();

  UserRole _selectedRole     = UserRole.student;
  bool     _isLoading        = false;
  bool     _obscurePassword  = true;
  String?  _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Submit handler
  // ---------------------------------------------------------------------------
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppState>(context, listen: false);
    setState(() { _isLoading = true; _errorMessage = null; });

    // Simulate 800 ms network round-trip
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final success = appState.login(_emailCtrl.text.trim(), _selectedRole);

    if (success) {
      // Route based on role
      final Widget dest = _selectedRole == UserRole.personnel
          ? const PersonnelDashboard()
          : const HomeDashboardScreen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => dest),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = _selectedRole == UserRole.personnel
            ? 'Personnel access requires the personnel@enviro.in account.'
            : 'Access restricted to @bmu.edu.in university accounts.';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.background,
      body: Stack(
        children: [
          // ── Ambient glow blobs (translated from CSS blur divs) ─────────────
          _AmbientGlow(),

          // ── Main content ───────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: _GlassCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Header ────────────────────────────────────────
                          _buildHeader(),
                          const SizedBox(height: 28),

                          // ── Role selector ─────────────────────────────────
                          _buildRoleSelector(),
                          const SizedBox(height: 24),

                          // ── Email field ───────────────────────────────────
                          _buildLabel('Email'),
                          const SizedBox(height: 6),
                          _buildEmailField(),
                          const SizedBox(height: 16),

                          // ── Password field ────────────────────────────────
                          _buildLabel('Password'),
                          const SizedBox(height: 6),
                          _buildPasswordField(),
                          const SizedBox(height: 8),

                          // ── Forgot password ───────────────────────────────
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap),
                              child: const Text('Forgot Password?',
                                  style: TextStyle(
                                      color: _C.racingRed,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Error banner ──────────────────────────────────
                          if (_errorMessage != null) ...[
                            _buildErrorBanner(_errorMessage!),
                            const SizedBox(height: 16),
                          ],

                          // ── Sign In button ────────────────────────────────
                          _buildSignInButton(),
                          const SizedBox(height: 24),

                          // ── Divider ───────────────────────────────────────
                          _buildDivider(),
                          const SizedBox(height: 16),

                          // ── Social buttons ────────────────────────────────
                          _buildSSOButton(
                            icon: Icons.school_outlined,
                            label: 'Campus SSO',
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          _buildGoogleButton(),
                          const SizedBox(height: 24),

                          // ── Footer ────────────────────────────────────────
                          Center(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: _C.surfaceVar, fontSize: 13),
                                children: [
                                  TextSpan(
                                      text: "Don't have an account? "),
                                  TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                        color: _C.racingRed,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Widget builders ────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [_C.racingRed, Color(0xFFFF6B6B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Mendly',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white, // ShaderMask overrides this
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue to your dashboard.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _C.surfaceVar,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.outline.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          _RoleChip(
            label: 'Student',
            icon: Icons.school_outlined,
            selected: _selectedRole == UserRole.student,
            onTap: () => setState(() => _selectedRole = UserRole.student),
          ),
          const SizedBox(width: 4),
          _RoleChip(
            label: 'Personnel',
            icon: Icons.build_outlined,
            selected: _selectedRole == UserRole.personnel,
            onTap: () => setState(() => _selectedRole = UserRole.personnel),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _C.alabaster,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.06 * 12,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: _C.onSurface, fontSize: 15),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Email is required';
        if (!v.contains('@')) return 'Enter a valid email address';
        return null;
      },
      decoration: _fieldDecoration(
        hint: 'name@university.edu',
        prefixIcon: Icons.mail_outline_rounded,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordCtrl,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleSignIn(),
      style: const TextStyle(color: _C.onSurface, fontSize: 15),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Password is required';
        return null;
      },
      decoration: _fieldDecoration(
        hint: '••••••••',
        prefixIcon: Icons.lock_outline_rounded,
        suffix: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _C.surfaceVar.withValues(alpha: 0.6),
            size: 20,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: _C.surfaceVar.withValues(alpha: 0.4), fontSize: 15),
      prefixIcon: Icon(prefixIcon,
          color: _C.surfaceVar.withValues(alpha: 0.6), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: _C.background.withValues(alpha: 0.5),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
            color: _C.alabaster.withValues(alpha: 0.2), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
            color: _C.alabaster.withValues(alpha: 0.2), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
            color: _C.racingRed.withValues(alpha: 0.8), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFFFF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFFFF4444), width: 1.5),
      ),
      errorStyle:
          const TextStyle(color: Color(0xFFFF8080), fontSize: 11),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.racingRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.racingRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.gpp_bad_outlined,
              color: Color(0xFFFF8080), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    color: Color(0xFFFF8080), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_C.racingRed, _C.redDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _C.racingRed.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Sign In',
                          style: TextStyle(
                            color: _C.alabaster,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          )),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          color: _C.alabaster, size: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(
                color: _C.alabaster.withValues(alpha: 0.1),
                height: 1,
                thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('OR CONTINUE WITH',
              style: TextStyle(
                color: _C.surfaceVar.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              )),
        ),
        Expanded(
            child: Divider(
                color: _C.alabaster.withValues(alpha: 0.1),
                height: 1,
                thickness: 1)),
      ],
    );
  }

  Widget _buildSSOButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: _C.onSurface),
      label: Text(label,
          style: const TextStyle(
              color: _C.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: _C.surface.withValues(alpha: 0.8),
        side: BorderSide(
            color: _C.alabaster.withValues(alpha: 0.15), width: 0.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedRole = UserRole.student;
          _emailCtrl.text = 'student@bmu.edu.in';
          _passwordCtrl.text = 'password123';
        });
        _handleSignIn();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: _C.surface.withValues(alpha: 0.8),
        side: BorderSide(
            color: _C.alabaster.withValues(alpha: 0.15), width: 0.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Google G logo via vector path
          _GoogleIcon(),
          const SizedBox(width: 10),
          const Text('Google',
              style: TextStyle(
                  color: _C.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Glassmorphism card (translucent + backdrop blur)
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D08).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: const Color(0xFFF2F0E6).withValues(alpha: 0.15),
                width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Role selector chip
class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFD90429).withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFFD90429).withValues(alpha: 0.5)
                  : Colors.transparent,
              width: selected ? 1 : 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected
                      ? const Color(0xFFD90429)
                      : const Color(0xFFE7BCBA)),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFFD90429)
                        : const Color(0xFFE7BCBA),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ambient glow blobs — translated from the CSS blur div pair
class _AmbientGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: -size.height * 0.2,
          left: -size.width * 0.1,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD90429).withValues(alpha: 0.08),
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
        Positioned(
          bottom: -size.height * 0.2,
          right: -size.width * 0.1,
          child: Container(
            width: size.width * 0.6,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD90429).withValues(alpha: 0.04),
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}

/// Standard un-mirrored Google "G" vector icon (clean vector paths, no assets needed)
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Scale standard 24x24 vector coordinate system to target widget size
    canvas.scale(size.width / 24.0, size.height / 24.0);

    // 1. Blue crossbar and upper right
    final bluePath = Path()
      ..moveTo(22.56, 12.25)
      ..cubicTo(22.56, 11.47, 22.49, 10.72, 22.36, 10.0)
      ..lineTo(12.0, 10.0)
      ..lineTo(12.0, 14.26)
      ..lineTo(17.92, 14.26)
      ..cubicTo(17.66, 15.63, 16.88, 16.79, 15.71, 17.57)
      ..lineTo(15.71, 20.34)
      ..lineTo(19.28, 20.34)
      ..cubicTo(21.36, 18.42, 22.56, 15.60, 22.56, 12.25)
      ..close();
    canvas.drawPath(bluePath, Paint()..color = const Color(0xFF4285F4));

    // 2. Green bottom arc
    final greenPath = Path()
      ..moveTo(12.0, 23.0)
      ..cubicTo(14.97, 23.0, 17.46, 22.02, 19.28, 20.34)
      ..lineTo(15.71, 17.57)
      ..cubicTo(14.73, 18.23, 13.48, 18.63, 12.0, 18.63)
      ..cubicTo(9.14, 18.63, 6.71, 16.70, 5.84, 14.10)
      ..lineTo(2.18, 14.10)
      ..lineTo(2.18, 16.94)
      ..cubicTo(3.99, 20.53, 7.70, 23.0, 12.0, 23.0)
      ..close();
    canvas.drawPath(greenPath, Paint()..color = const Color(0xFF34A853));

    // 3. Yellow bottom-left arc
    final yellowPath = Path()
      ..moveTo(5.84, 14.10)
      ..cubicTo(5.62, 13.44, 5.49, 12.74, 5.49, 12.0)
      ..cubicTo(5.49, 11.26, 5.62, 10.56, 5.84, 9.90)
      ..lineTo(5.84, 7.06)
      ..lineTo(2.18, 7.06)
      ..cubicTo(1.43, 8.55, 1.0, 10.22, 1.0, 12.0)
      ..cubicTo(1.0, 13.78, 1.43, 15.45, 2.18, 16.94)
      ..lineTo(5.84, 14.10)
      ..close();
    canvas.drawPath(yellowPath, Paint()..color = const Color(0xFFFBBC05));

    // 4. Red top arc
    final redPath = Path()
      ..moveTo(12.0, 4.75)
      ..cubicTo(13.62, 4.75, 15.06, 5.31, 16.21, 6.39)
      ..lineTo(19.36, 3.24)
      ..cubicTo(17.45, 1.46, 14.97, 0.38, 12.0, 0.38)
      ..cubicTo(7.70, 0.38, 3.99, 2.85, 2.18, 6.44)
      ..lineTo(5.84, 9.28)
      ..cubicTo(6.71, 6.68, 9.14, 4.75, 12.0, 4.75)
      ..close();
    canvas.drawPath(redPath, Paint()..color = const Color(0xFFEA4335));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
