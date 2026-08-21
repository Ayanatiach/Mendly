import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

/// Handles scheduling, live active pass, and booking campus shuttles
class ShuttleScreen extends StatefulWidget {
  const ShuttleScreen({super.key});

  @override
  State<ShuttleScreen> createState() => _ShuttleScreenState();
}

class _ShuttleScreenState extends State<ShuttleScreen> {
  String _activeFilter = 'All';

  final List<Map<String, dynamic>> _departures = [
    {
      'time': '11:15',
      'period': 'AM',
      'destination': 'Engineering Hub',
      'demand': 'Medium Demand',
      'demandIcon': Icons.groups_rounded,
      'isHighDemand': false,
      'isAvailable': true,
    },
    {
      'time': '11:45',
      'period': 'AM',
      'destination': 'Library Square',
      'demand': 'High Demand',
      'demandIcon': Icons.local_fire_department_rounded,
      'isHighDemand': true,
      'isAvailable': true,
    },
    {
      'time': '12:30',
      'period': 'PM',
      'destination': 'Sports Complex',
      'demand': 'Plenty of seats',
      'demandIcon': Icons.check_circle_outline_rounded,
      'isHighDemand': false,
      'isAvailable': true,
    },
    {
      'time': '02:00',
      'period': 'PM',
      'destination': 'North Dorms Shuttle',
      'demand': 'Low Demand',
      'demandIcon': Icons.airline_seat_recline_normal_rounded,
      'isHighDemand': false,
      'isAvailable': true,
    },
  ];

  void _bookSeat(String time, String destination) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFD90429),
        content: Row(
          children: [
            const Icon(Icons.confirmation_number_outlined, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Seat booked for $time ($destination)! Boarding pass issued.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Heritage color palette tokens
    final bg = isDark ? const Color(0xFF2E0014) : const Color(0xFFFBF9F2);
    final cardBg = isDark ? const Color(0xFF1A0D08) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
        : const Color(0xFF1A0D08).withValues(alpha: 0.08);
    final textPrimary = isDark ? const Color(0xFFF2F0E6) : const Color(0xFF1A0D08);
    final textMuted = isDark ? const Color(0xFFE7BCBA) : const Color(0xFF703248);
    const racingRed = Color(0xFFD90429);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shuttle Transit',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Active Boarding Pass Section ──────────────────────────
                Text(
                  'Active Boarding Pass',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Boarding Pass Ticket Card with notches
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cardBorder, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Origin -> Destination
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ORIGIN',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                        color: textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Main Campus',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2E0014).withValues(alpha: 0.5)
                                        : const Color(0xFFF2F0E6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: racingRed,
                                    size: 18,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'DESTINATION',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                        color: textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'North Dorms',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Departure Time & Seat Tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        const Text(
                                          '10:45',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: racingRed,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'AM',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Today, Oct 24 • Gate 2',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2E0014).withValues(alpha: 0.6)
                                        : const Color(0xFFF2F0E6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark
                                          ? const Color(0xFFF2F0E6).withValues(alpha: 0.1)
                                          : const Color(0xFF1A0D08).withValues(alpha: 0.08),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'SEAT',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                          color: textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '14B',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Dashed Divider simulation
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: List.generate(
                            25,
                            (index) => Expanded(
                              child: Container(
                                height: 1,
                                color: index % 2 == 0
                                    ? cardBorder
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.qr_code_rounded,
                                    size: 16, color: racingRed),
                                const SizedBox(width: 6),
                                Text(
                                  'Ready to scan at bus entry',
                                  style: TextStyle(fontSize: 12, color: textMuted),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'BOARDING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Upcoming Departures Section ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Departures',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    PopupMenuButton<String>(
                      initialValue: _activeFilter,
                      tooltip: 'Filter departures',
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _activeFilter == 'All' ? 'Filter' : _activeFilter,
                            style: const TextStyle(
                              color: racingRed,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.filter_list_rounded,
                              size: 16, color: racingRed),
                        ],
                      ),
                      color: cardBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: cardBorder),
                      ),
                      onSelected: (val) {
                        setState(() => _activeFilter = val);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'All',
                          child: Text('All Routes',
                              style: TextStyle(color: textPrimary)),
                        ),
                        PopupMenuItem(
                          value: 'High Demand',
                          child: Text('High Demand Only',
                              style: TextStyle(color: textPrimary)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ..._departures
                    .where((dep) =>
                        _activeFilter == 'All' ||
                        (_activeFilter == 'High Demand' &&
                            dep['isHighDemand'] == true))
                    .map((dep) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorder, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        // Time Block
                        Container(
                          width: 58,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2E0014).withValues(alpha: 0.5)
                                : const Color(0xFFF2F0E6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                dep['time'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                dep['period'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Route & Demand Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dep['destination'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    dep['demandIcon'] as IconData,
                                    size: 14,
                                    color: (dep['isHighDemand'] as bool)
                                        ? racingRed
                                        : textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dep['demand'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: (dep['isHighDemand'] as bool)
                                          ? racingRed
                                          : textMuted,
                                      fontWeight: (dep['isHighDemand'] as bool)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Book Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: racingRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 3,
                            shadowColor: racingRed.withValues(alpha: 0.4),
                          ),
                          onPressed: () => _bookSeat(
                            '${dep['time']} ${dep['period']}',
                            dep['destination'] as String,
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
