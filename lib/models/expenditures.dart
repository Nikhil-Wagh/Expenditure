import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'expenditure_item.dart';

class Expenditures extends ChangeNotifier {
  Expenditures(this.items, {selectedExpenditureRef}) {
    this._selectedExpenditureRef = selectedExpenditureRef;
  }

  static const String TAG = 'ExpendituresModel';
  final List<Expenditure> items;
  DocumentReference _selectedExpenditureRef;
  // UnmodifiableListView<Expenditure> get items => UnmodifiableListView(_items);

  bool get isLoading => items == null;

  DocumentReference get selectedExpenditureRef {
    if (isEmpty) {
      return null;
    }
    return _selectedExpenditureRef ?? items.first.ref;
  }

  void select(Expenditure item) {
    debugPrint('[debug] $TAG.select = ${item.toString()}');
    _selectedExpenditureRef = item.ref;
    notifyListeners();
  }

  int get length {
    return items != null ? items.length : 0;
  }

  bool get isEmpty => items != null ? items.isEmpty : true;

  Expenditure operator [](int index) {
    return items[index];
  }

  void removeAt(int index) {
    debugPrint('[debug] $TAG Removing element at index = $index');
    if (items[index].ref == _selectedExpenditureRef) {
      debugPrint('[debug] $TAG attempting to select element next candidate');
      _selectNextCandidate(index);
    }

    items.removeAt(index);
    notifyListeners();
  }

  // Select next candidate when the selectedExpenditure is deleted
  // Select next element in the list, if it was the last element then
  // select the previous element
  void _selectNextCandidate(int index) {
    debugPrint('[debug] $TAG selecting next candidate');
    // if last element
    if (index >= items.length - 1) {
      debugPrint('[debug] $TAG last element');
      // if only 1 element, and it will also be deleted
      if (index == 0) {
        debugPrint('[debug] $TAG first element');
        _selectedExpenditureRef = null;
      } else {
        debugPrint('[debug] $TAG previous element = ${items[index - 1]}');
        _selectedExpenditureRef = items[index - 1].ref;
      }
    } else
      _selectedExpenditureRef = items[index + 1].ref;
    debugPrint('[debug] $TAG selectedRef = $_selectedExpenditureRef');
  }

  void insertAt(int index, Expenditure element) {
    items.insert(index, element);
    notifyListeners();
  }

  void insert(Expenditure element) {
    items.add(element);
    notifyListeners();
  }

  int indexOf(DocumentReference ref) {
    for (int i = 0; i < items.length; i++) {
      if (ref == items[i].ref) return i;
    }
    // FIXME: Throw an error here
    return -1;
  }

  @override
  String toString() {
    return "{items: ${items.toString()}, selectedExpenditureRef: $selectedExpenditureRef}";
  }
}
