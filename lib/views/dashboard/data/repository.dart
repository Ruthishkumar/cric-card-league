import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:firebase_database/firebase_database.dart';

class Repository {
  static final Repository _singleton = Repository._();

  Repository._();

  factory Repository() => _singleton;

  static Repository get instance => _singleton;
  final FirebaseDatabase reference = FirebaseDatabase.instance;

  Future<String> createRoom(GameModel gameModel) async {
    final DatabaseReference _messagesRef =
        FirebaseDatabase.instance.reference().child('users').push().child('id');
    _messagesRef.push().set(gameModel.toJson());
    return _messagesRef.orderByValue().toString();
  }
}
