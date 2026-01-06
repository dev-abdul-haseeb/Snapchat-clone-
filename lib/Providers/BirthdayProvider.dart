import 'package:flutter/material.dart';

class BirthdayProvider extends ChangeNotifier {
  String? _selectedMonth;

  // Getter
  String? get selectedMonth => _selectedMonth;

  // Setter
  void setMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
  }
}
