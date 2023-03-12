import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:firebase_database/firebase_database.dart';

class GameServices {
  static final GameServices _singleton = GameServices._();

  GameServices._();

  factory GameServices() => _singleton;

  static GameServices get instance => _singleton;

  DatabaseReference ref = FirebaseDatabase.instance.ref("jjjj");

  Future createRoom(GameModel gameModel) async {
    await ref.set({
      "userId": gameModel.userId,
      "playerName": gameModel.playerName,
      "phoneNumber": gameModel.phoneNumber
    });
  }
}
