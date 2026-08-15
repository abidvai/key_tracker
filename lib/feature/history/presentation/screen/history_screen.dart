import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_tracker/core/utils/app_colors.dart';
import 'package:key_tracker/core/providers/database_provider.dart';
import 'package:key_tracker/feature/history/presentation/widget/history_card.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            toolbarHeight: 80,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  'History',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                ),
                Text(
                  'All handover records',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          historyAsync.when(
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, st) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
            data: (historyList) {
              if (historyList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No handover history found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = historyList[index];
                      String computedStatus = item['status'];
                      
                      if (computedStatus == 'Taken' && item['expected_return_time'] != null) {
                        final expected = DateTime.parse(item['expected_return_time']);
                        if (DateTime.now().isAfter(expected)) {
                          computedStatus = 'Overdue';
                        }
                      }

                      final takenDate = DateTime.parse(item['handover_time']).toLocal();
                      final takenStr = DateFormat("MMM dd, yyyy 'at' hh:mm a").format(takenDate);
                      
                      String returnedStr = 'Pending';
                      if (item['returned_time'] != null) {
                        final returnedDate = DateTime.parse(item['returned_time']).toLocal();
                        returnedStr = DateFormat("MMM dd, yyyy 'at' hh:mm a").format(returnedDate);
                      }

                      return HistoryCard(
                        keyName: item['key_name'],
                        roomId: item['room_id'],
                        personName: item['person_name'],
                        takenTime: takenStr,
                        returnedTime: returnedStr,
                        status: computedStatus,
                      );
                    },
                    childCount: historyList.length,
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

}
