class GameModel {
  String? id;
  String? name;
  String? createdBy;

  GameModel({this.id, this.name, this.createdBy});

  GameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
