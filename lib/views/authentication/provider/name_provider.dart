import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String playerName = "";

  void addPlayerName({required String value}) {
    playerName = value;
    notifyListeners();
  }
}
