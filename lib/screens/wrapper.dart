import 'package:expenditure/models/user.dart';
import 'package:expenditure/screens/add_new/add_new_expenditure.dart';
import 'package:expenditure/screens/search/search_expenditure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'analytics/analytics.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';
import 'settings/settings.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // TODO: Fix me
    // It creates all the screens again when changing screens, in other
    // words when _selectedScreenIndex is updated

    if (user != null) {
      final List<Widget> _screens = [
        Home(user: user),
        SearchExpenditure(),
        AddNewExpenditure(),
        Analytics(),
        Settings(),
      ];

      return Scaffold(
        body: _screens[_selectedScreenIndex],
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedIconTheme: IconThemeData(color: Colors.black),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 24,
          currentIndex: _selectedScreenIndex,
          backgroundColor: Colors.white,
          elevation: 0.0,
          onTap: _onBottomNavBarItemTap,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              activeIcon: Icon(Icons.add_circle),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      );
    } else {
      return Authenticate();
    }
  }

  void _onBottomNavBarItemTap(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }
}
