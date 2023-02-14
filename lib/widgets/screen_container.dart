import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  final Widget bodyWidget;
  const ScreenContainer({Key? key, required this.bodyWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: bodyWidget,
      ),
    );
  }
}
