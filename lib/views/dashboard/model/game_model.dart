import 'package:json_annotation/json_annotation.dart';
part 'game_model.g.dart';

Map<String, dynamic>? mapPlayerToJson(Map<String, GamePlayerModel>? players) {
  Map<String, dynamic> data = {};
  players?.entries.forEach((e) {
    data[e.key] = e.value.toJson();
  });
  return data;
}

Map<String, dynamic>? mapPlayerFeatureToJson(
    Map<String, PlayerFeature>? playerFeature) {
  Map<String, dynamic> data = {};
  playerFeature?.entries.forEach((e) {
    data[e.key] = e.value.toJson();
  });
  return data;
}

Map<String, PlayerFeature>? mapPlayerFeatureFromJson(List<dynamic> playerList) {
  Map<String, PlayerFeature> data = {};
  data["0"] = PlayerFeature.fromJson(playerList[0]);
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
  String totalPoints;

  SelectCardModel(
      {required this.selectCard,
      required this.totalCards,
      required this.totalPoints});

  factory SelectCardModel.fromJson(Map<String, dynamic> json) =>
      _$SelectCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$SelectCardModelToJson(this);
}

@JsonSerializable()
class SelectTossModel {
  bool selectToss;
  bool wonToss;
  String totalCards;

  SelectTossModel(
      {required this.selectToss,
      required this.wonToss,
      required this.totalCards});

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
class PlayerFeature {
  final String batAvg;
  final String bowlAvg;
  final String strikeRate;
  final String economyRate;
  final String runs;
  final String topScore;
  final String wickets;

  PlayerFeature(
      {required this.batAvg,
      required this.bowlAvg,
      required this.strikeRate,
      required this.economyRate,
      required this.runs,
      required this.topScore,
      required this.wickets});

  factory PlayerFeature.fromJson(Map<String, dynamic> json) =>
      _$PlayerFeatureFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerFeatureToJson(this);
}

@JsonSerializable()
class CreatePlayerModel {
  String firstName;
  String lastName;
  String country;
  final String batAvg;
  final String bowlAvg;
  final String strikeRate;
  final String economyRate;
  final String runs;
  final String topScore;
  final String wickets;

  CreatePlayerModel({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.batAvg,
    required this.bowlAvg,
    required this.strikeRate,
    required this.economyRate,
    required this.runs,
    required this.topScore,
    required this.wickets,
  });

  factory CreatePlayerModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePlayerModelToJson(this);
}

@JsonSerializable()
class GameCardModel {
  bool gameTotalCards;

  GameCardModel({required this.gameTotalCards});

  factory GameCardModel.fromJson(Map<String, dynamic> json) =>
      _$GameCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$GameCardModelToJson(this);
}
