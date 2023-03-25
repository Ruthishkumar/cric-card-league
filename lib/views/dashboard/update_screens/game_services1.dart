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
    try {
      DatabaseEvent snap =
          await FirebaseDatabase.instance.ref('Room').child('test').once();
      var map = Map<dynamic, dynamic>.from(
          snap.snapshot.value as Map<dynamic, dynamic>);
      var playerAValue = "0";
      var playerBValue = "0";
      var playerAId = map['hostId'];
      var playerACharacter = (map['players'][map['hostId']]
          as Map<dynamic, dynamic>)['playerCharacters'];
      if (playerACharacter.isNotEmpty) {
        playerAValue = playerACharacter[0][selectedKey];
      }
      var playerBId = (map['players'] as Map<dynamic, dynamic>)
          .keys
          .where((element) => element != map['hostId'])
          .toList()[0];
      var playerBCharacter = (map['players'][playerBId]
          as Map<dynamic, dynamic>)['playerCharacters'];
      if (playerBCharacter.isNotEmpty) {
        playerBValue = playerBCharacter[0][selectedKey];
      }
      var isPlayerAWon =
          double.parse(playerAValue) > double.parse(playerBValue);
      if (isPlayerAWon) {
        Future.delayed(const Duration(seconds: 1), () async {
          movePlayer(
              loser: playerBCharacter,
              winner: playerACharacter,
              winnerId: playerAId,
              loserId: playerBId);
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () async {
          movePlayer(
              loser: playerACharacter,
              winner: playerBCharacter,
              winnerId: playerBId,
              loserId: playerAId);
        });
      }
      return FirebaseDatabase.instance.ref('Room').child('test').update({
        'selectedKey': selectedKey,
        'selectedValue': selectedValue,
        'currentPlayer': isPlayerAWon ? map['hostId'] : playerBId
      });
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  void movePlayer(
      {required List<dynamic> loser,
      required List<dynamic> winner,
      required String winnerId,
      required String loserId}) {
    Future.delayed(const Duration(seconds: 2), () async {
      var winnerUpdated = [];
      for (var value in winner) {
        winnerUpdated.add(value);
      }
      if (loser.isNotEmpty) {
        winnerUpdated.add(loser);
        log(loser[0].toString());
        log('Looser Card Status');
      }
      Map<dynamic, dynamic> winnerFinalMap = {};
      for (int i = 1; i < winnerUpdated.length - 1; i++) {
        winnerFinalMap[(i - 1).toString()] = winnerUpdated[i];
      }
      winnerFinalMap[(winnerUpdated.length - 1).toString()] = winnerUpdated[0];
      log(winner[0].toString());
      log('Winner Card Status');
      Map<dynamic, dynamic> loserFinalMap = {};
      for (int i = 1; i < loser.length; i++) {
        loserFinalMap[(i - 1).toString()] = loser[i];
      }
      await FirebaseDatabase.instance
          .ref('Room')
          .child('test')
          .child('players')
          .child(winnerId)
          .child('playerCharacters')
          .set(winnerFinalMap);
      await FirebaseDatabase.instance
          .ref('Room')
          .child('test')
          .child('players')
          .child(loserId)
          .child('playerCharacters')
          .set(loserFinalMap);
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
