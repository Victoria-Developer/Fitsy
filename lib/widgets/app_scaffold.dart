import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {super.key,
      required this.child,
      required this.onNavigateToTab,
      required this.currentTabId});

  final Widget child;
  final void Function(int) onNavigateToTab;
  final int currentTabId;

  @override
  Widget build(BuildContext context) {
    const unselectedItemColor = Colors.white;
    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Plans')
    ];

    bool isPartOfBottomNav = items.length > currentTabId || currentTabId >= 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onNavigateToTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: isPartOfBottomNav ? Colors.amber : unselectedItemColor,
        unselectedItemColor: unselectedItemColor,
        currentIndex: isPartOfBottomNav ? currentTabId : 0,
        items: items,
      ),
    );
  }

}
