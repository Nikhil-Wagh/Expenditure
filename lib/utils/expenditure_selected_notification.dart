import 'package:flutter/material.dart';

class ExpenditureSelectedNotification extends Notification {
  final int selectedIndex;

  ExpenditureSelectedNotification({this.selectedIndex}) {
    print('[debug] SelectedNotification generated with index = $selectedIndex');
  }
}
