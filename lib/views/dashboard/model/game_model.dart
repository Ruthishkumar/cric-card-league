import 'package:json_annotation/json_annotation.dart';
part 'game_model.g.dart';

Map<String, dynamic>? mapPlayerToJson(Map<String, GamePlayerModel>? players) {
  Map<String, dynamic> data = {};
  players?.entries.forEach((e) {
    data[e.key] = e.value.toJson();
  });
  return data;
}

Map<String, dynamic>? mapPlayerListToJson(
    Map<String, CreatePlayerModel>? players) {
  Map<String, dynamic> data = {};
  players?.entries.forEach((e) {
    data[e.key] = e.value.toJson();
  });
  return data;
}

@JsonSerializable()
class GameModel {
  String hostId;
  String? phoneNumber;
  @JsonKey(toJson: mapPlayerToJson)
  Map<String, GamePlayerModel>? players;
  String? roomId;

  GameModel(
      {required this.hostId, this.phoneNumber, this.players, this.roomId});

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);
  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}

@JsonSerializable()
class GamePlayerModel {
  final String name;
  final int timestamp;
  @JsonKey(toJson: mapPlayerListToJson)
  Map<String, CreatePlayerModel>? playerCharacters;

  GamePlayerModel(
      {required this.name, required this.timestamp, this.playerCharacters});

  factory GamePlayerModel.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$GamePlayerModelToJson(this);
}

@JsonSerializable()
class JoinModel {
  String name;
  String userId;
  int createdAt;

  JoinModel(
      {required this.name, required this.userId, required this.createdAt});

  factory JoinModel.fromJson(Map<String, dynamic> json) =>
      _$JoinModelFromJson(json);
  Map<String, dynamic> toJson() => _$JoinModelToJson(this);
}

@JsonSerializable()
class SelectCardModel {
  bool selectCard;
  String totalCards;

  SelectCardModel({required this.selectCard, required this.totalCards});

  factory SelectCardModel.fromJson(Map<String, dynamic> json) =>
      _$SelectCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$SelectCardModelToJson(this);
}

@JsonSerializable()
class SelectTossModel {
  bool selectToss;
  String coinFace;

  SelectTossModel({required this.selectToss, required this.coinFace});

  factory SelectTossModel.fromJson(Map<String, dynamic> json) =>
      _$SelectTossModelFromJson(json);
  Map<String, dynamic> toJson() => _$SelectTossModelToJson(this);
}

@JsonSerializable()
class TotalCardModel {
  String cardTotal;

  TotalCardModel({required this.cardTotal});

  factory TotalCardModel.fromJson(Map<String, dynamic> json) =>
      _$TotalCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$TotalCardModelToJson(this);
}

@JsonSerializable()
class CreatePlayerModel {
  String playerName;
  String country;
  String batAvg;
  String bowlAvg;
  String strikeRate;
  String economyRate;
  String runs;
  String topScore;
  String wickets;

  CreatePlayerModel(
      {required this.playerName,
      required this.country,
      required this.batAvg,
      required this.bowlAvg,
      required this.runs,
      required this.topScore,
      required this.economyRate,
      required this.strikeRate,
      required this.wickets});

  factory CreatePlayerModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePlayerModelToJson(this);
}
