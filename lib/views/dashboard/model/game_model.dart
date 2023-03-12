import 'package:json_annotation/json_annotation.dart';
part 'game_model.g.dart';

@JsonSerializable()
class GameModel {
  String userId;
  String phoneNumber;
  String playerName;
  String? gameId;

  GameModel(this.userId, this.phoneNumber, this.playerName, this.gameId);

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);
  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}
