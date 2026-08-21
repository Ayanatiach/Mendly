import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';

/// A fully functional form screen for students to report infrastructure damage.
/// Implements Form validation, loading states, and Mendly's dark-mode aesthetic.
class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen>
    with SingleTickerProviderStateMixin {
  /// Form key for centralized validation
  final _formKey = GlobalKey<FormState>();

  // --- Text Controllers ---
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _buildingController = TextEditingController();
  final _roomController = TextEditingController();

  // --- State ---
  TicketSeverity _selectedSeverity = TicketSeverity.medium;
  bool _isLoading = false;
  bool _photoCaptured = true; // Simulated camera attachment

  late AnimationController _buttonAnimController;
  late Animation<double> _buttonScaleAnim;

  @override
  void initState() {
    super.initState();
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _buildingController.dispose();
    _roomController.dispose();
    _buttonAnimController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Submit Logic
  // ---------------------------------------------------------------------------

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppState>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      appState.addTicket(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        building: _buildingController.text.trim(),
        room: _roomController.text.trim(),
        severity: _selectedSeverity,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF10B981),
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Ticket submitted! Dispatch is on it.',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEF4444),
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E0014),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0D08),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Damage',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Submit an infrastructure issue',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1,
              color: const Color(0xFFF2F0E6).withValues(alpha: 0.1)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              _buildPhotoSection(),
              const SizedBox(height: 24),
              _buildSectionHeader(Icons.info_outline_rounded, 'Issue Details'),
              const SizedBox(height: 14),
              _buildFormField(
                controller: _titleController,
                label: 'Title / Issue Summary',
                hint: 'e.g. Broken Desk Bench',
                prefixIcon: Icons.title_rounded,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                controller: _descriptionController,
                label: 'Detailed Description',
                hint: 'Describe what is broken and potential risks...',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(Icons.location_on_outlined, 'Location Details'),
              const SizedBox(height: 14),
              _buildFormField(
                controller: _buildingController,
                label: 'Building Name',
                hint: 'e.g. Academic Block 4',
                prefixIcon: Icons.apartment_rounded,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Building is required'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                controller: _roomController,
                label: 'Room / Location Details',
                hint: 'e.g. 3rd Floor, Lab 302',
                prefixIcon: Icons.meeting_room_outlined,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Room is required' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(Icons.warning_amber_rounded, 'Severity Level'),
              const SizedBox(height: 14),
              _buildSeverityPicker(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable Widgets
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(IconData icon, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFD90429).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFD90429), size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  /// Core reusable validated form field matching Heritage dark-mode aesthetic:
  /// - Fill: Color(0xFF1A0D08)  (coffee-beans)
  /// - Inactive border: Color(0xFFF2F0E6) at 20% opacity  (alabaster-grey/20)
  /// - Focused border: Color(0xFFD90429)  (racing-red)
  /// - Text color: Color(0xFFF2F0E6)  (alabaster-grey)
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF2F0E6),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Color(0xFFF2F0E6), fontSize: 14),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: const Color(0xFFE7BCBA).withValues(alpha: 0.4),
                fontSize: 13),
            prefixIcon: Icon(prefixIcon,
                color: const Color(0xFFE7BCBA).withValues(alpha: 0.6),
                size: 18),
            filled: true,
            fillColor: const Color(0xFF2E0014).withValues(alpha: 0.5),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: const Color(0xFFF2F0E6).withValues(alpha: 0.2),
                  width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: const Color(0xFFF2F0E6).withValues(alpha: 0.2),
                  width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFD90429), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFFFF4444), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFFFF4444), width: 1.5),
            ),
            errorStyle:
                const TextStyle(color: Color(0xFFFF8080), fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: () {
        setState(() => _photoCaptured = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF1E293B),
            content: const Row(
              children: [
                Icon(Icons.camera_alt_rounded, color: Color(0xFF818CF8)),
                SizedBox(width: 12),
                Text('Photo attached!', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _photoCaptured
                  ? const Color(0xFF10B981).withValues(alpha: 0.5)
                  : const Color(0xFFF2F0E6).withValues(alpha: 0.15),
            ),
          ),
        child: _photoCaptured
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF2E0014),
                        child: const Icon(Icons.broken_image_outlined,
                            color: Color(0xFFE7BCBA), size: 48),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Damage Photo Captured — Tap to Replace',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD90429).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: Color(0xFFD90429), size: 28),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to Capture Photo of Damage',
                    style: TextStyle(
                        color: Color(0xFFE7BCBA),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Helps dispatch prioritize faster',
                    style: TextStyle(color: Color(0xFFE7BCBA), fontSize: 11),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSeverityPicker() {
    const configs = {
      TicketSeverity.low:    (color: Color(0xFF10B981), icon: Icons.info_outline_rounded, label: 'LOW'),
      TicketSeverity.medium: (color: Color(0xFFF59E0B), icon: Icons.warning_amber_rounded, label: 'MEDIUM'),
      TicketSeverity.critical:(color: Color(0xFFEF4444), icon: Icons.dangerous_outlined,   label: 'CRITICAL'),
    };

    return Row(
      children: TicketSeverity.values.map((severity) {
        final cfg = configs[severity]!;
        final isSelected = _selectedSeverity == severity;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedSeverity = severity),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                   color: isSelected
                        ? cfg.color.withValues(alpha: 0.15)
                        : const Color(0xFF1A0D08),
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(
                    color: isSelected
                        ? cfg.color.withValues(alpha: 0.6)
                        : const Color(0xFFF2F0E6).withValues(alpha: 0.15),
                    width: isSelected ? 1.5 : 0.5,
                   ),
                ),
                child: Column(
                  children: [
                    Icon(cfg.icon,
                        color: isSelected ? cfg.color : const Color(0xFF64748B),
                        size: 20),
                    const SizedBox(height: 4),
                    Text(
                      cfg.label,
                      style: TextStyle(
                        color: isSelected ? cfg.color : const Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTapDown: (_) => _buttonAnimController.forward(),
      onTapUp: (_) {
        _buttonAnimController.reverse();
        if (!_isLoading) _submitTicket();
      },
      onTapCancel: () => _buttonAnimController.reverse(),
      child: ScaleTransition(
        scale: _buttonScaleAnim,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD90429), Color(0xFFBF0022)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD90429).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Submit Ticket to Dispatch',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
