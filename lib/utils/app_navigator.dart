import 'package:expenditure/screens/analytics/analytics.dart';
import 'package:expenditure/screens/crud_expenditure/add_new_expenditure.dart';
import 'package:expenditure/screens/home/home.dart';
import 'package:expenditure/screens/settings/settings.dart';
import 'package:flutter/material.dart';

class AppNavigator extends StatefulWidget {
  AppNavigator();
  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final List<Widget> _screens = <Widget>[];

  @override
  void initState() {
    super.initState();
    _screens.add(Home());
    _screens.add(AddNewExpenditure());
    _screens.add(Analytics());
    _screens.add(Settings());
  }

  int _selectedScreenIndex = 0;

  static const List<BottomNavigationBarItem> _bottomNavigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
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
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] MyNavigator.build called');
    return SafeArea(
      child: Scaffold(
        body: _screens[_selectedScreenIndex],
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    // Can't move this out into a different class because it is tightly coupled
    // with screen body. Need a notification mechanism to move it to a different
    // class
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: Colors.black),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 24,
      currentIndex: _selectedScreenIndex,
      backgroundColor: Colors.white,
      elevation: 0.0,
      onTap: _onBottomNavBarItemTap,
      items: _bottomNavigationBarItems,
    );
  }

  void _onBottomNavBarItemTap(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }
}
