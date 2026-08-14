import 'package:flutter/material.dart';

class KeysScreen extends StatelessWidget {
  const KeysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Key Handover',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16.0, bottom: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                          context, 'Available', '0', Colors.green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                          context, 'Taken', '0', Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatBox(
                          context, 'Overdue', '0', Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              titleSpacing: 16.0,
              title: TextField(
                decoration: InputDecoration(
                  hintText: 'Search keys...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(16.0),
                child: SizedBox(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 24.0, bottom: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildKeyCard(context, 'Meeting Room', 'MR-01', 'Available',
                        Colors.green),
                    _buildKeyCard(context, 'Server Room', 'SR-01', 'Taken',
                        Colors.orange),
                    _buildKeyCard(context, 'Store Room', 'ST-01', 'Overdue',
                        Colors.red),
                    _buildKeyCard(context, 'Main Gate', 'MG-01', 'Available',
                        Colors.green),
                    _buildKeyCard(context, 'Conference', 'CR-01', 'Available',
                        Colors.green),
                    _buildKeyCard(
                        context, 'HR Office', 'HR-01', 'Taken', Colors.orange),
                    _buildKeyCard(
                        context, 'CEO Office', 'CEO-01', 'Taken', Colors.orange),
                    _buildKeyCard(context, 'IT Room', 'IT-01', 'Available',
                        Colors.green),
                    _buildKeyCard(
                        context, 'Pantry', 'PA-01', 'Taken', Colors.orange),
                    _buildKeyCard(context, 'Electrical Room', 'EL-01',
                        'Overdue', Colors.red),
                    _buildKeyCard(context, 'Back Gate', 'BG-01', 'Available',
                        Colors.green),
                    _buildKeyCard(
                        context, 'Archive', 'AR-01', 'Taken', Colors.orange),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
      BuildContext context, String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyCard(BuildContext context, String name, String identifier, String status, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.vpn_key, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    identifier,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
