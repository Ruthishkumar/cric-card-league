import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  String roomId = "";

  bool isLoading = false;

  final gameServices = GameServices.instance;

  void hostRoom(GameModel gameModel) async {
    await gameServices.createHostGameService(roomModel: gameModel);
    roomId = gameModel.roomId.toString();
    notifyListeners();
  }

  void createRoom(String value) {
    roomId = value;
    notifyListeners();
  }

  void joinRoom(GamePlayerModel joinModel, String roomId) async {
    await gameServices.joinGameService(joinModel: joinModel, roomId: roomId);
    notifyListeners();
  }

  void hostCardSelect(
      {required String value, required SelectCardModel selectCardModel}) async {
    await gameServices.selectCard(
        roomId: value, selectCardModel: selectCardModel);
    notifyListeners();
  }
}
