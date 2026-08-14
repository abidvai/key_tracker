import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_tracker/core/providers/database_provider.dart';
import 'package:key_tracker/core/utils/app_colors.dart';

class KeyDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> keyItem;

  const KeyDetailsScreen({super.key, required this.keyItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = keyItem['computed_status'] as String;
    final isTakenOrOverdue = status == 'Taken' || status == 'Overdue';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Details'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Key Name', keyItem['key_name']),
            _buildDetailRow('Room ID', keyItem['room_id']),
            _buildDetailRow('Status', status),
            if (isTakenOrOverdue) ...[
              _buildDetailRow('Person', keyItem['person_name'] ?? 'Unknown'),
              _buildDetailRow('Expected Return', keyItem['expected_return_time'] != null 
                  ? DateTime.parse(keyItem['expected_return_time']).toLocal().toString()
                  : 'Unknown'),
            ],
            const Spacer(),
            if (isTakenOrOverdue)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(keyActionProvider.notifier).returnKey(keyItem['id']);
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                  child: const Text('Return Key', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
