import 'dart:developer' as developer;
import 'dart:math';

import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/services/database_service.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
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

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
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
    DatabaseService().getData();
    super.initState();
  }

  @override
  dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  getData() {
    var user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    final mainList = database.onValue;

    var gridList = [
      {'statsHeader': 'Bat Avg :', 'Value': '1'},
      {'statsHeader': 'Bowl Avg : ', 'Value': '1'},
      {'statsHeader': 'Runs :', 'Value': '1'},
      {'statsHeader': 'Wickets :', 'Value': '1'},
      {'statsHeader': 'Strike rate :', 'Value': '1'},
      {'statsHeader': 'Eco. rate :', 'Value': '1'},
    ];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffF2C94C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.sp))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.sp)),
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
                      Container(
                        padding: EdgeInsets.all(15.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2C94C),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 12)
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100.sp),
                            bottomRight: Radius.circular(100.sp),
                          ),
                        ),
                        child: scorePoints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.sp),
                  SizedBox(
                    height: 390.sp,
                    width: 250.sp,
                    child: WidgetFlipper(
                        frontWidget: AnimatedBuilder(
                          animation: _resizableController,
                          builder: (BuildContext context, Widget? child) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff243b55),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white70
                                            .withOpacity(0.3), //New
                                        blurRadius: 5.0,
                                        spreadRadius: 5.0)
                                  ],
                                  border: Border.all(
                                      color: Colors.white,
                                      width: _resizableController.value * 3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.sp))),
                              alignment: Alignment.center,
                              child: Text(
                                "Tap to Open the Card",
                                style: AppTextStyles.instance.points,
                              ),
                            );
                          },
                        ),
                        backWidget: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff243b55),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.white70.withOpacity(0.3), //New
                                    blurRadius: 5.0,
                                    spreadRadius: 5.0)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.sp))),
                          child: Column(
                            children: [
                              Container(
                                width: 250.sp,
                                padding: EdgeInsets.fromLTRB(
                                    12.sp, 12.sp, 12.sp, 0.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder(
                                            stream: refDb.onValue,
                                            builder: (context, snapShot) {
                                              return snapShot.data != null
                                                  ? Text(
                                                      snapShot
                                                          .data!.snapshot.value
                                                          .toString(),
                                                      style: AppTextStyles
                                                          .instance
                                                          .cardFirstName)
                                                  : Text('');
                                            }),
                                        Text(
                                          'Kohli',
                                          style: AppTextStyles
                                              .instance.cardSecondName,
                                        ),
                                        SizedBox(height: 10.sp),
                                        Text(
                                          'India'.toUpperCase(),
                                          style: AppTextStyles
                                              .instance.countryName,
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'assets/images/Virat-Kohli-T20I2020.png',
                                      height: 150.sp,
                                      width: 100.sp,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(
                                      12.sp, 12.sp, 12.sp, 12.sp),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.sp))),
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: gridList.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: (1 / .3),
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Map data = gridList[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff243b55),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              12.sp))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    data['statsHeader'],
                                                    style: AppTextStyles
                                                        .instance.playersStats,
                                                  ),
                                                  Text(data['Value'])
                                                ],
                                              ),
                                            );
                                          }),
                                      SizedBox(height: 15.sp),
                                      Container(
                                        width: 120.sp,
                                        padding: EdgeInsets.fromLTRB(
                                            12.sp, 8.sp, 12.sp, 8.sp),
                                        decoration: BoxDecoration(
                                            color: const Color(0xff243b55),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.sp))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Top Score :',
                                              style: AppTextStyles
                                                  .instance.playersStats,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
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
          onTap: _leftRotation,
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
          onTap: _rightRotation,
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
    } else {
      controller?.reverse();
      isFrontVisible = true;
    }
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
