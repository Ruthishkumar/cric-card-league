import 'dart:developer';
import 'dart:math';
import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/screens/host_ip_page.dart';
import 'package:ds_game/views/dashboard/screens/players_details_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_input_text_outline.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  TextEditingController playerNameController = TextEditingController();
  final keyIsFirstLoaded = 'is_first_loaded';
  late final focusNameNode = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    Provider.of<NameProvider>(context, listen: false).emailName;
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1),
        () => showDialogIfFirstLoaded(context));
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isVisible = !isVisible;
        });
        return Future.value(isVisible);
      },
      child: ScreenContainer(
        bodyWidget: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home_bg.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 20.sp),
              child: Stack(
                children: [
                  // Consumer<NameProvider>(builder: (child, data, widget) {
                  //   return Text(data.emailName);
                  // }),
                  enterNameWidget(),
                  hostAndJoinWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// initial success pop
  showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 1), () async {
            Navigator.of(context).pop(true);
            // await StorageServices()
            //     .setUserId(FirebaseAuth.instance.currentUser!.uid);
            prefs.setBool(keyIsFirstLoaded, false);
          });
          return AlertDialog(
            elevation: 100,
            clipBehavior: Clip.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.sp)),
            ),
            backgroundColor: Colors.blue,
            title: Lottie.asset('assets/lottie_images/success.json',
                width: 100, height: 100),
            content: Text(
              'Let\'s play a game !',
              textAlign: TextAlign.center,
              style: AppTextStyles.instance.playGame,
            ),
          );
        },
      );
    }
  }

  /// player name widget
  enterNameWidget() {
    return FadeAndTranslate(
      visible: !isVisible,
      curve: Curves.bounceInOut,
      translate: const Offset(0.0, 20.0),
      delay: const Duration(milliseconds: 120),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.sp,
              child: AppInputTextOutline(
                  focusNode: focusNameNode,
                  fillColor: focusNameNode.hasFocus
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  inputController: playerNameController,
                  hintText: 'Your Name'),
            ),
            SizedBox(height: 30.sp),
            GestureDetector(
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
                _validatePlayerNameSummit();
              },
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.sp)))),
                child: Container(
                  width: 250.sp,
                  padding: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 10.sp),
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      border: Border(
                          top: BorderSide(color: Colors.white, width: 7.0))),
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.actor(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// host and join widget
  hostAndJoinWidget() {
    return FadeAndTranslate(
        visible: isVisible,
        translate: const Offset(0.0, 20.0),
        duration: const Duration(milliseconds: 240),
        delay: const Duration(milliseconds: 120),
        curve: Curves.bounceInOut,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.sp),
              GestureDetector(
                onTap: () async {
                  final info = NetworkInfo();
                  final wifiIP = await info.getWifiIP();
                  if (!mounted) {
                    return;
                  }
                  NavigationRoute()
                      .animationRoute(context, const PlayersDetailsPage());
                  // log(wifiIP.toString());
                },
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.sp)))),
                  child: Container(
                    width: 250.sp,
                    padding: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 10.sp),
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        border: Border(
                            top: BorderSide(color: Colors.white, width: 7.0))),
                    child: Text(
                      'Host'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.actor(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.sp),
              GestureDetector(
                onTap: () {
                  NavigationRoute().animationRoute(context, const HostIpPage());
                },
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.sp)))),
                  child: Container(
                    width: 250.sp,
                    padding: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 10.sp),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        border: Border(
                            top: BorderSide(color: Colors.white, width: 7.0))),
                    child: Text(
                      'Join'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.actor(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  /// save player name
  _validatePlayerNameSummit() {
    Provider.of<NameProvider>(context, listen: false)
        .addPlayerName(value: playerNameController.text);
    var rng = Random();
    var k = rng.nextInt(10000);
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('playerName/$k');
    ref.set({
      "names": playerNameController.text,
    }).asStream();
  }
}
