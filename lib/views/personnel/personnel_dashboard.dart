import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';
import 'resolve_ticket_screen.dart';
import 'personnel_wallet_screen.dart';
import '../auth_screen.dart';

/// Maintenance Personnel Hub showing live tickets with active 10-minute timers
class PersonnelDashboard extends StatelessWidget {
  const PersonnelDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final tickets = appState.openPersonnelTickets;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Urgent Dispatch Queue', style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          // Wallet and Bonus Navigation Button
          IconButton(
            tooltip: 'Earnings & Bonus Wallet',
            icon: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF10B981)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonnelWalletScreen()));
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Color(0xFF94A3B8)),
            onPressed: () {
              appState.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
            },
          )
        ],
      ),
      body: tickets.isEmpty
          ? const Center(child: Text('No pending tickets in queue! Great job.', style: TextStyle(color: Color(0xFF94A3B8))))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildDispatchCard(context, appState, ticket);
              },
            ),
    );
  }

  Widget _buildDispatchCard(BuildContext context, AppState appState, TicketModel ticket) {
    final remainingSecs = ticket.remainingSecondsForSla;
    final minutes = remainingSecs ~/ 60;
    final seconds = remainingSecs % 60;

    final isTimerActive = ticket.arrivedAt == null && remainingSecs > 0;
    final isSlaExpired = ticket.arrivedAt == null && remainingSecs <= 0;

    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isTimerActive ? const Color(0xFFF59E0B) : const Color(0xFF334155),
          width: isTimerActive ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(ticket.id, style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.bold, fontSize: 12)),
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
                        color: ticket.isBonusEligible ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Text(ticket.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${ticket.building} • ${ticket.room}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                if (ticket.arrivedAt == null) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.gps_fixed, size: 16, color: Colors.white),
                      label: const Text('Mark Arrived (GPS)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                      onPressed: () => appState.markArrival(ticket.id),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                      label: const Text('Complete & Resolve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
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