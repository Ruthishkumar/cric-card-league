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
    );

Map<String, dynamic> _$GamePlayerModelToJson(GamePlayerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'timestamp': instance.timestamp,
    };

JoinModel _$JoinModelFromJson(Map<String, dynamic> json) => JoinModel(
      name: json['name'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] as int,
    )..players = (json['players'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, GamePlayerModel.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$JoinModelToJson(JoinModel instance) => <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'players': mapPlayerToJson(instance.players),
    };
