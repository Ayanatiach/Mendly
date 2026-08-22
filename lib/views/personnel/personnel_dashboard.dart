import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';
import '../../stitch_ui/login_dark_mode/login_screen.dart';
import 'resolve_ticket_screen.dart';
import 'personnel_wallet_screen.dart';

/// Maintenance Personnel Hub showing live tickets with active 10-minute timers.
class PersonnelDashboard extends StatefulWidget {
  const PersonnelDashboard({super.key});

  @override
  State<PersonnelDashboard> createState() => _PersonnelDashboardState();
}

class _PersonnelDashboardState extends State<PersonnelDashboard> {
  late final Timer _clockTimer;

  // ── WashEx Mock State Variables ───────────────────────────────────────────
  /// Predictive failure risk percentage for WashEx Block A (0–100)
  final double _washexFailureRisk = 0.85;

  /// Whether maintenance has been scheduled
  bool _maintenanceScheduled = false;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, _) {
      final tickets = appState.openPersonnelTickets;
      final isDark = Theme.of(context).brightness == Brightness.dark;

      final bg = isDark ? const Color(0xFF2E0014) : const Color(0xFFFBF9F2);
      final cardBg = isDark ? const Color(0xFF1A0D08) : Colors.white;
      final cardBorder = isDark
          ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
          : const Color(0xFF1A0D08).withValues(alpha: 0.08);
      final textPrimary = isDark ? const Color(0xFFF2F0E6) : const Color(0xFF1A0D08);
      final textMuted = isDark ? const Color(0xFFE7BCBA) : const Color(0xFF703248);

      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: cardBg.withValues(alpha: 0.8),
          elevation: 0,
          title: Text(
            'Urgent Dispatch Queue',
            style: TextStyle(
              color: textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Earnings & Bonus Wallet',
              icon: const Icon(Icons.account_balance_wallet_outlined,
                  color: Color(0xFF10B981)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PersonnelWalletScreen()),
                );
              },
            ),
            IconButton(
              tooltip: 'Toggle Theme',
              icon: Icon(
                appState.currentTheme == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: textMuted,
              ),
              onPressed: () => appState.toggleTheme(),
            ),
            IconButton(
              tooltip: 'Logout',
              icon: Icon(Icons.logout, color: textMuted),
              onPressed: () {
                appState.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Dispatch Ticket Queue ───────────────────────────────────
              if (tickets.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No pending tickets in queue! Great job.',
                      style: TextStyle(color: textMuted),
                    ),
                  ),
                )
              else
                ...tickets.map((ticket) => _buildDispatchCard(
                      context,
                      appState,
                      ticket,
                      cardBg,
                      cardBorder,
                      textPrimary,
                      textMuted,
                      isDark,
                    )),

              const SizedBox(height: 8),

              // ── Predictive Analytics & Vendor Health Section ────────────
              _buildAnalyticsSectionHeader(textPrimary, textMuted),
              const SizedBox(height: 12),
              _buildWashExCard(
                isDark: isDark,
                cardBg: cardBg,
                cardBorder: cardBorder,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Section Header ──────────────────────────────────────────────────────────
  Widget _buildAnalyticsSectionHeader(Color textPrimary, Color textMuted) {
    const racingRed = Color(0xFFD90429);
    return Row(
      children: [
        const Icon(Icons.analytics_outlined, color: racingRed, size: 18),
        const SizedBox(width: 8),
        Text(
          'Predictive Analytics & Vendor Health',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  // ── WashEx Predictive SaaS Card ─────────────────────────────────────────────
  Widget _buildWashExCard({
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    const racingRed = Color(0xFFD90429);
    const amber = Color(0xFFF59E0B);

    // Risk color interpolation: amber at 60%, red at 85%+
    final riskPercent = (_washexFailureRisk * 100).round();
    final barColor = riskPercent >= 80 ? racingRed : amber;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: barColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: barColor.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: barColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.local_laundry_service_rounded,
                      color: barColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WashEx — Block A',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Industrial Washer · Unit ID: WX-A-04',
                        style: TextStyle(fontSize: 12, color: textMuted),
                      ),
                    ],
                  ),
                ),
                // SaaS "CRITICAL" badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: racingRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: racingRed.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'CRITICAL',
                    style: TextStyle(
                      color: racingRed,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Risk percentage + label row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Predictive Failure Risk',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$riskPercent%',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: barColor,
                            letterSpacing: -1,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'risk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Trend indicator
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_up_rounded,
                            color: racingRed, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '+12% this week',
                          style: TextStyle(
                            color: racingRed,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Last serviced: 3 months ago',
                      style: TextStyle(fontSize: 11, color: Color(0xFFE7BCBA)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // Background track
                  Container(
                    height: 10,
                    color: isDark
                        ? const Color(0xFF2E0014).withValues(alpha: 0.6)
                        : const Color(0xFFF2F0E6),
                  ),
                  // Filled portion
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _washexFailureRisk),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          height: 10,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [amber, racingRed],
                              stops: [0.0, 1.0],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Warning recommendation block
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: racingRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: racingRed.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: amber, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 13,
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(
                              text: 'Preventative maintenance recommended '),
                          TextSpan(
                            text: 'before this weekend',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF2F0E6),
                            ),
                          ),
                          TextSpan(
                              text:
                                  ' to avoid critical service downtime. Students in Block A rely on this unit daily.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CTA button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: _maintenanceScheduled
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF10B981)
                                .withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_available_rounded,
                              color: Color(0xFF10B981), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Maintenance Scheduled — Saturday 9 AM',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: barColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: barColor.withValues(alpha: 0.45),
                      ),
                      icon: const Icon(Icons.build_circle_outlined, size: 17),
                      label: const Text(
                        'Schedule Maintenance  →',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () =>
                          setState(() => _maintenanceScheduled = true),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDispatchCard(
    BuildContext context,
    AppState appState,
    TicketModel ticket,
    Color cardBg,
    Color cardBorder,
    Color textPrimary,
    Color textMuted,
    bool isDark,
  ) {
    final remainingSecs = ticket.remainingSecondsForSla;
    final minutes = remainingSecs ~/ 60;
    final seconds = remainingSecs % 60;

    final isTimerActive = ticket.arrivedAt == null && remainingSecs > 0;
    final isSlaExpired = ticket.arrivedAt == null && remainingSecs <= 0;
    const racingRed = Color(0xFFD90429);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isTimerActive ? const Color(0xFFF59E0B) : cardBorder,
          width: isTimerActive ? 1.5 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Countdown Timer Banner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: racingRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ticket.id,
                      style: const TextStyle(
                          color: racingRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                if (ticket.arrivedAt == null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSlaExpired
                          ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                          : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 14,
                            color: isSlaExpired
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                          isSlaExpired
                              ? 'SLA Expired (No Bonus)'
                              : 'Bonus SLA: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: isSlaExpired
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ticket.isBonusEligible
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : const Color(0xFF64748B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ticket.isBonusEligible
                          ? '₹20 Bonus Qualified'
                          : 'Arrived (>10 min)',
                      style: TextStyle(
                        color: ticket.isBonusEligible
                            ? const Color(0xFF10B981)
                            : textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Text(ticket.title,
                style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${ticket.building} • ${ticket.room}',
                style: TextStyle(color: textMuted, fontSize: 13)),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                if (ticket.arrivedAt == null) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.gps_fixed,
                          size: 16, color: Colors.white),
                      label: const Text('Mark Arrived (GPS)',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => appState.markArrival(ticket.id),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline,
                          size: 16, color: Colors.white),
                      label: const Text('Complete & Resolve',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: racingRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ResolveTicketScreen(ticketId: ticket.id),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}