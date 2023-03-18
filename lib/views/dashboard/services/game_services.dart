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

  /// For Create User
  Future createUserGameService(
      {required GamePlayerModel gamePlayerModel}) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('user').child(userId);
    ref.set(gamePlayerModel.toJson()).asStream();
  }

  /// For Create Room
  Future createHostGameService({required GameModel roomModel}) async {
    try {
      var uuid = const Uuid();
      String roomId = uuid.v4().toString();
      roomId = 'test';
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

  /// For Card Select
  Future selectCard(
      {required String roomId,
      required SelectCardModel selectCardModel}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('/$roomId');
    await reference.update(selectCardModel.toJson());
  }

  Future selectToss(
      {required String roomId,
      required SelectTossModel selectTossModel}) async {
    DataSnapshot playerData = await FirebaseDatabase.instance
        .ref('Room')
        .child('/$roomId/players')
        .get();
    for (var playerId in (playerData.value as Map<dynamic, dynamic>).keys) {
      if (playerId == FirebaseAuth.instance.currentUser!.uid) {
        DatabaseReference reference = FirebaseDatabase.instance
            .ref('Room')
            .child(
                '/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
        reference.update(selectTossModel.toJson());
      } else {
        SelectTossModel oppToss = SelectTossModel(
            selectToss: selectTossModel.selectToss,
            wonToss: !selectTossModel.wonToss);
        DatabaseReference reference = FirebaseDatabase.instance
            .ref('Room')
            .child('/$roomId/players/$playerId');
        reference.update(oppToss.toJson());
        FirebaseDatabase.instance
            .ref('Room')
            .child('/$roomId')
            .update({"selectToss": true});
      }
    }

    DatabaseReference reference = FirebaseDatabase.instance
        .ref('Room')
        .child('/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
    await reference.update(selectTossModel.toJson());
  }

  Future matchTotalCard(
      {required String roomId, required TotalCardModel totalCardModel}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('/$roomId');
    await reference.update(totalCardModel.toJson());
  }

  Future<DatabaseReference> getMyPlayer() async {
    //TODO::Change actual room ID;
    DatabaseReference reference = FirebaseDatabase.instance.ref('Room').child(
        'test/players/${FirebaseAuth.instance.currentUser!.uid}/playerCharacters');
    return reference;
  }
}
