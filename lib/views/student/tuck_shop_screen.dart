import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';

/// Campus Tuck Shop: Micro-commerce with demand forecasting polls and JIT pre-orders
class TuckShopScreen extends StatefulWidget {
  const TuckShopScreen({super.key});

  @override
  State<TuckShopScreen> createState() => _TuckShopScreenState();
}

class _TuckShopScreenState extends State<TuckShopScreen>
    with SingleTickerProviderStateMixin {
  // ── Mock State Variables ──────────────────────────────────────────────────

  /// Poll vote counts — Red Bull vs Monster
  int _redBullVotes = 70;
  int _monsterVotes = 30;

  /// Which option the current user voted for (null = not voted)
  String? _userVote;

  /// Whether the pre-order reservation is being processed
  bool _isReserving = false;

  /// Whether the notebook pre-order was successfully reserved
  bool _notebookReserved = false;

  /// Stock level for notebooks (mocked: low stock scenario)
  final int _notebookStock = 4;

  late AnimationController _barAnimController;
  late Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    _barAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _barAnimation = CurvedAnimation(
      parent: _barAnimController,
      curve: Curves.easeOutCubic,
    );
    // Kick off the progress bar animation on load
    _barAnimController.forward();
  }

  @override
  void dispose() {
    _barAnimController.dispose();
    super.dispose();
  }

  int get _totalVotes => _redBullVotes + _monsterVotes;
  double get _redBullFraction => _redBullVotes / _totalVotes;
  double get _monsterFraction => _monsterVotes / _totalVotes;

  void _castVote(String option) {
    if (_userVote != null) return;
    setState(() {
      _userVote = option;
      if (option == 'redbull') {
        _redBullVotes += 1;
      } else {
        _monsterVotes += 1;
      }
    });
    // Re-animate bars to reflect new vote
    _barAnimController.reset();
    _barAnimController.forward();
  }

  void _reserveNotebook() async {
    if (_notebookReserved) return;
    setState(() => _isReserving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isReserving = false;
      _notebookReserved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
        content: const Row(
          children: [
            Icon(Icons.inventory_2_outlined, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '1× Classmate Notebook reserved! Pick up at Tuck Shop counter by 8 PM.',
                style: TextStyle(fontWeight: FontWeight.bold),
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

    // Heritage color palette
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
          'Tuck Shop',
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
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Page Header ───────────────────────────────────────────
                Text(
                  'Campus Store',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vote on what we restock. Reserve before it sells out.',
                  style: TextStyle(fontSize: 13, color: textMuted),
                ),
                const SizedBox(height: 24),

                // ── Vendor Poll Card ──────────────────────────────────────
                _buildDemandPollCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 20),

                // ── Section header ────────────────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        color: racingRed, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Inventory Pre-Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Reserve items to avoid wasted trips and dead stock.',
                  style: TextStyle(fontSize: 12, color: textMuted),
                ),
                const SizedBox(height: 12),

                // ── Notebook Pre-Order Card ───────────────────────────────
                _buildNotebookPreOrderCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
                const SizedBox(height: 12),

                // ── Stationery placeholder card ───────────────────────────
                _buildComingSoonCard(
                  icon: Icons.local_drink_outlined,
                  label: 'Beverages & Snacks',
                  sublabel: 'Pre-orders opening after next poll closes',
                  isDark: isDark,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Demand Forecasting Poll Card ────────────────────────────────────────────
  Widget _buildDemandPollCard({
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    const racingRed = Color(0xFFD90429);
    const redBullColor = Color(0xFF1565C0);
    const monsterColor = Color(0xFF33691E);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
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
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: racingRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.poll_outlined,
                      color: racingRed, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendor Poll · Demand Forecasting',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'Restocking Midnight Snacks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_totalVotes votes',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Combined split progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedBuilder(
                animation: _barAnimation,
                builder: (context, child) {
                  return SizedBox(
                    height: 14,
                    child: Row(
                      children: [
                        Expanded(
                          flex: (_redBullFraction * 100 * _barAnimation.value)
                              .round(),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: (_monsterFraction * 100 * _barAnimation.value)
                              .round(),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF558B2F),
                                  Color(0xFF9CCC65)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Options with vote buttons
            Row(
              children: [
                Expanded(
                  child: _buildPollOption(
                    label: '🐂 Red Bull',
                    percentage:
                        (_redBullFraction * 100).toStringAsFixed(0),
                    color: redBullColor,
                    isUserChoice: _userVote == 'redbull',
                    hasVoted: _userVote != null,
                    onTap: () => _castVote('redbull'),
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPollOption(
                    label: '🟢 Monster',
                    percentage:
                        (_monsterFraction * 100).toStringAsFixed(0),
                    color: monsterColor,
                    isUserChoice: _userVote == 'monster',
                    hasVoted: _userVote != null,
                    onTap: () => _castVote('monster'),
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            if (_userVote != null) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: racingRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: racingRed.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_graph_rounded,
                        color: racingRed, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your vote is feeding the vendor\'s JIT order system. Results update weekly.',
                        style: TextStyle(
                            color: textMuted, fontSize: 11, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPollOption({
    required String label,
    required String percentage,
    required Color color,
    required bool isUserChoice,
    required bool hasVoted,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textMuted,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: hasVoted ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isUserChoice
              ? color.withValues(alpha: 0.15)
              : isDark
                  ? const Color(0xFF2E0014).withValues(alpha: 0.4)
                  : const Color(0xFFF2F0E6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUserChoice
                ? color.withValues(alpha: 0.6)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isUserChoice ? color : textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isUserChoice ? color : textMuted,
                  ),
                ),
                if (isUserChoice) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.how_to_vote_rounded,
                      size: 14, color: color),
                ],
              ],
            ),
            if (!hasVoted)
              Text(
                'Tap to vote',
                style: TextStyle(
                  fontSize: 11,
                  color: textMuted.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Notebook Pre-Order Card ─────────────────────────────────────────────────
  Widget _buildNotebookPreOrderCard({
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    const racingRed = Color(0xFFD90429);
    final isLowStock = _notebookStock <= 5;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _notebookReserved
              ? const Color(0xFF10B981).withValues(alpha: 0.5)
              : cardBorder,
          width: _notebookReserved ? 1.5 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2E0014).withValues(alpha: 0.6)
                        : const Color(0xFFF2F0E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 32,
                    color: Color(0xFFD90429),
                  ),
                ),
                const SizedBox(width: 14),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Classmate Notebooks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A4 · 172 Pages · Single Line',
                        style: TextStyle(
                          fontSize: 12,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹45',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Stock badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isLowStock
                                  ? const Color(0xFFF59E0B).withValues(alpha: 0.15)
                                  : const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isLowStock
                                    ? const Color(0xFFF59E0B).withValues(alpha: 0.4)
                                    : const Color(0xFF10B981).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isLowStock
                                      ? Icons.warning_amber_rounded
                                      : Icons.check_circle_outline_rounded,
                                  size: 11,
                                  color: isLowStock
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF10B981),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isLowStock
                                      ? 'Only $_notebookStock left'
                                      : 'In Stock',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFF10B981),
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
              ],
            ),
            const SizedBox(height: 16),

            // Low stock urgency banner
            if (isLowStock && !_notebookReserved)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        color: Color(0xFFF59E0B), size: 15),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Reserve now to avoid a wasted trip — limited units remain today.',
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // CTA Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _notebookReserved
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF10B981)
                                .withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Color(0xFF10B981), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Reserved — Pick up by 8 PM',
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: racingRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: racingRed.withValues(alpha: 0.4),
                      ),
                      onPressed:
                          _isReserving ? null : _reserveNotebook,
                      child: _isReserving
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
                                Icon(Icons.inventory_2_outlined,
                                    size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Check Availability / Reserve',
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
    );
  }

  // ── Coming Soon Placeholder Card ────────────────────────────────────────────
  Widget _buildComingSoonCard({
    required IconData icon,
    required String label,
    required String sublabel,
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardBorder.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2E0014).withValues(alpha: 0.5)
                  : const Color(0xFFF2F0E6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: textMuted, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: textMuted.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: textMuted.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Soon',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
