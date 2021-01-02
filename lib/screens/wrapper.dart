import 'package:expenditure/models/user.dart';
import 'package:expenditure/screens/add_new/add_new_expenditure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'analytics/analytics.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';
import 'settings/settings.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('[info] Wrapper.build called');
    final user = Provider.of<User>(context);

    if (user != null) {
      return MyNavigator(user: user);
    } else {
      return Authenticate();
    }
  }
}

// Rename this, this is the AfterLoginApp
class MyNavigator extends StatefulWidget {
  final User user;

  MyNavigator({this.user});

  @override
  _MyNavigatorState createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator> {
  final List<Widget> _screens = <Widget>[];

  @override
  void initState() {
    super.initState();
    _screens.add(Home(user: widget.user));
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
    return Scaffold(
      // FIX ME: IndexedStack will have performance issues
      // This will have longer load times
      body: IndexedStack(
        children: _screens,
        index: _selectedScreenIndex,
      ),
      // body: _screens[_selectedScreenIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
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
