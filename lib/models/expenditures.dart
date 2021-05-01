import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'expenditure_item.dart';

class Expenditures extends ChangeNotifier {
  static const String TAG = 'ExpendituresModel';
  final List<Expenditure> _items = [];
  DocumentReference _selectedExpenditureRef;
  List<Expenditure> get items => _items.toList();
  // UnmodifiableListView<Expenditure> get items => UnmodifiableListView(_items);

  DocumentReference get selectedExpenditureRef {
    if (_items.isEmpty) {
      return null;
    }
    return _selectedExpenditureRef ?? _items.first.ref;
  }

  void select(Expenditure item) {
    debugPrint('[debug] $TAG.select = ${item.toString()}');
    _selectedExpenditureRef = item.ref;
    notifyListeners();
  }

  int get length {
    return _items.length;
  }

  bool get isEmpty => _items.isEmpty;

  Expenditure operator [](int index) {
    return _items[index];
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void remove(Expenditure expenditure) {
    _items.remove(expenditure);
    notifyListeners();
  }

  void insertAt(int index, Expenditure element) {
    _items.insert(index, element);
    notifyListeners();
  }

  void insert(Expenditure element) {
    _items.add(element);
    notifyListeners();
  }

  int indexOf(DocumentReference ref) {
    for (int i = 0; i < _items.length; i++) {
      if (ref == _items[i].ref) return i;
    }
    // FIXME: Throw an error here
    return -1;
  }

  @override
  String toString() {
    return "{items: ${_items.toString()}, selectedExpenditureRef: $_selectedExpenditureRef}";
  }
}
