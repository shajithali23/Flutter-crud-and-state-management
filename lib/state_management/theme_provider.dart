import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color mainColor = Colors.blue;
  void changeTheme(Color color) {
    mainColor = color;
    notifyListeners();
  }
}
