import 'package:flutter/material.dart';

/// Handles digital entry to the dining hall and today's menu
class MessScreen extends StatelessWidget {
  const MessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text('Digital Mess Pass',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 100), // Bottom padding prevents dock overlap
        child: Column(
          children: [
            // Virtual ID Card & Entry QR
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('TAP TO SCAN AT ENTRY',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.qr_code_2,
                        size: 120, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  const Text('Active Meal: Dinner',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Today's Menu Placeholder
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Today's Menu",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            _buildMenuCard('Breakfast', 'Aloo Paratha, Curd, Tea',
                '07:30 AM - 09:30 AM', false),
            _buildMenuCard('Lunch', 'Rajma Chawal, Roti, Salad',
                '12:30 PM - 02:30 PM', false),
            _buildMenuCard('Dinner', 'Paneer Butter Masala, Naan',
                '07:30 PM - 09:30 PM', true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String meal, String items, String time, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color:
                isActive ? const Color(0xFF10B981) : const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal,
                  style: TextStyle(
                      color: isActive ? const Color(0xFF10B981) : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 4),
              Text(items,
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            ],
          ),
          Text(time,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
        ],
      ),
    );
  }
}
