import 'package:flutter/material.dart';

class NavigationRoute {
  animationRoute(BuildContext context, Widget child) {
    return Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
      return child;
    }));
  }
}
