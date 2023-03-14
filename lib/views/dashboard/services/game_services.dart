import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class GameServices {
  static final GameServices _singleton = GameServices._();

  GameServices._();

  factory GameServices() => _singleton;

  static GameServices get instance => _singleton;

  FirebaseDatabase ref = FirebaseDatabase.instance;

  Future createRoom(GameModel? gameModel) async {
    var uuid = const Uuid();
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child(uuid.v4());
    reference.set(gameModel?.toJson()).asStream();
  }

  Future joinRoom(String? roomId, String userId, String playerName) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref('Room').child('Join/$userId');
    Map<String, dynamic> playerValue = {
      'gameId': roomId,
      'userId': userId,
      "playerName": playerName
    };
    await databaseReference.push().set(playerValue);
  }

  Future createUser({required GamePlayerModel gamePlayerModel}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('user').child(userId);
    Map<String, dynamic> playerValue = {
      'name': gamePlayerModel.name,
      'createdTime': gamePlayerModel.timestamp
    };
    ref.set(playerValue).asStream();
  }
}
