import 'package:flutter/material.dart';

class MultipleNotifier extends ChangeNotifier {
  final List<String> _selectedItems;

  int _balance;

  MultipleNotifier(this._selectedItems, this._balance);

  List<String> get selectedItems => _selectedItems;

  int get balance => _balance;

  setBalance(int value) {
    _balance = value;
  }

  bool isHaveItem(String value) => _selectedItems.contains(value);

  addItem(String value) {
    if (!isHaveItem(value)) {
      _selectedItems.add(value);
      notifyListeners();
    }
  }

  removeItem(String value) {
    if (isHaveItem(value)) {
      _selectedItems.remove(value);
      notifyListeners();
    }
  }
}
