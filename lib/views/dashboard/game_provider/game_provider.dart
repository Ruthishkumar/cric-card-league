import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  String roomId = "";

  String updatedRoomId = "";

  bool isLoading = false;

  final gameServices = GameServices.instance;

  void hostRoom(GameModel gameModel) async {
    await gameServices.createHostGameService(roomModel: gameModel);
    roomId = gameModel.roomId.toString();
    await gameServices.createRoomId(roomId: roomId);
    notifyListeners();
  }

  void createRoomId({required String value}) async {
    await gameServices.createRoomId(roomId: value);
    roomId = value;
    log(roomId);
    log('njfjdfjkn');
    notifyListeners();
  }

  void joinRoom(GamePlayerModel joinModel, String roomId) async {
    await gameServices.joinGameService(joinModel: joinModel, roomId: roomId);
    updatedRoomId = roomId;
    notifyListeners();
  }

  void hostCardSelect(
      {required String value, required SelectCardModel selectCardModel}) async {
    await gameServices.selectCard(
        roomId: value, selectCardModel: selectCardModel);
    notifyListeners();
  }

  Future<void> addCardTotal(
      {required String value,
      required,
      required TotalCardModel totalCardModel}) async {
    await gameServices.matchTotalCard(
        roomId: value, totalCardModel: totalCardModel);
    notifyListeners();
  }
}
