import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:key_tracker/core/utils/app_colors.dart';
import 'package:key_tracker/feature/key/presentation/widget/key_info_card.dart';
import 'package:key_tracker/feature/key/presentation/widget/status_count_card.dart';
import 'package:key_tracker/core/providers/database_provider.dart';
import 'package:key_tracker/feature/key/presentation/screen/key_details_screen.dart';

class KeysScreen extends ConsumerStatefulWidget {
  const KeysScreen({super.key});

  @override
  ConsumerState<KeysScreen> createState() => _KeysScreenState();
}

class _KeysScreenState extends ConsumerState<KeysScreen> {
  String _searchQuery = '';

  String _getComputedStatus(Map<String, dynamic> keyItem) {
    final status = keyItem['status'] as String;
    if (status == 'Taken' && keyItem['expected_return_time'] != null) {
      final expectedTime = DateTime.tryParse(keyItem['expected_return_time']);
      if (expectedTime != null && DateTime.now().isAfter(expectedTime)) {
        return 'Overdue';
      }
    }
    return status;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available': return AppColors.statusAvailable;
      case 'Taken': return AppColors.statusTaken;
      case 'Overdue': return AppColors.statusOverdue;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keysAsync = ref.watch(keysProvider);

    return Scaffold(
      body: SafeArea(
        child: keysAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (keys) {
            final processedKeys = keys.map((k) {
              final computedStatus = _getComputedStatus(k);
              return {...k, 'computed_status': computedStatus};
            }).toList();

            final filteredKeys = processedKeys.where((k) {
              final nameMatch = k['key_name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
              final roomMatch = k['room_id'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
              final personMatch = (k['person_name']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
              return nameMatch || roomMatch || personMatch;
            }).toList();

            int availableCount = processedKeys.where((k) => k['computed_status'] == 'Available').length;
            int takenCount = processedKeys.where((k) => k['computed_status'] == 'Taken').length;
            int overdueCount = processedKeys.where((k) => k['computed_status'] == 'Overdue').length;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  toolbarHeight: 90,
                  titleSpacing: 16.0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Office Keys',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Key Handover',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 24.0),
                    child: Row(
                      children: [
                        Expanded(child: StatusCountCard(title: 'Available', count: '$availableCount', color: AppColors.statusAvailable)),
                        const SizedBox(width: 12),
                        Expanded(child: StatusCountCard(title: 'Taken', count: '$takenCount', color: AppColors.statusTaken)),
                        const SizedBox(width: 12),
                        Expanded(child: StatusCountCard(title: 'Overdue', count: '$overdueCount', color: AppColors.statusOverdue)),
                      ],
                    ),
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.background,
                  titleSpacing: 16.0,
                  title: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Search keys...',
                        hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 15, fontWeight: FontWeight.w400),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.search_rounded, color: Color(0xFF2563EB), size: 16),
                          ),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  bottom: const PreferredSize(preferredSize: Size.fromHeight(16.0), child: SizedBox()),
                ),
                if (filteredKeys.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text('No keys found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 80.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final keyItem = filteredKeys[index];
                          final status = keyItem['computed_status'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => KeyDetailsScreen(keyItem: keyItem)
                                ));
                              },
                              child: KeyInfoCard(
                                keyName: keyItem['key_name'],
                                roomId: keyItem['room_id'],
                                status: status,
                                statusColor: _getStatusColor(status),
                              ),
                            ),
                          );
                        },
                        childCount: filteredKeys.length,
                      ),
                    ),
                  ),
              ],
            );
          }
        ),
      ),
    );
  }
}
