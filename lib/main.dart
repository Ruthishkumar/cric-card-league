import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/authentication/screens/splash_screen.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

String userId = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  userId = await StorageServices().getUserId();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NameProvider()),
    ChangeNotifierProvider(create: (_) => GameProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 805),
      builder: (context, child) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return MaterialApp(
            title: 'CCL',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const SplashScreen());
      },
    );
  }
}
