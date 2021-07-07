import 'package:expenditure/screens/analytics/analytics.dart';
import 'package:expenditure/screens/crud_expenditure/add_new_expenditure.dart';
// import 'package:expenditure/screens/crud_expenditure/edit_expenditure.dart';
import 'package:expenditure/screens/home/home.dart';
import 'package:expenditure/screens/settings/settings.dart';
import 'package:flutter/material.dart';

const homePage = '/';
const addNewExpenditurePage = '/new/';
const editExpenditurePage = '/edit/';
const analyticsPage = '/analytics/';
const settingsPage = '/settings/';

class AppNavigator extends StatefulWidget {
  AppNavigator();
  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

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
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.settings_outlined),
    //   activeIcon: Icon(Icons.settings),
    //   label: 'Settings',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('[info] MyNavigator.build called');
    return SafeArea(
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          onGenerateRoute: _onGenerateRoute,
          initialRoute: homePage,
        ),
        // backgroundColor: Colors.white,
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
      // backgroundColor: Colors.white,
      elevation: 0.0,
      onTap: _onBottomNavBarItemTap,
      items: _bottomNavigationBarItems,
    );
  }

  void _onBottomNavBarItemTap(int index) {
    setState(() {
      _selectedScreenIndex = index;

      switch (index) {
        case 0:
          _onHomePressed();
          break;
        case 1:
          _onAddNewExpenditurePressed();
          break;
        case 2:
          _onAnalyticsPressed();
          break;
          // case 3:
          //   _onSettingsPressed();
          break;
      }
    });
  }

  void _onHomePressed() {
    // _navigatorKey.currentState!.pushNamed(homePage);
    _navigatorKey.currentState.pushNamed(homePage);
  }

  void _onAddNewExpenditurePressed() {
    // _navigatorKey.currentState!.pushNamed(addNewExpenditurePage);
    _navigatorKey.currentState.pushNamed(addNewExpenditurePage);
  }

  void _onAnalyticsPressed() {
    // _navigatorKey.currentState!.pushNamed(analyticsPage);
    _navigatorKey.currentState.pushNamed(analyticsPage);
  }

  void _onSettingsPressed() {
    // _navigatorKey.currentState!.pushNamed(settingsPage);
    _navigatorKey.currentState.pushNamed(settingsPage);
  }

  void _onBackPressed() {
    // This refers to the back button in AppBar
    _navigatorKey.currentState.pop();
    setState(() => _selectedScreenIndex = 0);
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget page;
    // late Widget page;
    switch (settings.name) {
      case homePage:
        page = Home();
        break;
      case addNewExpenditurePage:
        page = AddNewExpenditure(onBackPressed: _onBackPressed);
        break;
      case analyticsPage:
        page = AnalyticsPage();
        break;
        // case settingsPage:
        //   page = Settings();
        break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      // settings: settings,
    );
  }
}
