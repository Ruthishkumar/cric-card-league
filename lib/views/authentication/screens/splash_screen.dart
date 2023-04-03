import 'dart:async';

import 'package:ds_game/views/authentication/screens/login_page.dart';
import 'package:ds_game/views/authentication/screens/success_page.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userId = "";
  @override
  void initState() {
    super.initState();
    getLoginScreen();
  }

  getLoginScreen() async {
    userId = await StorageServices().getUserId();
    userId == ''
        ? Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          })
        : Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SuccessPage()),
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      bodyWidget: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_screen.png',
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
