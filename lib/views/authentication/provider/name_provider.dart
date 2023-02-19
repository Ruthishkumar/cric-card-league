import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String playerName = "";
  String emailName = "";

  String noOfCards = "";

  void addPlayerName({required String value}) {
    playerName = value;
    notifyListeners();
  }

  void addEmailId({required String value}) {
    emailName = value;
    notifyListeners();
  }

  void addCards({required String value}) {
    noOfCards = value;
    notifyListeners();
  }
}
