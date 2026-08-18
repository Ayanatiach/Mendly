import 'package:flutter/material.dart';

/// Handles scheduling and tracking campus shuttles
class ShuttleScreen extends StatelessWidget {
  const ShuttleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text('Shuttle Transit',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 100), // Bottom padding for dock
        children: [
          _buildShuttleCard(
            context,
            route: 'Campus → IFFCO Chowk, Gurgaon',
            departure: '05:00 PM',
            seatsAvailable: 12,
            isNext: true,
          ),
          _buildShuttleCard(
            context,
            route: 'Campus → Rajiv Chowk',
            departure: '06:30 PM',
            seatsAvailable: 4,
            isNext: false,
          ),
          _buildShuttleCard(
            context,
            route: 'Gurgaon → Campus (Return)',
            departure: '08:30 PM',
            seatsAvailable: 28,
            isNext: false,
          ),
        ],
      ),
    );
  }

  Widget _buildShuttleCard(BuildContext context,
      {required String route,
      required String departure,
      required int seatsAvailable,
      required bool isNext}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isNext ? const Color(0xFF6366F1) : const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isNext
                      ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                      : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isNext ? 'DEPARTING NEXT' : 'SCHEDULED',
                    style: TextStyle(
                        color: isNext
                            ? const Color(0xFF818CF8)
                            : const Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              Text(departure,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(route,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.airline_seat_recline_normal,
                      color: Color(0xFF64748B), size: 16),
                  const SizedBox(width: 6),
                  Text('$seatsAvailable Seats Left',
                      style: TextStyle(
                          color: seatsAvailable < 5
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF94A3B8),
                          fontSize: 13)),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNext
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF334155),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Seat booked for $departure shuttle!')));
                },
                child: Text('Book Seat',
                    style: TextStyle(
                        color: isNext ? Colors.white : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
