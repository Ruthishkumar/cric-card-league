import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/screens/player-card.widget.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardTemplatePage extends StatefulWidget {
  const CardTemplatePage({Key? key}) : super(key: key);

  @override
  State<CardTemplatePage> createState() => _CardTemplatePageState();
}

class _CardTemplatePageState extends State<CardTemplatePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _resizableController;

  DatabaseReference refDb =
      FirebaseDatabase.instance.ref('playerStats/0/firstName');
  final database = FirebaseDatabase.instance.ref("playerStats");

  @override
  void initState() {
    getData();
    _resizableController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
    getPlayersData();
  }

  getPlayersData() async {}

  @override
  dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  List<CreatePlayerModel> playerList = [];
  getData() {
    GameServices().getMyPlayer().asStream().listen((event) {
      event.onValue.listen((event) {
        dev.log("Player Details Changed");
        try {
          dev.log(event.snapshot.value.toString());
          (event.snapshot.value as List<Object?>).forEach((e) => playerList.add(
              CreatePlayerModel.fromJson(
                  json.decode(json.encode(e)) as Map<String, dynamic>)));
          playerList = event.snapshot.value as List<CreatePlayerModel>;
          dev.log(playerList.length.toString());
          dev.inspect('*********PlayerList***********');
          setState(() {});
        } catch (e, stck) {
          dev.log(e.toString());
          dev.inspect(e);
          dev.inspect(stck);
        }
      });
    });
  }

  String selectedPlayerFeature = '';

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        bodyWidget: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/home_bg.jpg',
          fit: BoxFit.cover,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 20.sp),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                          width: 250.sp,
                          decoration: BoxDecoration(
                              color: const Color(0xffF2C94C),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.sp))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 57,
                                  height: 57,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.sp)),
                                      color: Colors.white),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  )),
                              Container(
                                padding: EdgeInsets.all(16.sp),
                                child: Text(
                                  'Your Cards',
                                  style: GoogleFonts.prompt(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.sp,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                width: 57,
                                height: 57,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.sp)),
                                ),
                                child: Center(child: Consumer<NameProvider>(
                                  builder: (widget, data, child) {
                                    return Text(data.cardTotal.toString(),
                                        style: GoogleFonts.prompt(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 15.sp,
                                            color: Colors.black));
                                  },
                                )),
                              )
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 30.sp),
                  if (playerList.isNotEmpty)
                    PlayerCardWidget(
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
        ),
      ],
    ));
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
