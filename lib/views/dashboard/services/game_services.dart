import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GameServices {
  static final GameServices _singleton = GameServices._();

  GameServices._();

  factory GameServices() => _singleton;

  static GameServices get instance => _singleton;

  FirebaseDatabase ref = FirebaseDatabase.instance;

  Future createRoom(GameModel? gameModel) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('HostRoom').child('playerA');
    await reference.push().set(gameModel?.toJson());
  }

  Future joinRoom(String? roomId, String userId, String playerName) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('JoinRoom').child('playerB');
    Map<String, dynamic> playerValue = {
      'gameId': roomId,
      'userId': userId,
      "playerName": playerName
    };
    await databaseReference.push().set(playerValue);
  }
}
