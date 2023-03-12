// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      json['userId'] as String,
      json['phoneNumber'] as String,
      json['playerName'] as String,
      json['gameId'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'playerName': instance.playerName,
      'gameId': instance.gameId,
    };
