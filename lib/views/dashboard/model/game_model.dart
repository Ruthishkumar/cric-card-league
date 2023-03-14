import 'package:json_annotation/json_annotation.dart';
part 'game_model.g.dart';

@JsonSerializable()
class GameModel {
  String hostId;
  String? phoneNumber;
  List<GamePlayerModel>? players;
  String? gameId;

  GameModel(
      {required this.hostId, this.phoneNumber, this.players, this.gameId});

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);
  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}

@JsonSerializable()
class GamePlayerModel {
  final String name;
  final int timestamp;

  GamePlayerModel({required this.name, required this.timestamp});

  factory GamePlayerModel.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$GamePlayerModelToJson(this);
}
