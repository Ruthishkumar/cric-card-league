import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameModel? gameModel;
  GameModel? get game => gameModel;

  String gameId = "";

  bool isLoading = false;
  bool isHost = false;

  final gameServices = GameServices.instance;

  void hostRoom(GameModel gameModel) async {
    await gameServices.createRoom(gameModel);
  }

  void createGame(String value) {
    gameId = value;
    notifyListeners();
  }

  void joinRoom() async {}
}
