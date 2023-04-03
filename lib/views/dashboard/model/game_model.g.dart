// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      hostId: json['hostId'] as String,
      players: (json['players'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, GamePlayerModel.fromJson(e as Map<String, dynamic>)),
      ),
      roomId: json['roomId'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'hostId': instance.hostId,
      'players': mapPlayerToJson(instance.players),
      'roomId': instance.roomId,
    };

GamePlayerModel _$GamePlayerModelFromJson(Map<String, dynamic> json) =>
    GamePlayerModel(
      name: json['name'] as String,
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$GamePlayerModelToJson(GamePlayerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'timestamp': instance.timestamp,
    };

GamePlayerAdd _$GamePlayerAddFromJson(Map<String, dynamic> json) =>
    GamePlayerAdd(
      playerCharacters:
          (json['playerCharacters'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, CreatePlayerModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$GamePlayerAddToJson(GamePlayerAdd instance) =>
    <String, dynamic>{
      'playerCharacters': mapPlayerListToJson(instance.playerCharacters),
    };

JoinModel _$JoinModelFromJson(Map<String, dynamic> json) => JoinModel(
      name: json['name'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] as int,
    );

Map<String, dynamic> _$JoinModelToJson(JoinModel instance) => <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
    };

SelectCardModel _$SelectCardModelFromJson(Map<String, dynamic> json) =>
    SelectCardModel(
      selectCard: json['selectCard'] as bool,
      totalCards: json['totalCards'] as String,
      totalPoints: json['totalPoints'] as String,
    );

Map<String, dynamic> _$SelectCardModelToJson(SelectCardModel instance) =>
    <String, dynamic>{
      'selectCard': instance.selectCard,
      'totalCards': instance.totalCards,
      'totalPoints': instance.totalPoints,
    };

SelectTossModel _$SelectTossModelFromJson(Map<String, dynamic> json) =>
    SelectTossModel(
      selectToss: json['selectToss'] as bool,
      wonToss: json['wonToss'] as bool,
      totalCards: json['totalCards'] as String,
    );

Map<String, dynamic> _$SelectTossModelToJson(SelectTossModel instance) =>
    <String, dynamic>{
      'selectToss': instance.selectToss,
      'wonToss': instance.wonToss,
      'totalCards': instance.totalCards,
    };

TotalCardModel _$TotalCardModelFromJson(Map<String, dynamic> json) =>
    TotalCardModel(
      cardTotal: json['cardTotal'] as String,
    );

Map<String, dynamic> _$TotalCardModelToJson(TotalCardModel instance) =>
    <String, dynamic>{
      'cardTotal': instance.cardTotal,
    };

PlayerFeature _$PlayerFeatureFromJson(Map<String, dynamic> json) =>
    PlayerFeature(
      batAvg: json['batAvg'] as String,
      bowlAvg: json['bowlAvg'] as String,
      strikeRate: json['strikeRate'] as String,
      economyRate: json['economyRate'] as String,
      runs: json['runs'] as String,
      topScore: json['topScore'] as String,
      wickets: json['wickets'] as String,
    );

Map<String, dynamic> _$PlayerFeatureToJson(PlayerFeature instance) =>
    <String, dynamic>{
      'batAvg': instance.batAvg,
      'bowlAvg': instance.bowlAvg,
      'strikeRate': instance.strikeRate,
      'economyRate': instance.economyRate,
      'runs': instance.runs,
      'topScore': instance.topScore,
      'wickets': instance.wickets,
    };

CreatePlayerModel _$CreatePlayerModelFromJson(Map<String, dynamic> json) =>
    CreatePlayerModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      country: json['country'] as String,
      matches: json['matches'] as String,
      batAvg: json['batAvg'] as String,
      strikeRate: json['strikeRate'] as String,
      runs: json['runs'] as String,
      topScore: json['topScore'] as String,
      wickets: json['wickets'] as String,
      hundreds: json['hundreds'] as String,
      fifties: json['fifties'] as String,
    );

Map<String, dynamic> _$CreatePlayerModelToJson(CreatePlayerModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'country': instance.country,
      'matches': instance.matches,
      'batAvg': instance.batAvg,
      'strikeRate': instance.strikeRate,
      'runs': instance.runs,
      'topScore': instance.topScore,
      'wickets': instance.wickets,
      'hundreds': instance.hundreds,
      'fifties': instance.fifties,
    };

GameCardModel _$GameCardModelFromJson(Map<String, dynamic> json) =>
    GameCardModel(
      gameTotalCards: json['gameTotalCards'] as bool,
    );

Map<String, dynamic> _$GameCardModelToJson(GameCardModel instance) =>
    <String, dynamic>{
      'gameTotalCards': instance.gameTotalCards,
    };

GameSelectedStats _$GameSelectedStatsFromJson(Map<String, dynamic> json) =>
    GameSelectedStats(
      selectedKey: json['selectedKey'] as String,
      selectedValue: json['selectedValue'] as String,
    );

Map<String, dynamic> _$GameSelectedStatsToJson(GameSelectedStats instance) =>
    <String, dynamic>{
      'selectedKey': instance.selectedKey,
      'selectedValue': instance.selectedValue,
    };

FeatureSelect _$FeatureSelectFromJson(Map<String, dynamic> json) =>
    FeatureSelect(
      selectStats: json['selectStats'] as bool,
    );

Map<String, dynamic> _$FeatureSelectToJson(FeatureSelect instance) =>
    <String, dynamic>{
      'selectStats': instance.selectStats,
    };

SelectTossFace _$SelectTossFaceFromJson(Map<String, dynamic> json) =>
    SelectTossFace(
      chooseCall: json['chooseCall'] as String,
    );

Map<String, dynamic> _$SelectTossFaceToJson(SelectTossFace instance) =>
    <String, dynamic>{
      'chooseCall': instance.chooseCall,
    };

HideStatus _$HideStatusFromJson(Map<String, dynamic> json) => HideStatus(
      statusHide: json['statusHide'] as bool,
    );

Map<String, dynamic> _$HideStatusToJson(HideStatus instance) =>
    <String, dynamic>{
      'statusHide': instance.statusHide,
    };

WaitCardJoin _$WaitCardJoinFromJson(Map<String, dynamic> json) => WaitCardJoin(
      playerWaiting: json['playerWaiting'] as bool,
    );

Map<String, dynamic> _$WaitCardJoinToJson(WaitCardJoin instance) =>
    <String, dynamic>{
      'playerWaiting': instance.playerWaiting,
    };
