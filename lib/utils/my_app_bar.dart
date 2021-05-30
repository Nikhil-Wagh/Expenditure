import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _height = 60;

  final Widget leading;
  final Widget title;
  final List<Widget> actions;
  MyAppBar({this.leading, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}
