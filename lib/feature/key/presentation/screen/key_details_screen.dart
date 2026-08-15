import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:key_tracker/core/providers/database_provider.dart';
import 'package:key_tracker/core/utils/app_colors.dart';
import 'package:key_tracker/core/utils/app_toast.dart';
import 'package:key_tracker/feature/key/presentation/widget/info_row.dart';

class KeyDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> keyItem;

  const KeyDetailsScreen({super.key, required this.keyItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = keyItem['computed_status'] as String;
    final isTakenOrOverdue = status == 'Taken' || status == 'Overdue';
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        title: const Text(
          'Key Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withValues(alpha: 0.5)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.vpn_key_rounded, color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        keyItem['key_name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFF1F5F9)),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KEY INFORMATION',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      InfoRow(
                        icon: Icons.meeting_room_rounded,
                        iconColor: const Color(0xFF3B82F6),
                        label: 'Room',
                        value: keyItem['room_id'] ?? 'Unknown',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: Color(0xFFF1F5F9), height: 1),
                      ),
                      InfoRow(
                        icon: Icons.tag_rounded,
                        iconColor: const Color(0xFF8B5CF6),
                        label: 'Key ID',
                        value: '#${keyItem['id']}',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: Color(0xFFF1F5F9), height: 1),
                      ),
                      InfoRow(
                        icon: Icons.circle_rounded,
                        iconColor: statusColor,
                        label: 'Status',
                        value: status,
                      ),
                    ],
                  ),
                ),

                if (isTakenOrOverdue) ...[
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HANDOVER DETAILS',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InfoRow(
                          icon: Icons.person_rounded,
                          iconColor: const Color(0xFF10B981),
                          label: 'Borrowed By',
                          value: keyItem['person_name'] ?? 'Unknown',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(color: Color(0xFFF1F5F9), height: 1),
                        ),
                        InfoRow(
                          icon: Icons.event_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          label: 'Expected Return',
                          value: keyItem['expected_return_time'] != null
                              ? DateFormat("MMM dd, yyyy 'at' hh:mm a")
                                  .format(DateTime.parse(keyItem['expected_return_time']).toLocal())
                              : 'Unknown',
                        ),
                      ],
                    ),
                  ),
                ],

                if (isTakenOrOverdue) ...[
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await ref.read(keyActionProvider.notifier).returnKey(keyItem['id']);
                          if (context.mounted) {
                            AppToast.show(
                              context,
                              title: 'Returned!',
                              message: 'Key has been returned successfully.',
                              type: ToastType.success,
                            );
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.keyboard_return_rounded, color: Colors.white, size: 20),
                        label: const Text(
                          'Return Key',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return AppColors.statusAvailable;
      case 'Taken':
        return AppColors.statusTaken;
      case 'Overdue':
        return AppColors.statusOverdue;
      default:
        return Colors.grey;
    }
  }
}
