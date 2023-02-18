import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static final StorageServices _singleton = StorageServices._internal();

  factory StorageServices() {
    return _singleton;
  }

  StorageServices._internal();

  Future<void> setUserId(String? userId) async {
    if (userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);
    }
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }
}
