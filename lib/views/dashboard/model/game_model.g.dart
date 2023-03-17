// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      hostId: json['hostId'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      players: (json['players'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, GamePlayerModel.fromJson(e as Map<String, dynamic>)),
      ),
      roomId: json['roomId'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'hostId': instance.hostId,
      'phoneNumber': instance.phoneNumber,
      'players': mapPlayerToJson(instance.players),
      'roomId': instance.roomId,
    };

GamePlayerModel _$GamePlayerModelFromJson(Map<String, dynamic> json) =>
    GamePlayerModel(
      name: json['name'] as String,
      timestamp: json['timestamp'] as int,
      playerCharacters:
          (json['playerCharacters'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, CreatePlayerModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$GamePlayerModelToJson(GamePlayerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'timestamp': instance.timestamp,
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
    );

Map<String, dynamic> _$SelectCardModelToJson(SelectCardModel instance) =>
    <String, dynamic>{
      'selectCard': instance.selectCard,
    };

SelectTossModel _$SelectTossModelFromJson(Map<String, dynamic> json) =>
    SelectTossModel(
      selectToss: json['selectToss'] as bool,
      tossFace: json['tossFace'] as String,
    );

Map<String, dynamic> _$SelectTossModelToJson(SelectTossModel instance) =>
    <String, dynamic>{
      'selectToss': instance.selectToss,
      'tossFace': instance.tossFace,
    };

TotalCardModel _$TotalCardModelFromJson(Map<String, dynamic> json) =>
    TotalCardModel(
      cardTotal: json['cardTotal'] as String,
    );

Map<String, dynamic> _$TotalCardModelToJson(TotalCardModel instance) =>
    <String, dynamic>{
      'cardTotal': instance.cardTotal,
    };

CreatePlayerModel _$CreatePlayerModelFromJson(Map<String, dynamic> json) =>
    CreatePlayerModel(
      playerName: json['playerName'] as String,
      country: json['country'] as String,
      batAvg: json['batAvg'] as String,
      bowlAvg: json['bowlAvg'] as String,
      runs: json['runs'] as String,
      topScore: json['topScore'] as String,
      economyRate: json['economyRate'] as String,
      strikeRate: json['strikeRate'] as String,
      wickets: json['wickets'] as String,
    );

Map<String, dynamic> _$CreatePlayerModelToJson(CreatePlayerModel instance) =>
    <String, dynamic>{
      'playerName': instance.playerName,
      'country': instance.country,
      'batAvg': instance.batAvg,
      'bowlAvg': instance.bowlAvg,
      'strikeRate': instance.strikeRate,
      'economyRate': instance.economyRate,
      'runs': instance.runs,
      'topScore': instance.topScore,
      'wickets': instance.wickets,
    };
