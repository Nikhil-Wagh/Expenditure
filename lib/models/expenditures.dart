import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'expenditure_item.dart';

class Expenditures extends ChangeNotifier {
  static const String TAG = 'ExpendituresModel';
  final List<Expenditure> _items = [];
  DocumentReference _selectedExpenditureRef;
  UnmodifiableListView<Expenditure> get items => UnmodifiableListView(_items);

  DocumentReference get selectedExpenditureRef {
    if (_items.isEmpty) {
      return null;
    }
    return _selectedExpenditureRef ?? _items.first.ref;
  }

  void add(Expenditure item) {
    _items.add(item);
    notifyListeners();
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
  }

  void remove(Expenditure expenditure) {
    _items.remove(expenditure);
  }

  void insertAt(int index, Expenditure element) {
    _items.insert(index, element);
  }

  void insert(Expenditure element) {
    _items.insert(_items.length - 1, element);
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
