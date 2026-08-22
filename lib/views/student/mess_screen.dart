import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

/// Handles digital entry to the dining hall, live QR pass, and mess feedback
class MessScreen extends StatefulWidget {
  const MessScreen({super.key});

  @override
  State<MessScreen> createState() => _MessScreenState();
}

class _MessScreenState extends State<MessScreen> {
  String _selectedCategory = 'Food Quality';
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  // ── Mock State Variables ──────────────────────────────────────────────────
  /// True when the student has skipped recent meals (mocked for demo)
  bool hasSkippedRecentMeals = true;

  /// Campus-wide average star rating for today's current meal (mocked)
  double campusAverageRating = 2.1;

  /// Student's personal star rating for the current meal (0 = unrated)
  int _userStarRating = 0;

  /// Whether the Zomato claim has been tapped
  bool _zomatoClaimed = false;

  final List<String> _categories = [
    'Food Quality',
    'Hygiene',
    'Staff Behavior',
    'Menu Suggestion',
    'Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFFD90429),
          content: const Text('Please enter feedback details before submitting.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _feedbackController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF10B981),
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text('Feedback submitted to Mess Warden!'),
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

    // Zomato banner visibility gate
    final showZomatoBanner = hasSkippedRecentMeals && campusAverageRating < 2.5;

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
          'Mess Entry',
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
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header Text ──────────────────────────────────────────
                Text(
                  'Digital Pass',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scan at the dining hall entrance for your meal.',
                  style: TextStyle(fontSize: 13, color: textMuted),
                ),
                const SizedBox(height: 20),

                // ── Zomato Affiliate Banner (Conditional) ─────────────────
                if (showZomatoBanner) ...[
                  _buildZomatoBanner(
                    isDark: isDark,
                    textPrimary: textPrimary,
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Hero QR Pass Card (Bento-Grid style) ──────────────────
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: cardBorder, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Dinner Pass',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF703248).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: racingRed.withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: racingRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Active Now',
                              style: TextStyle(
                                color: Color(0xFFEF9EB7),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // QR Box
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              size: 160,
                              color: Color(0xFF1A0D08),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'MENDLY MESS PASS (STUDENT)',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'ID: 104-MND-${appState.currentUser?.id.substring(0, 4) ?? '892'}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Auto-refreshes in 04:59',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFB1C8),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Today's Menu Section ──────────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.restaurant_menu_rounded,
                        color: racingRed, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Today's Menu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMenuCard(
                  meal: 'Breakfast',
                  items: 'Aloo Paratha, Curd, Tea & Fresh Fruit',
                  time: '07:30 AM - 09:30 AM',
                  isActive: false,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                _buildMenuCard(
                  meal: 'Lunch',
                  items: 'Rajma Chawal, Seasonal Sabzi, Roti, Salad',
                  time: '12:30 PM - 02:30 PM',
                  isActive: false,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                _buildMenuCard(
                  meal: 'Dinner',
                  items: 'Paneer Butter Masala, Garlic Naan, Jeera Rice, Gulab Jamun',
                  time: '07:30 PM - 09:30 PM',
                  isActive: true,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 28),

                // ── Rate Today's Meal ─────────────────────────────────────
                _buildStarRatingCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 28),

                // ── Feedback & Complaints Form ────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.campaign_outlined,
                        color: racingRed, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Mess Feedback & Complaints',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cardBorder, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2E0014).withValues(alpha: 0.5)
                              : const Color(0xFFF2F0E6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
                                : const Color(0xFF1A0D08).withValues(alpha: 0.1),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            dropdownColor: cardBg,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: racingRed),
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            items: _categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCategory = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _feedbackController,
                        maxLines: 3,
                        style: TextStyle(color: textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Describe the issue or suggestion...',
                          hintStyle: TextStyle(
                            color: textMuted.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF2E0014).withValues(alpha: 0.5)
                              : const Color(0xFFF2F0E6),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
                                  : const Color(0xFF1A0D08).withValues(alpha: 0.1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? const Color(0xFFF2F0E6).withValues(alpha: 0.15)
                                  : const Color(0xFF1A0D08).withValues(alpha: 0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: racingRed, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: racingRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: racingRed.withValues(alpha: 0.4),
                          ),
                          onPressed: _isSubmitting ? null : _submitFeedback,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send_rounded, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'Submit Feedback',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Zomato 10% Off Affiliate Banner ────────────────────────────────────────
  Widget _buildZomatoBanner({required bool isDark, required Color textPrimary}) {
    const racingRed = Color(0xFFD90429);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _zomatoClaimed
          ? Container(
              key: const ValueKey('claimed'),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Color(0xFF10B981), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Zomato 10% Off code sent to your email!',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              key: const ValueKey('banner'),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A0505), Color(0xFF3D0012)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: racingRed.withValues(alpha: 0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: racingRed.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background watermark "Z"
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Text(
                      'Z',
                      style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.w900,
                        color: racingRed.withValues(alpha: 0.08),
                        height: 1.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: racingRed,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ZOMATO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: const Color(0xFFFFD700)
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Text(
                                '🔓 UNLOCKED',
                                style: TextStyle(
                                  color: Color(0xFFFFD700),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Headline
                        const Text(
                          '10% Off Your Next Order',
                          style: TextStyle(
                            color: Color(0xFFF2F0E6),
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Reason explanation
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: Color(0xFFEF9EB7), size: 15),
                            const SizedBox(width: 6),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Color(0xFFE7BCBA),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text:
                                            "You've skipped the mess recently, and campus agrees — today's dinner is rated "),
                                    TextSpan(
                                      text:
                                          '★ ${campusAverageRating.toStringAsFixed(1)}/5.0',
                                      style: const TextStyle(
                                        color: Color(0xFFFF6B6B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                        text:
                                            ' by your peers. We\'ve got you covered.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // CTA Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: racingRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                              shadowColor: racingRed.withValues(alpha: 0.5),
                            ),
                            onPressed: () => setState(() => _zomatoClaimed = true),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.local_offer_rounded, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Claim 10% Off  →',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ── 5-Star Rating Card ──────────────────────────────────────────────────────
  Widget _buildStarRatingCard({
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    const racingRed = Color(0xFFD90429);
    const starColor = Color(0xFFFFD700);

    final ratingLabels = ['', 'Terrible', 'Poor', 'Average', 'Good', 'Excellent'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rate_rounded, color: starColor, size: 20),
              const SizedBox(width: 8),
              Text(
                "Rate Today's Dinner",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              // Campus average pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: racingRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline_rounded,
                        size: 12, color: racingRed),
                    const SizedBox(width: 4),
                    Text(
                      'Campus avg: ★${campusAverageRating.toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: racingRed,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Your rating helps adjust campus vendor pricing and benefits.',
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
          const SizedBox(height: 18),

          // Stars row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              return GestureDetector(
                onTap: () => setState(() => _userStarRating = starIndex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Icon(
                    _userStarRating >= starIndex
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: _userStarRating == starIndex ? 46 : 38,
                    color: _userStarRating >= starIndex
                        ? starColor
                        : textMuted.withValues(alpha: 0.4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Label below stars
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _userStarRating == 0
                  ? Text(
                      'Tap a star to rate',
                      key: const ValueKey('unrated'),
                      style: TextStyle(
                        color: textMuted.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Container(
                      key: ValueKey(_userStarRating),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _userStarRating <= 2
                            ? racingRed.withValues(alpha: 0.12)
                            : const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${ratingLabels[_userStarRating]} — Your vote counts!',
                        style: TextStyle(
                          color: _userStarRating <= 2
                              ? racingRed
                              : const Color(0xFF10B981),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String meal,
    required String items,
    required String time,
    required bool isActive,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    const racingRed = Color(0xFFD90429);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? racingRed : cardBorder,
          width: isActive ? 1.5 : 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? racingRed.withValues(alpha: 0.15)
                  : cardBorder.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant,
              size: 16,
              color: isActive ? racingRed : textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal,
                      style: TextStyle(
                        color: isActive ? racingRed : textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: racingRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NOW SERVING',
                          style: TextStyle(
                            color: racingRed,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Text(
                        time,
                        style: TextStyle(color: textMuted, fontSize: 11),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  items,
                  style: TextStyle(color: textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
