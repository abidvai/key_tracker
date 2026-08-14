import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:key_tracker/core/utils/app_colors.dart';
import 'package:key_tracker/feature/handover/presentation/provider/take_key_provider.dart';
import 'package:key_tracker/core/providers/database_provider.dart';

class TakeKeyScreen extends ConsumerStatefulWidget {
  const TakeKeyScreen({super.key});

  @override
  ConsumerState<TakeKeyScreen> createState() => _TakeKeyScreenState();
}

class _TakeKeyScreenState extends ConsumerState<TakeKeyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _personNameController = TextEditingController();

  @override
  void dispose() {
    _personNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedKey = ref.watch(selectedKeyProvider);
    final keysAsync = ref.watch(keysProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            expandedHeight: 160,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Take a Key',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fill in the details below to borrow a key',
                          style: TextStyle(
                            color: Colors.white.withAlpha(204),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionCard(
                      context,
                      children: [
                        _buildFieldLabel(context, 'Select Key', Icons.vpn_key_rounded, const Color(0xFF3B82F6)),
                        const SizedBox(height: 10),
                        keysAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Text('Error loading keys: $e'),
                          data: (keys) {
                            final availableKeys = keys.where((k) => k['status'] == 'Available').toList();
                            return DropdownButtonFormField<int>(
                              value: selectedKey,
                              items: availableKeys.map((keyMap) {
                                return DropdownMenuItem<int>(
                                  value: keyMap['id'] as int, 
                                  child: Text('${keyMap['key_name']} — ${keyMap['room_id']}', style: const TextStyle(fontSize: 14))
                                );
                              }).toList(),
                              onChanged: (value) {
                                ref.read(selectedKeyProvider.notifier).state = value;
                              },
                              decoration: _inputDecoration('Choose an available key', Icons.vpn_key_rounded, const Color(0xFF3B82F6)),
                              validator: (value) => value == null ? 'Please select a key' : null,
                            );
                          }
                        )
                      ],
                    ).animate().fade(duration: 350.ms).slideY(begin: 0.15, end: 0, duration: 350.ms, curve: Curves.easeOutQuad),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      context,
                      children: [
                        _buildFieldLabel(context, "Person's Name", Icons.person_rounded, const Color(0xFF10B981)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _personNameController,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                          decoration: _inputDecoration('Enter employee name or ID', Icons.person_rounded, const Color(0xFF10B981)),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'This field is required';
                            return null;
                          },
                        ),
                      ],
                    ).animate(delay: 50.ms).fade(duration: 350.ms).slideY(begin: 0.15, end: 0, duration: 350.ms, curve: Curves.easeOutQuad),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      context,
                      children: [
                        _buildFieldLabel(context, 'Expected Return Time', Icons.event_rounded, const Color(0xFFF59E0B)),
                        const SizedBox(height: 10),
                        _buildDateTimePicker(context, ref),
                      ],
                    ).animate(delay: 100.ms).fade(duration: 350.ms).slideY(begin: 0.15, end: 0, duration: 350.ms, curve: Curves.easeOutQuad),
                    const SizedBox(height: 28),
                    _buildSubmitButton(context)
                        .animate(delay: 150.ms)
                        .fade(duration: 350.ms)
                        .slideY(begin: 0.15, end: 0, duration: 350.ms, curve: Curves.easeOutQuad),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, Color iconColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: iconColor, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(expectedReturnTimeProvider);
    final String formattedDate = selectedDate != null ? DateFormat("MMM dd, yyyy 'at' hh:mm a").format(selectedDate) : '';

    Future<void> pickDateTime() async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (date != null && context.mounted) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (time != null) {
          ref.read(expectedReturnTimeProvider.notifier).state = DateTime(
            date.year, date.month, date.day, time.hour, time.minute,
          );
        }
      }
    }

    return GestureDetector(
      onTap: pickDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF2563EB), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: selectedDate != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Return scheduled for', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(formattedDate, style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                      ],
                    )
                  : const Text('Select expected return date & time', style: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w400)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            final expectedDate = ref.read(expectedReturnTimeProvider);
            if (expectedDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select expected return time')));
              return;
            }

            final keyId = ref.read(selectedKeyProvider);
            if (keyId == null) {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a key')));
               return;
            }

            await ref.read(keyActionProvider.notifier).takeKey(
              keyId,
              _personNameController.text.trim(),
              expectedDate.toIso8601String(),
            );
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Key taken successfully!')));
              Navigator.pop(context);
              ref.read(selectedKeyProvider.notifier).state = null;
              ref.read(expectedReturnTimeProvider.notifier).state = null;
            }
          }
        },
        icon: const Icon(Icons.vpn_key_rounded, color: Colors.white, size: 20),
        label: const Text('Take Key', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }
}
