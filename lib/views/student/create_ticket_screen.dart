import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/ticket_model.dart';

/// Form screen for students to capture photos and submit damage tickets
class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _buildingController = TextEditingController();
  final _roomController = TextEditingController();
  TicketSeverity _selectedSeverity = TicketSeverity.medium;
  bool _photoCaptured = true; // Simulated camera attachment

  void _submit() {
    if (_titleController.text.isEmpty || _buildingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and building location.')),
      );
      return;
    }

    Provider.of<AppState>(context, listen: false).createTicket(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      building: _buildingController.text.trim(),
      room: _roomController.text.trim(),
      severity: _selectedSeverity,
      imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Report Damage', style: TextStyle(color: Colors.white, fontSize: 17)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simulated Camera Photo Upload Container
            GestureDetector(
              onTap: () {
                setState(() => _photoCaptured = true);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo attached!')));
              },
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155), style: BorderStyle.solid),
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
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ),
                          const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Color(0xFF10B981)),
                                SizedBox(width: 8),
                                Text('Damage Photo Captured', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: Color(0xFF818CF8), size: 36),
                          SizedBox(height: 8),
                          Text('Tap to capture photo of damage', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInputField('Title / Issue Summary', _titleController, 'e.g. Broken Desk Bench'),
            const SizedBox(height: 16),
            _buildInputField('Building Name', _buildingController, 'e.g. Academic Block 4'),
            const SizedBox(height: 16),
            _buildInputField('Room / Location Details', _roomController, 'e.g. 3rd Floor, Lab 302'),
            const SizedBox(height: 16),
            _buildInputField('Detailed Description', _descController, 'Describe what is broken and potential risks...', maxLines: 3),
            const SizedBox(height: 20),

            const Text('Severity Level', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: TicketSeverity.values.map((severity) {
                final isSelected = _selectedSeverity == severity;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(severity.name.toUpperCase()),
                      selected: isSelected,
                      selectedColor: severity == TicketSeverity.critical ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold),
                      onSelected: (_) => setState(() => _selectedSeverity = severity),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit Ticket to Dispatch', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
          ),
        ),
      ],
    );
  }
}