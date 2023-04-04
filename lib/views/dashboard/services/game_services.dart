import 'dart:developer';

import 'package:ds_game/views/authentication/services/storage_services.dart';
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

  Future createSelectCard({required bool card}) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref('Room');
    await reference.update({'cardUpdate': card});
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

  Future createPlayerCharacters(
      {required String roomId, required GamePlayerAdd gamePlayerAdd}) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref('Room')
        .child('/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
    await databaseReference.update(gamePlayerAdd.toJson());
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
  Future<DatabaseReference> getMyPlayer({required String roomId}) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref('Room').child(
        '$roomId/players/${FirebaseAuth.instance.currentUser!.uid}/playerCharacters');
    return reference;
  }

  /// auto nav select
  Future<DatabaseReference> autoNavSelectToss({required String roomId}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room/$roomId/selectToss');
    return reference;
  }

  /// join total select card
  joinSelectOfCard(String roomId) async {
    // String roomId = await StorageServices().getJoinRoomId();
    // log(roomId);
    log('message');
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room/$roomId/totalCards');
    return reference;
  }

  /// For Player Shown
  Future<DatabaseReference> getCurrentPlayer({required String roomId}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('$roomId/currentPlayer');
    return reference;
  }

  /// For Select Player Stats
  createSelectStats(
      {required String selectedKey,
      required String selectedValue,
      required String currentPlayer,
      required String selectedName,
      required String roomId}) async {
    try {
      DatabaseEvent snap =
          await FirebaseDatabase.instance.ref('Room').child('/$roomId').once();
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
      if (double.parse(playerAValue) == double.parse(playerBValue)) {
        Future.delayed(const Duration(seconds: 2), () async {
          drawPlayer(
              loser: playerBCharacter,
              winner: playerACharacter,
              winnerId: playerAId,
              loserId: playerBId,
              gameRoomId: roomId);
        });
        drawPlayer(
            loser: playerACharacter,
            winner: playerBCharacter,
            winnerId: playerBId,
            loserId: playerAId,
            gameRoomId: roomId);
        return FirebaseDatabase.instance.ref('Room').child('/$roomId').update({
          'selectedKey': selectedKey,
          'selectedValue': selectedValue,
          'matchDrawn': true,
          'currentPlayer': FirebaseAuth.instance.currentUser!.uid.toString(),
        });
      } else if (selectedKey == "bowlAvg") {
        var isPlayerAWon =
            double.parse(playerAValue) < double.parse(playerBValue);
        if (isPlayerAWon) {
          Future.delayed(const Duration(seconds: 3), () async {
            movePlayer(
                loser: playerBCharacter,
                winner: playerACharacter,
                winnerId: playerAId,
                loserId: playerBId,
                gameRoomId: roomId);
          });
        } else {
          Future.delayed(const Duration(seconds: 3), () async {
            movePlayer(
                loser: playerACharacter,
                winner: playerBCharacter,
                winnerId: playerBId,
                loserId: playerAId,
                gameRoomId: roomId);
          });
        }
        return FirebaseDatabase.instance.ref('Room').child('/$roomId').update({
          'selectedKey': selectedKey,
          'selectedValue': selectedValue,
          'currentPlayer': isPlayerAWon ? map['hostId'] : playerBId,
          'matchDrawn': false,
          'matchWon': isPlayerAWon ? 'HostWon' : 'JoinWon',
        });
      } else if (selectedKey == "ecoRate") {
        var isPlayerAWon =
            double.parse(playerAValue) < double.parse(playerBValue);
        if (isPlayerAWon) {
          Future.delayed(const Duration(seconds: 3), () async {
            movePlayer(
                loser: playerBCharacter,
                winner: playerACharacter,
                winnerId: playerAId,
                loserId: playerBId,
                gameRoomId: roomId);
          });
        } else {
          Future.delayed(const Duration(seconds: 3), () async {
            movePlayer(
                loser: playerACharacter,
                winner: playerBCharacter,
                winnerId: playerBId,
                loserId: playerAId,
                gameRoomId: roomId);
          });
        }
        return FirebaseDatabase.instance.ref('Room').child('/$roomId').update({
          'selectedKey': selectedKey,
          'selectedValue': selectedValue,
          'currentPlayer': isPlayerAWon ? map['hostId'] : playerBId,
          'matchDrawn': false,
          'matchWon': isPlayerAWon ? 'HostWon' : 'JoinWon',
        });
      } else {
        var isPlayerAWon =
            double.parse(playerAValue) > double.parse(playerBValue);
        if (isPlayerAWon) {
          Future.delayed(const Duration(seconds: 3), () async {
            movePlayer(
                loser: playerBCharacter,
                winner: playerACharacter,
                winnerId: playerAId,
                loserId: playerBId,
                gameRoomId: roomId);
          });
        } else {
          Future.delayed(const Duration(seconds: 3), () async {
            movePlayer(
                loser: playerACharacter,
                winner: playerBCharacter,
                winnerId: playerBId,
                loserId: playerAId,
                gameRoomId: roomId);
          });
        }
        return FirebaseDatabase.instance.ref('Room').child('/$roomId').update({
          'selectedKey': selectedKey,
          'selectedValue': selectedValue,
          'currentPlayer': isPlayerAWon ? map['hostId'] : playerBId,
          'matchDrawn': false,
          'matchWon': isPlayerAWon ? 'HostWon' : 'JoinWon',
        });
      }
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// Draw Player Function
  void drawPlayer(
      {required List<dynamic> loser,
      required List<dynamic> winner,
      required String winnerId,
      required String loserId,
      required String gameRoomId}) {
    Future.delayed(const Duration(seconds: 2), () async {
      Map<dynamic, dynamic> winnerFinalMap = {};
      for (int i = 1; i < winner.length; i++) {
        winnerFinalMap[(i - 1).toString()] = winner[i];
      }
      winnerFinalMap[(winner.length - 1).toString()] = winner[0];
      Map<dynamic, dynamic> loserFinalMap = {};
      for (int i = 1; i < loser.length; i++) {
        loserFinalMap[(i - 1).toString()] = loser[i];
      }
      loserFinalMap[(loser.length - 1).toString()] = loser[0];
      await FirebaseDatabase.instance
          .ref('Room')
          .child(gameRoomId)
          .child('players')
          .child(winnerId)
          .child('playerCharacters')
          .set(winnerFinalMap);
      await FirebaseDatabase.instance
          .ref('Room')
          .child(gameRoomId)
          .child('players')
          .child(loserId)
          .child('playerCharacters')
          .set(loserFinalMap);
    });
  }

  /// move player function
  void movePlayer(
      {required List<dynamic> loser,
      required List<dynamic> winner,
      required String winnerId,
      required String loserId,
      required String gameRoomId}) {
    var winnerUpdated = [];
    for (var value in winner) {
      winnerUpdated.add(value);
    }
    if (loser.isNotEmpty) {
      winnerUpdated.add(loser[0]);
    }
    Map<dynamic, dynamic> winnerFinalMap = {};
    for (int i = 1; i < winnerUpdated.length; i++) {
      winnerFinalMap[(i - 1).toString()] = winnerUpdated[i];
    }
    winnerFinalMap[(winnerUpdated.length - 1).toString()] = winnerUpdated[0];
    Map<dynamic, dynamic> loserFinalMap = {};
    for (int i = 1; i < loser.length; i++) {
      loserFinalMap[(i - 1).toString()] = loser[i];
    }
    FirebaseDatabase.instance
        .ref('Room')
        .child(gameRoomId)
        .child('players')
        .child(winnerId)
        .child('playerCharacters')
        .set(winnerFinalMap);
    FirebaseDatabase.instance
        .ref('Room')
        .child(gameRoomId)
        .child('players')
        .child(winnerId)
        .child('recentlyWon')
        .set(loser[0]);
    FirebaseDatabase.instance
        .ref('Room')
        .child(gameRoomId)
        .child('players')
        .child(loserId)
        .child('playerCharacters')
        .set(loserFinalMap);

    Future.delayed(const Duration(seconds: 2), () async {
      DatabaseReference reference1 = FirebaseDatabase.instance
          .ref('Room')
          .child(gameRoomId)
          .child('players')
          .child(winnerId)
          .child('recentlyWon');
      reference1.remove();
    });
  }

  /// select feature
  Future selectFeature(
      {required String roomId, required FeatureSelect featureSelect}) async {
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
        reference.update(featureSelect.toJson());
      } else {
        FeatureSelect oppToss =
            FeatureSelect(selectStats: !featureSelect.selectStats);
        DatabaseReference reference = FirebaseDatabase.instance
            .ref('Room')
            .child('/$roomId/players/$playerId');
        reference.update(oppToss.toJson());
        Future.delayed(const Duration(seconds: 3), () async {
          FeatureSelect oppToss1 = FeatureSelect(selectStats: false);
          DatabaseReference reference1 = FirebaseDatabase.instance
              .ref('Room')
              .child('/$roomId/players/$playerId');
          reference1.update(oppToss1.toJson());
        });
      }
      DatabaseReference reference = FirebaseDatabase.instance
          .ref('Room')
          .child('/$roomId/players/${FirebaseAuth.instance.currentUser!.uid}');
      await reference.update(featureSelect.toJson());
    }
  }

  /// hide card status
  Future hideStatus(
      {required String roomId, required HideStatus hideStatus}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('/$roomId');
    await reference.update(hideStatus.toJson());
    Future.delayed(const Duration(seconds: 3), () async {
      DatabaseReference reference1 =
          FirebaseDatabase.instance.ref('Room').child('/$roomId/statusHide');
      await reference1.remove();
    });
  }

  /// select Toss face
  Future selectTossFace(
      {required String roomId, required SelectTossFace face}) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('Room').child('/$roomId');
    await reference.update(face.toJson());
  }

  /// joining waiting card select
  Future waitingCardSelect({required WaitCardJoin waitCardJoin}) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref('Room');
    await reference.update(waitCardJoin.toJson());
  }
}
