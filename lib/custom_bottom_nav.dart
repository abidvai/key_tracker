import 'package:flutter/material.dart';
import 'package:key_tracker/feature/key/presentation/screen/keys_screen.dart';
import 'package:key_tracker/feature/history/presentation/screen/history_screen.dart';
import 'package:key_tracker/feature/handover/presentation/screen/take_key_screen.dart';

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
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakeKeyScreen(),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: kBottomNavigationBarHeight + 10,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vpn_key_rounded,
                    color: _currentIndex == 0
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  Text(
                    'Keys',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: _currentIndex == 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

