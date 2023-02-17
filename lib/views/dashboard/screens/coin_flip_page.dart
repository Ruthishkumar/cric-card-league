import 'dart:developer';
import 'dart:math';

import 'package:ds_game/views/dashboard/screens/card_template_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> {
  late bool _showFrontSide;
  double _distanceFromBottom =
      90; // controls coin's distance from bottom of screen
  bool isActive = false; // is the coin being flipped right now
  bool _soundOn = true;
  String _face = ''; // initialize string face
  final List<String> faces = ['heads', 'tails'];
  double afterTossOpacity = 0;
  double beforeTossOpacity = 1;
  int _flip_duration = 1800;

  final player = AudioCache();

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
  }

  @override
  void dispose() {
    super.dispose();
    player.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!isActive) {
          isActive = true;
          int faceIndex = Random().nextInt(faces.length);
          _flipCoin(faces[faceIndex]);
        }
      },
      child: ScreenContainer(
        bodyWidget: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home_bg.jpg',
              fit: BoxFit.cover,
            ),
            isActive == false
                ? Align(
                    alignment: const Alignment(-0.01, 0.15),
                    child: AnimatedOpacity(
                      child: Text(
                        'Let\'s have a Toss and\nclick the toss button',
                        style: AppTextStyles.instance.tossHeader,
                      ),
                      duration: const Duration(seconds: 1),
                      opacity: isActive == false
                          ? beforeTossOpacity
                          : afterTossOpacity,
                    ),
                  )
                : Container(),
            AnimatedPositioned(
              duration: const Duration(seconds: 2),
              curve: Curves.bounceOut,
              bottom: _distanceFromBottom,
              right: MediaQuery.of(context).size.width * 0.31,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: _flip_duration),
                transitionBuilder: __transitionBuilder,
                child: _showFrontSide ? _buildHeads() : _buildTails(),
                switchOutCurve: Curves.easeIn.flipped,
              ),
            ),
            SizedBox(height: 100.sp),
            Align(
              alignment: const Alignment(-0.01, 0.20),
              child: AnimatedOpacity(
                child: Text(
                  _face.toUpperCase(),
                  style: AppTextStyles.instance.tossHeader,
                ),
                duration: const Duration(seconds: 1),
                opacity: afterTossOpacity,
              ),
            ),
            Align(
              alignment: const Alignment(-0.01, 0.40),
              child: AnimatedOpacity(
                child: SizedBox(
                  width: 200.sp,
                  child: AppButton(
                      label: 'Start Game',
                      onPressed: () {
                        NavigationRoute()
                            .animationRoute(context, const CardTemplatePage());
                      }),
                ),
                duration: const Duration(seconds: 1),
                opacity: afterTossOpacity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _flipCoin(String face) async {
    setState(() {
      if (_soundOn) {
        player.play('assets/images/Toss.mp3');
      }
      _distanceFromBottom = 380;
      _showFrontSide = !_showFrontSide;
      _face = face;
    });
    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      if (_soundOn) {
        player.play('assets/images/Toss.mp3');
      }
      setState(() {
        afterTossOpacity = 1.0;
      });
    });
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi * 12, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.01;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value * 16, pi / 2) : rotateAnim.value;
        if (_face == 'heads') {
          return Transform(
            transform: (Matrix4.rotationX(value)),
            child: (rotateAnim.value < 0.5 ||
                    value > 1.4 && value < 1.5 ||
                    (value > pi / 4 && value < pi / 2) ||
                    (value > pi * 3 && value < pi * 4) ||
                    (value > pi * 5 && value < pi * 6) ||
                    (value > pi * 8 && value < pi * 9))
                ? _buildHeads()
                : _buildTails(),
            alignment: Alignment.center,
          );
        } else {
          return Transform(
            transform: (Matrix4.rotationX(value)),
            child: (rotateAnim.value < 1 ||
                    value > 1.4 && value < 1.5 ||
                    (value > pi / 4 && value < pi / 2) ||
                    (value > pi * 3 && value < pi * 4) ||
                    (value > pi * 5 && value < pi * 6) ||
                    (value > pi * 8 && value < pi * 9))
                ? _buildTails()
                : _buildHeads(),
            alignment: Alignment.center,
          );
        }
      },
    );
  }

  Widget _buildHeads() {
    return __buildLayout(
      key: const ValueKey(true),
      faceName: "Heads",
    );
  }

  Widget _buildTails() {
    return __buildLayout(
      key: const ValueKey(false),
      faceName: "Tails",
    );
  }

  Widget __buildLayout({required Key key, required String faceName}) {
    return Material(
        color: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.grey,
        key: key,
        child: SizedBox(
            height: 150,
            child: Center(
              child: faceName == "Heads"
                  ? Image.asset('assets/images/heads.png')
                  : Image.asset('assets/images/tails.png'),
            )));
  }
}
