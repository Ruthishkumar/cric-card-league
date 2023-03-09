import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  void getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("players");
    DatabaseEvent event = await ref.once();
    log(event.snapshot.key.toString());
    log('Get Value');
  }
}
