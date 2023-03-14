// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      hostId: json['hostId'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => GamePlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameId: json['gameId'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'hostId': instance.hostId,
      'phoneNumber': instance.phoneNumber,
      'players': instance.players,
      'gameId': instance.gameId,
    };

GamePlayerModel _$GamePlayerModelFromJson(Map<String, dynamic> json) =>
    GamePlayerModel(
      json['name'] as String,
      json['timestamp'] as int,
    );

Map<String, dynamic> _$GamePlayerModelToJson(GamePlayerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'timestamp': instance.timestamp,
    };
