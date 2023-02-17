import 'package:ds_game/views/authentication/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: (10)),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie_images/splash_screen.json',
      controller: _controller,
      animate: true,
      width: 600,
      fit: BoxFit.fill,
      alignment: Alignment.center,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward().whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ));
      },
    );
  }
}
