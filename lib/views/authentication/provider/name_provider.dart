import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String playerName = "";
  String emailName = "";

  int noOfCards = -1;

  void addPlayerName({required String value}) {
    playerName = value;
    notifyListeners();
  }

  void addEmailId({required String value}) {
    emailName = value;
    notifyListeners();
  }

  void addCards({required int value}) {
    noOfCards = value;
    notifyListeners();
  }
}
