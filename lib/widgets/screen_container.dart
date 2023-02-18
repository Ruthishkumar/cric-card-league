import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  final Widget bodyWidget;
  const ScreenContainer({Key? key, required this.bodyWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: bodyWidget,
    );
  }
}
