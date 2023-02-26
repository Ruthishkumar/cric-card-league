import 'dart:developer';

import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/authentication/screens/login_page.dart';
import 'package:ds_game/views/authentication/screens/success_page.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/screens/card_template_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'views/dashboard/screens/flip_animation.dart';

String userId = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  userId = await StorageServices().getUserId();
  log(userId.toString());
  log('Get User Id');
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
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: userId == '' ? const LoginPage() : const SuccessPage());
      },
    );
  }
}
