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

  Future createRoomId({required String roomId}) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref('Room');
    await reference.update({'roomId': roomId});
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

  /// For Select Toss
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
            wonToss: !selectTossModel.wonToss,
            totalCards: selectTossModel.totalCards);
        DatabaseReference reference = FirebaseDatabase.instance
            .ref('Room')
            .child('/$roomId/players/$playerId');
        reference.update(oppToss.toJson());
        FirebaseDatabase.instance.ref('Room').child('/$roomId').update({
          "selectToss": true,
          'currentPlayer': selectTossModel.wonToss
              ? FirebaseAuth.instance.currentUser!.uid
              : playerId
        });
      }
    }
    DatabaseReference reference = FirebaseDatabase.instance
        .ref('Room')
        .child('/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
    await reference.update(selectTossModel.toJson());
  }

  /// For Total Cards
  Future matchTotalCard(
      {required String roomId, required TotalCardModel totalCardModel}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('/$roomId');
    await reference.update(totalCardModel.toJson());
  }

  /// For Player Shown
  Future<DatabaseReference> getMyPlayer() async {
    //TODO::Change actual room ID;
    DatabaseReference reference = FirebaseDatabase.instance.ref('Room').child(
        'test/players/${FirebaseAuth.instance.currentUser!.uid}/playerCharacters');
    return reference;
  }

  /// For Player Shown
  Future<DatabaseReference> getCurrentPlayer() async {
    //TODO::Change actual room ID;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('test/currentPlayer');
    return reference;
  }

  /// For Select Player Stats
  createSelectStats(
      //TODO::Change actual room ID;
      {required String selectedKey,
      required String selectedValue,
      required String currentPlayer}) async {
    DatabaseEvent snap =
        await FirebaseDatabase.instance.ref('Room').child('test').once();
    // DatabaseEvent snap = await reference.child('players').once();
    var map =
        Map<String, dynamic>.from(snap.snapshot.value as Map<dynamic, dynamic>);
    var playerAValue = "0";
    var playerBValue = "0";
    var playerAId = map['hostId'];
    print(map['players'][map['hostId']]);
    var playerACharacter = (map['players'][map['hostId']]
        as Map<String, dynamic>)['playerCharacters'];
    if (playerACharacter.isNotEmpty) {
      playerAValue = playerACharacter[0][selectedKey];
    }
    var playerBId = (map['players'] as Map<dynamic, dynamic>)
        .keys
        .where((element) => element != map['hostId'])
        .toList()[0];
    var playerBcharacter =
        (map['players'][playerBId] as Map<String, dynamic>)['playerCharacters'];
    if (playerBcharacter.isNotEmpty) {
      playerBValue = playerBcharacter[0][selectedKey];
    }
    var isPlayerAWon = double.parse(playerAValue) > double.parse(playerBValue);
    if (isPlayerAWon) {
      var playerANewArray = [];
      (playerACharacter).forEach((value) {
        playerANewArray.add(value);
      });
      if (playerBcharacter.isNotEmpty) {
        playerANewArray.add(playerBcharacter[0]);
      }
      Map<String, dynamic> finalMap = {};
      for (int i = 1; i < playerANewArray.length - 1; i++) {
        finalMap[(i - 1).toString()] = playerANewArray[i];
      }
      finalMap[(playerANewArray.length - 1).toString()] = playerANewArray[0];

      Map<String, dynamic> playerBfinalMap = {};
      for (int i = 1; i < playerBcharacter.length; i++) {
        playerBfinalMap[(i - 1).toString()] = playerBcharacter[i];
      }
      await FirebaseDatabase.instance
          .ref('Room')
          .child('test')
          .child('players')
          .child(playerBId)
          .child('playerCharacters')
          .set(playerBfinalMap);
      await FirebaseDatabase.instance
          .ref('Room')
          .child('test')
          .child('players')
          .child(playerBId)
          .child('playerCharacters')
          .set(finalMap);
    } else {
      var playerBNewArray = [];
      (playerBcharacter).forEach((value) {
        playerBNewArray.add(value);
      });
      if (playerBcharacter.isNotEmpty) {
        playerBNewArray.add(playerACharacter[0]);
      }
      Map<String, dynamic> finalMap = {};
      for (int i = 1; i < playerBNewArray.length - 1; i++) {
        finalMap[(i - 1).toString()] = playerBNewArray[i];
      }
      finalMap[(playerBNewArray.length - 1).toString()] = playerBNewArray[0];

      Map<String, dynamic> playerAfinalMap = {};
      for (int i = 1; i < playerACharacter.length; i++) {
        playerAfinalMap[(i - 1).toString()] = playerACharacter[i];
      }
      await FirebaseDatabase.instance
          .ref('Room')
          .child('test')
          .child('players')
          .child(playerAId)
          .child('playerCharacters')
          .set(playerAfinalMap);
      await FirebaseDatabase.instance
          .ref('Room')
          .child('test')
          .child('players')
          .child(playerBId)
          .child('playerCharacters')
          .set(finalMap);
    }

    return FirebaseDatabase.instance.ref('Room').child('test').update({
      'selectedKey': selectedKey,
      'selectedValue': selectedValue,
      'currentPlayer': isPlayerAWon ? map['hostId'] : playerBId
    });
  }

  Future cardTotal(
      {required String roomId, required GameCardModel gameCardModel}) async {
    // TODO::Change actual room ID;
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
        reference.update(gameCardModel.toJson());
      } else {
        GameCardModel oppToss =
            GameCardModel(gameTotalCards: !gameCardModel.gameTotalCards);
        DatabaseReference reference = FirebaseDatabase.instance
            .ref('Room')
            .child('/$roomId/players/$playerId');
        reference.update(oppToss.toJson());
      }
      DatabaseReference reference = FirebaseDatabase.instance
          .ref('Room')
          .child('/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
      await reference.update(gameCardModel.toJson());
    }
  }

  Future cardUpdate(String totalCards) {
    DatabaseReference reference = FirebaseDatabase.instance
        .ref('Room/test/players/${FirebaseAuth.instance.currentUser?.uid}');
    return reference.update({'totalCards': totalCards});
  }
}
