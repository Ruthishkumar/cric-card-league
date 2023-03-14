import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class GameServices {
  static final GameServices _singleton = GameServices._();

  GameServices._();

  factory GameServices() => _singleton;

  static GameServices get instance => _singleton;

  FirebaseDatabase ref = FirebaseDatabase.instance;

  /// For Create User
  Future createUserGameService({GamePlayerModel? gamePlayerModel}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('user').child(userId);
    Map<String, dynamic> playerValue = {
      'name': gamePlayerModel?.name,
      'createdAt': gamePlayerModel?.timestamp
    };
    ref.set(playerValue).asStream();
  }

  /// For Create Room
  Future createHostGameService({required GameModel roomModel}) async {
    try {
      var uuid = const Uuid();
      String roomId = uuid.v4().toString();
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('Room').child('/$roomId');
      await reference.set(roomModel.toJson());
      roomModel.roomId = roomId;
      log(roomModel.roomId.toString());
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// For Join Room
  Future joinGameService(
      {required GamePlayerModel joinModel, required String roomId}) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref('Room')
          .child('/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
      await databaseReference.update(joinModel.toJson());
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }
}
