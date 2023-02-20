import 'dart:developer';

import 'package:ds_game/views/dashboard/data/repository.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameModel? gameModel;

  bool isLoading = false;
  bool isHost = false;

  final repository = Repository.instance;

  @override
  void addListener(listener) {
    initRoom();
    super.addListener(listener);
  }

  initRoom() async {
    isLoading = true;
    notifyListeners();
    String id = await repository.createRoom(gameModel!);
    gameModel?.id = id;
    log(gameModel!.id.toString());
    isLoading = false;
    notifyListeners();
  }
}
