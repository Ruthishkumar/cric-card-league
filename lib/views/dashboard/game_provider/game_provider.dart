import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameModel? gameModel;
  GameModel? get game => gameModel;

  bool isLoading = false;
  bool isHost = false;

  final gameServices = GameServices.instance;

  void createHostRoom() async {
    isLoading = true;
    notifyListeners();
    if (isHost) {
      String gameId = await gameServices.createRoom(gameModel!);
      game?.gameId = gameId;
    }
  }
}
