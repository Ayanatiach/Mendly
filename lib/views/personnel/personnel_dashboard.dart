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
              icon: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF10B981)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonnelWalletScreen()));
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
        body: tickets.isEmpty
            ? Center(
                child: Text(
                  'No pending tickets in queue! Great job.',
                  style: TextStyle(color: textMuted),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return _buildDispatchCard(context, appState, ticket, cardBg, cardBorder, textPrimary, textMuted, isDark);
                },
              ),
      );
    });
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: racingRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ticket.id, style: const TextStyle(color: racingRed, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                if (ticket.arrivedAt == null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSlaExpired ? const Color(0xFFEF4444).withValues(alpha: 0.2) : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: isSlaExpired ? const Color(0xFFEF4444) : const Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                          isSlaExpired ? 'SLA Expired (No Bonus)' : 'Bonus SLA: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: isSlaExpired ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ticket.isBonusEligible ? const Color(0xFF10B981).withValues(alpha: 0.2) : const Color(0xFF64748B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ticket.isBonusEligible ? '₹20 Bonus Qualified' : 'Arrived (>10 min)',
                      style: TextStyle(
                        color: ticket.isBonusEligible ? const Color(0xFF10B981) : textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Text(ticket.title, style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${ticket.building} • ${ticket.room}', style: TextStyle(color: textMuted, fontSize: 13)),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                if (ticket.arrivedAt == null) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.gps_fixed, size: 16, color: Colors.white),
                      label: const Text('Mark Arrived (GPS)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => appState.markArrival(ticket.id),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                      label: const Text('Complete & Resolve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: racingRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ResolveTicketScreen(ticketId: ticket.id)));
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