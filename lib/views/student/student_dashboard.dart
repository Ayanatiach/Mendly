import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';
import '../../stitch_ui/login_dark_mode/login_screen.dart';

/// Student Workspace listing all submitted repair reports with live status badges
class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final tickets = appState.studentTickets;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF2E0014) : const Color(0xFFFBF9F2);
    final cardBg = isDark ? const Color(0xFF1A0D08) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
        : const Color(0xFF1A0D08).withValues(alpha: 0.08);
    final textPrimary =
        isDark ? const Color(0xFFF2F0E6) : const Color(0xFF1A0D08);
    final textMuted =
        isDark ? const Color(0xFFE7BCBA) : const Color(0xFF703248);
    final appBarBg = isDark ? const Color(0xFF1A0D08) : const Color(0xFFF2F0E6);
    const racingRed = Color(0xFFD90429);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textPrimary, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.home_repair_service_rounded, color: racingRed),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mendly Student Portal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    appState.currentUser?.email ?? '',
                    style: TextStyle(fontSize: 11, color: textMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: tickets.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_turned_in_outlined,
                        size: 64, color: racingRed.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text('No issues reported yet',
                        style: TextStyle(
                            color: textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                        'Spot something broken? Tap the button below to report.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textMuted, fontSize: 13)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketCard(
                  context,
                  ticket,
                  cardBg,
                  cardBorder,
                  textPrimary,
                  textMuted,
                  isDark,
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateTicketScreen()));
        },
        backgroundColor: racingRed,
        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        label: const Text('Report Damage',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    TicketModel ticket,
    Color cardBg,
    Color cardBorder,
    Color textPrimary,
    Color textMuted,
    bool isDark,
  ) {
    Color statusColor;
    String statusText;

    switch (ticket.status) {
      case TicketStatus.reported:
        statusColor = const Color(0xFFF59E0B);
        statusText = 'Dispatched (Awaiting Arrival)';
        break;
      case TicketStatus.inProgress:
        statusColor = const Color(0xFF3B82F6);
        statusText = 'In Progress (Personnel On-Site)';
        break;
      case TicketStatus.resolved:
        statusColor = const Color(0xFF10B981);
        statusText = 'Resolved';
        break;
      case TicketStatus.reopened:
        statusColor = const Color(0xFFEF4444);
        statusText = 'Reopened';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TicketDetailScreen(ticketId: ticket.id)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ticket.id,
                      style: const TextStyle(
                          color: Color(0xFFD90429),
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(statusText,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(ticket.title,
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textMuted, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: textMuted),
                  const SizedBox(width: 4),
                  Text('${ticket.building} • ${ticket.room}',
                      style: TextStyle(
                          color: textMuted.withValues(alpha: 0.8),
                          fontSize: 12)),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded,
                      color: textMuted.withValues(alpha: 0.6)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
