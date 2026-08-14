import 'package:flutter/material.dart';
import 'package:key_tracker/feature/key/keys_screen.dart';
import 'package:key_tracker/feature/history/history_screen.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const KeysScreen(), const HistoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.vpn_key_outlined),
            selectedIcon: Icon(
              Icons.vpn_key_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: 'Keys',
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: 'Add',
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: Icon(
              Icons.history_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
