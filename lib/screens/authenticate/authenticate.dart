import 'package:expenditure/constants.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> with SingleTickerProviderStateMixin {
  final List<Tab> authTabs = <Tab>[
    Tab(text: 'Sign in'),
    Tab(text: 'Sign up')
  ];
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: authTabs.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    isScrollable: true,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 4, color: Colors.white),
                      insets: EdgeInsets.only(left: 0, right: 8, bottom: 4),
                    ),
                    labelPadding: EdgeInsets.only(left: 0, right: 8),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: authTabs,
                    controller: _tabController,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: authTabs.map((Tab tab) {
            final String label = tab.text.toLowerCase();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'This is the $label tab',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
