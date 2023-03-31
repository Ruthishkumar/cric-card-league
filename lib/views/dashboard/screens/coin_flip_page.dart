import 'dart:math';

import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/screens/card_template_page.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CoinFlipScreen extends StatefulWidget {
  final String roomId;
  const CoinFlipScreen({super.key, required this.roomId});

  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> {
  late bool _showFrontSide;
  double _distanceFromBottom = 90;
  bool isActive = false;
  bool soundOn = true;
  String _face = ''; // initialize string face
  final List<String> faces = ['heads', 'tails'];
  double afterTossOpacity = 0;
  double beforeTossOpacity = 1;
  int flipDuration = 1800;
  String coinSpin = "";

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

  DatabaseReference getToss() {
    DatabaseReference refDb =
        FirebaseDatabase.instance.ref('Room/${widget.roomId}/selectToss');
    return refDb;
  }

  DatabaseReference getRoom() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref('Room/test');
    return refDb;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        bodyWidget: StreamBuilder(
      stream: getRoom().onValue,
      builder: (context, snapShot) {
        if (snapShot.data != null) {
          var roomData = snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
          return (roomData['selectCard'] != true ||
                      roomData['selectToss'] != true) &&
                  roomData['hostId'] != FirebaseAuth.instance.currentUser!.uid
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/home_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // showToss(context),
                          Lottie.asset(
                            'assets/lottie_images/dlf10_3bCWbEJWSv.json',
                          ),
                          Text(
                            "Toss In Progress",
                            style: AppTextStyles.instance.tossHeader,
                          ),
                          SizedBox(height: 50.sp),
                        ],
                      ),
                    )
                  ],
                )
              : roomData['selectCard'] == true &&
                      roomData['selectToss'] == true &&
                      roomData['hostId'] !=
                          FirebaseAuth.instance.currentUser!.uid
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/home_bg.jpg',
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                roomData['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['wonToss'] ==
                                        true
                                    ? 'You Won the Toss'
                                    : 'You Loss the Toss'.toString(),
                                style: AppTextStyles.instance.tossHeader,
                              ),
                              SizedBox(height: 50.sp),
                              HostingButton(
                                text: 'Start Game',
                                color: Colors.green,
                                onPressed: () {
                                  NavigationRoute().animationRoute(
                                      context, const CardTemplatePage());
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Stack(
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Choose the call',
                                        style:
                                            AppTextStyles.instance.tossHeader,
                                      ),
                                      SizedBox(height: 40.sp),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          HeadTailsButton(
                                            text: 'Heads',
                                            color: Colors.green,
                                            onPressed: () {
                                              if (!isActive) {
                                                coinSpin = "Heads";
                                                isActive = true;
                                                int faceIndex = Random()
                                                    .nextInt(faces.length);
                                                _flipCoin(faces[faceIndex]);
                                              }
                                            },
                                          ),
                                          HeadTailsButton(
                                            text: 'Tails',
                                            color: Colors.blue,
                                            onPressed: () {
                                              if (!isActive) {
                                                coinSpin = "Tails";
                                                isActive = true;
                                                int faceIndex = Random()
                                                    .nextInt(faces.length);
                                                _flipCoin(faces[faceIndex]);
                                              }
                                            },
                                          )
                                        ],
                                      )
                                    ],
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
                            duration: Duration(milliseconds: flipDuration),
                            transitionBuilder: __transitionBuilder,
                            child:
                                _showFrontSide ? _buildHeads() : _buildTails(),
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
                            child: Text(
                              roomData['players'][FirebaseAuth.instance
                                          .currentUser!.uid]['wonToss'] ==
                                      true
                                  ? 'You Won the Toss'
                                  : 'You Loss the Toss'.toString(),
                              style: AppTextStyles.instance.tossHeader,
                            ),
                            duration: const Duration(seconds: 1),
                            opacity: afterTossOpacity,
                          ),
                        ),
                        startGameButton()
                      ],
                    );
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home_bg.jpg',
              fit: BoxFit.cover,
            ),
            OverflowBox(
              minHeight: 180,
              maxHeight: 180,
              child: Lottie.asset(
                'assets/lottie_images/Loading.json',
                width: 300,
                height: 300,
              ),
            ),
          ],
        );
      },
    ));
  }

  startGameButton() {
    return Align(
      alignment: const Alignment(-0.01, 0.60),
      child: AnimatedOpacity(
        child: HostingButton(
          text: 'Start Game',
          color: Colors.green,
          onPressed: () {
            NavigationRoute().animationRoute(context, const CardTemplatePage());
          },
        ),
        duration: const Duration(seconds: 1),
        opacity: afterTossOpacity,
      ),
    );
  }

  void _flipCoin(String face) async {
    setState(() {
      if (soundOn) {
        player.play('images/flip.wav');
      }
      _distanceFromBottom = 380;
      _showFrontSide = !_showFrontSide;
      _face = face;
    });
    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      if (soundOn) {
        player.play('images/$face.mp3');
      }
      setState(() {
        afterTossOpacity = 1.0;
      });
      SelectTossModel selectCardModel = SelectTossModel(
          selectToss: isActive,
          wonToss: _face == "heads" && coinSpin == "Heads"
              ? true
              : coinSpin == "Tails" && _face == "tails"
                  ? true
                  : false,
          totalCards:
              Provider.of<NameProvider>(context, listen: false).cardTotal);
      GameServices().selectToss(
          roomId: Provider.of<GameProvider>(context, listen: false).roomId,
          selectTossModel: selectCardModel);
      GameServices().getCurrentPlayer();
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

  showToss(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 100,
          clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.sp)),
          ),
          backgroundColor: Colors.blue,
          title: Lottie.asset('assets/lottie_images/dlf10_3bCWbEJWSv.json',
              width: 100, height: 100),
          content: Text(
            'Toss in Progress',
            textAlign: TextAlign.center,
            style: AppTextStyles.instance.playGame,
          ),
        );
      },
    );
  }
}
