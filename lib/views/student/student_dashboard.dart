import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';
import 'create_ticket_screen.dart';
import 'ticket_detail_screen.dart';
import '../auth_screen.dart';

/// Student Workspace listing all submitted repair reports with live status badges
class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final tickets = appState.studentTickets;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.home_repair_service_rounded,
                color: Color(0xFF818CF8)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mendly Student Portal',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(appState.currentUser?.email ?? '',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Color(0xFF94A3B8)),
            onPressed: () {
              appState.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()));
            },
          )
        ],
      ),
      body: tickets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_outlined,
                      size: 64, color: Colors.white.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  const Text('No issues reported yet',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                      'Spot something broken? Tap the button below to report.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTicketCard(context, ticket);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateTicketScreen()));
        },
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        label: const Text('Report Damage',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, TicketModel ticket) {
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

    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
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
                          color: Color(0xFF818CF8),
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
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text('${ticket.building} • ${ticket.room}',
                      style: const TextStyle(
                          color: Color(0xFF64748B), fontSize: 12)),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF94A3B8)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
