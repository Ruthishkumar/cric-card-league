import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/update_screens/game_services1.dart';
import 'package:ds_game/views/dashboard/update_screens/player-card.widget1.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CardTemplatePage extends StatefulWidget {
  const CardTemplatePage({Key? key}) : super(key: key);

  @override
  State<CardTemplatePage> createState() => _CardTemplatePageState();
}

class _CardTemplatePageState extends State<CardTemplatePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _resizableController;
  // @override
  // void initState() {
  //   getData();
  //   _resizableController = AnimationController(
  //       vsync: this, duration: const Duration(milliseconds: 1000));
  //   _resizableController.addStatusListener((animationStatus) {
  //     switch (animationStatus) {
  //       case AnimationStatus.completed:
  //         _resizableController.reverse();
  //         break;
  //       case AnimationStatus.dismissed:
  //         _resizableController.forward();
  //         break;
  //       case AnimationStatus.forward:
  //         break;
  //       case AnimationStatus.reverse:
  //         break;
  //     }
  //   });
  //   _resizableController.forward();
  //   super.initState();
  //   getPlayersData();
  // }

  bool _showWidget = true;

  @override
  void initState() {
    getData();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        _showWidget = false;
      });
    });
    super.initState();
  }

  List<CreatePlayerModel> playerList = [];
  String currentPlayer = '';

  getData() async {
    GameServices().getCurrentPlayer().asStream().listen((event) {
      event.onValue.listen((event) {
        dev.log(event.snapshot.value.toString());
        currentPlayer = event.snapshot.value.toString() ?? '';
        dev.log(currentPlayer.toString());
        dev.log('Current Player');
        setState(() {});
      });
    });
    GameServices().getMyPlayer().asStream().listen((event) {
      event.onValue.listen((event) {
        dev.log("Player Details Changed");
        try {
          dev.log(event.snapshot.value.toString());
          playerList.clear();
          if (event.snapshot.value != null) {
            if (event.snapshot.value is List<Object?>) {
              (event.snapshot.value as List<Object?>)
                  .where((element) => element != null)
                  .forEach((e) => playerList.add(CreatePlayerModel.fromJson(
                      json.decode(json.encode(e)) as Map<String, dynamic>)));
            } else {
              (json.decode(json.encode(event.snapshot.value))
                      as Map<String, Object?>)
                  .values
                  .where((element) => element != null)
                  .forEach((e) => playerList.add(CreatePlayerModel.fromJson(
                      json.decode(json.encode(e)) as Map<String, dynamic>)));
            }
          }
          setState(() {});
        } catch (e, stck) {
          dev.log(e.toString());
          dev.inspect(e);
          dev.inspect(stck);
          dev.log('Error Message');
        }
      });
    });
  }

  String selectedPlayerFeature = '';

  DatabaseReference getTotalCard() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref('Room/test');
    return refDb;
  }

  quitGame() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref('Room');
    return refDb.remove();
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.sp))),
            clipBehavior: Clip.none,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie_images/alert.json',
                    width: 100, height: 100),
                SizedBox(height: 15.sp),
                Text('Are you sure you', style: AppTextStyles.instance.alert),
                SizedBox(height: 4.sp),
                Text('want to exit the game',
                    style: AppTextStyles.instance.alert),
                SizedBox(height: 15.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ExitButton(
                        text: 'No',
                        color: Colors.green,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    ExitButton(
                        text: 'Yes',
                        color: Colors.red,
                        onPressed: () {
                          SystemNavigator.pop();
                          quitGame();
                        }),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: ScreenContainer(
          bodyWidget: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/home_bg.jpg',
            fit: BoxFit.cover,
          ),
          StreamBuilder(
            stream: getTotalCard().onValue,
            builder: (context, snapShot) {
              if (snapShot.data != null) {
                var cards =
                    snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Container(
                        padding:
                            EdgeInsets.fromLTRB(20.sp, 50.sp, 20.sp, 20.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                                stream: getTotalCard().onValue,
                                builder: (context, snapShot) {
                                  if (snapShot.data != null) {
                                    var cards = snapShot.data?.snapshot.value
                                        as Map<dynamic, dynamic>;
                                    return Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            Container(
                                                width: 250.sp,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffF2C94C),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16.sp))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: 57,
                                                        height: 57,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        16.sp)),
                                                            color:
                                                                Colors.white),
                                                        child: const Icon(
                                                          Icons.person,
                                                          color: Colors.black,
                                                        )),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(16.sp),
                                                      child: Text(
                                                        'Your Cards',
                                                        style:
                                                            GoogleFonts.prompt(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 15.sp,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    Container(
                                                        width: 57,
                                                        height: 57,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      16.sp)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                                cards['players'][FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid]
                                                                        [
                                                                        'playerCharacters']
                                                                    .length
                                                                    .toString(),
                                                                style: GoogleFonts.prompt(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        15.sp,
                                                                    color: Colors
                                                                        .black))))
                                                  ],
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 15.sp),
                                        _showWidget
                                            ? Text(
                                                cards['players'][FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid]['wonToss'] ==
                                                        true
                                                    ? 'You Select the card first'
                                                    : 'Your opponent select the card first',
                                                style: AppTextStyles
                                                    .instance.tossStatus,
                                              )
                                            : const Text('')
                                      ],
                                    );
                                  }
                                  return const CircularProgressIndicator();
                                }),
                            SizedBox(height: 30.sp),
                            if (playerList.isNotEmpty)
                              PlayerCardWidget(
                                currentPlayer: currentPlayer,
                                playerList: playerList,
                                onFeatureSelect: (selectedFeature) {
                                  setState(() {
                                    selectedPlayerFeature = selectedFeature;
                                  });
                                },
                                selectedFeature: selectedPlayerFeature,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100.sp),
                            topLeft: Radius.circular(100.sp)),
                        color: const Color(0xffF2C94C),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Points',
                            style: AppTextStyles.instance.ipAddress,
                          ),
                          SizedBox(height: 5.sp),
                          Text(
                            '${cards['players'][FirebaseAuth.instance.currentUser!.uid]['playerCharacters'].length * 1000}',
                            style: AppTextStyles.instance.ipAddress,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      )),
    );
  }

  scorePoints() {
    if (Provider.of<NameProvider>(context, listen: false).noOfCards == 0) {
      return Text(
        '1000\nPoints',
        style: AppTextStyles.instance.points,
      );
    } else if (Provider.of<NameProvider>(context, listen: false).noOfCards ==
        1) {
      return Text(
        '2000\nPoints',
        style: AppTextStyles.instance.points,
      );
    } else if (Provider.of<NameProvider>(context, listen: false).noOfCards ==
        2) {
      return Text(
        '3000\nPoints',
        style: AppTextStyles.instance.points,
      );
    }
    return const Text(
      'No Points',
    );
  }
}

class WidgetFlipper extends StatefulWidget {
  const WidgetFlipper({
    Key? key,
    required this.frontWidget,
    required this.backWidget,
  }) : super(key: key);

  final Widget frontWidget;
  final Widget backWidget;

  @override
  _WidgetFlipperState createState() => _WidgetFlipperState();
}

class _WidgetFlipperState extends State<WidgetFlipper>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller!);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller!);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedCard(
          animation: _backRotation,
          child: widget.backWidget,
        ),
        AnimatedCard(
          animation: _frontRotation,
          child: widget.frontWidget,
        ),
        _tapDetectionControls(),
      ],
    );
  }

  Widget _tapDetectionControls() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _leftRotation();
            });
          },
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _rightRotation();
            });
          },
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  void _leftRotation() {
    _toggleSide();
  }

  void _rightRotation() {
    _toggleSide();
  }

  void _toggleSide() {
    if (isFrontVisible) {
      controller?.forward();
      isFrontVisible = false;
    } else {}
  }
}

class AnimatedCard extends StatelessWidget {
  const AnimatedCard({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}
