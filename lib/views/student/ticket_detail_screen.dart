import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';

/// Detailed view of a ticket allowing students to inspect progress and re-open issues
class TicketDetailScreen extends StatelessWidget {
  final String ticketId;
  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final ticket = appState.tickets.firstWhere((t) => t.id == ticketId);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(ticket.id, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Damage Image Display
            if (ticket.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(ticket.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),

            Text(ticket.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(ticket.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
            const SizedBox(height: 20),

            // Location Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_city, color: Color(0xFF818CF8)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticket.building, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(ticket.room, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Re-open Ticket Button (Student Dispute Flow)
            if (ticket.status == TicketStatus.resolved) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Not satisfied with the fix?', style: TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('If the problem persists or was improperly handled, you can re-open it. This voids the rapid response bonus.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                      onPressed: () {
                        appState.reopenTicket(ticket.id);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket re-opened. Personnel bonus revoked.')));
                      },
                      child: const Text('Re-open Ticket', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}