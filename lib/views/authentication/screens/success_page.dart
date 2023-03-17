import 'dart:developer';
import 'package:delayed_display/delayed_display.dart';
import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/screens/host_ip_page.dart';
import 'package:ds_game/views/dashboard/screens/players_details_page.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_input_text_outline.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
    getStatusChecking();
    super.initState();
  }

  bool userStatus = false;

  getStatusChecking() async {
    userStatus = await StorageServices().getUserActive();
    log(userStatus.toString());
    setState(() {});
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
            DelayedDisplay(
              slidingBeginOffset: const Offset(-1, 0),
              delay: const Duration(microseconds: 1),
              child: SizedBox(
                width: 250.sp,
                child: AppInputTextOutline(
                    hintTextStyle: focusNameNode.hasFocus
                        ? GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)
                        : GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                    hintFontStyle: focusNameNode.hasFocus
                        ? GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)
                        : GoogleFonts.openSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                    focusNode: focusNameNode,
                    fillColor: focusNameNode.hasFocus
                        ? Colors.white
                        : Colors.white54.withOpacity(0.3),
                    inputController: playerNameController,
                    hintText: 'Enter Your Nick Name'),
              ),
            ),
            SizedBox(height: 30.sp),
            DelayedDisplay(
              slidingBeginOffset: const Offset(1, -1),
              delay: const Duration(microseconds: 1),
              child: HostingButton(
                text: 'OK',
                color: const Color(0xff12c2e9),
                onPressed: () {
                  _validatePlayerNameSummit();
                },
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
              DelayedDisplay(
                slidingBeginOffset: const Offset(-1, 0),
                delay: const Duration(microseconds: 1),
                child: HostingButton(
                  text: 'Host'.toUpperCase(),
                  color: Colors.green,
                  onPressed: _createHostSummit,
                ),
              ),
              SizedBox(height: 30.sp),
              DelayedDisplay(
                slidingBeginOffset: const Offset(1, -1),
                delay: const Duration(milliseconds: 1),
                child: HostingButton(
                  text: 'Join'.toUpperCase(),
                  color: const Color(0xff12c2e9),
                  onPressed: () {
                    NavigationRoute()
                        .animationRoute(context, const HostIpPage());
                  },
                ),
              ),
            ],
          ),
        ));
  }

  /// save player name
  _validatePlayerNameSummit() {
    if (validate()) {
      setState(() {
        isVisible = !isVisible;
      });
      GamePlayerModel createUser = GamePlayerModel(
          name: playerNameController.text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          createPlayerModel: {
            '0': CreatePlayerModel(
              playerName: 'Virat Kohli',
              country: 'India',
              batAvg: '57.7',
              bowlAvg: '166.25',
              runs: '12809',
              topScore: '183',
              economyRate: '6.22',
              strikeRate: '93.77',
              wickets: '4',
            ),
            '1': CreatePlayerModel(
              playerName: 'Ben Stokes',
              country: 'England',
              batAvg: '38.99',
              bowlAvg: '42.39',
              runs: '2924',
              topScore: '102',
              economyRate: '6.05',
              strikeRate: '95.09',
              wickets: '74',
            ),
            '2': CreatePlayerModel(
                playerName: 'Adam Zampa',
                country: 'Australia',
                batAvg: '9.36',
                bowlAvg: '28.67',
                runs: '206',
                topScore: '36',
                economyRate: '5.44',
                strikeRate: '62.05',
                wickets: '127	'),
            '3': CreatePlayerModel(
                playerName: 'Martin Guptil',
                country: 'New Zealand',
                batAvg: '41.5',
                bowlAvg: '24.5',
                runs: '7346',
                topScore: '237',
                economyRate: '5.39',
                strikeRate: '87.31',
                wickets: '4'),
            '4': CreatePlayerModel(
                playerName: 'M Siraj',
                country: 'India',
                batAvg: '6.75',
                bowlAvg: '20.76',
                runs: '27',
                topScore: '9',
                economyRate: '4.62',
                strikeRate: '48.21',
                wickets: '38'),
          });
      log('PlayersList');
      GameServices().createUserGameService(gamePlayerModel: createUser);
      Provider.of<NameProvider>(context, listen: false)
          .addPlayerName(value: playerNameController.text);
    }
  }

  bool validate() {
    if (playerNameController.text == '') {
      Fluttertoast.showToast(
          msg: "Enter Your Name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else {
      return true;
    }
  }

  /// host summit
  _createHostSummit() {
    GameModel gameRoom =
        GameModel(hostId: FirebaseAuth.instance.currentUser!.uid, players: {
      FirebaseAuth.instance.currentUser!.uid: GamePlayerModel(
          name: Provider.of<NameProvider>(context, listen: false)
              .playerName
              .toString(),
          timestamp: DateTime.now().millisecondsSinceEpoch)
    });
    Provider.of<GameProvider>(context, listen: false).hostRoom(gameRoom);
    Provider.of<GameProvider>(context, listen: false)
        .createRoom(gameRoom.roomId.toString());
    setState(() {
      log(Provider.of<GameProvider>(context, listen: false).roomId.toString());
      log('message');
    });

    NavigationRoute().animationRoute(context, const PlayersDetailsPage());
  }
}
