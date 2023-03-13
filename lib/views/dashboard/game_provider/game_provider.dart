import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameModel gameModel = GameModel(userId: '', phoneNumber: '', playerName: '');
  GameModel get game => gameModel;

  String gameId = "";

  bool isLoading = false;
  bool isHost = false;

  final gameServices = GameServices.instance;

  void hostRoom(GameModel gameModel) async {
    isLoading = true;
    notifyListeners();
    if (isHost = true) {
      await gameServices.createRoom(gameModel);
      log('AAAA');
    }
    // await joinRoom();
    isLoading = false;
    notifyListeners();
  }

  void createGame({required String value, required String playerName}) {
    game.gameId = value;
    game.playerName = playerName;
    notifyListeners();
  }

  Future joinRoom(GameModel gameModel) async {
    await gameServices.joinRoom(
        game.gameId.toString(), gameModel.userId, gameModel.playerName);
    notifyListeners();
  }
}
