import 'dart:developer';
import 'package:delayed_display/delayed_display.dart';
import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
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
          timestamp: DateTime.now().millisecondsSinceEpoch);
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
  _createHostSummit() async {
    GameModel gameRoom =
        GameModel(hostId: FirebaseAuth.instance.currentUser!.uid, players: {
      FirebaseAuth.instance.currentUser!.uid: GamePlayerModel(
          name: Provider.of<NameProvider>(context, listen: false)
              .playerName
              .toString(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          playerCharacters: {
            '0': CreatePlayerModel(
              firstName: 'MS',
              lastName: 'Dhoni',
              country: 'India',
              matches: '350',
              batAvg: '50.58',
              runs: '10773',
              topScore: '183',
              hundreds: '10',
              fifties: '73',
              strikeRate: '87.56',
              wickets: '1',
            ),
            '1': CreatePlayerModel(
              firstName: 'Ravi',
              lastName: 'Jadeja',
              country: 'India',
              batAvg: '32.63',
              matches: '174',
              runs: '2447',
              topScore: '87',
              hundreds: '0',
              fifties: '13',
              strikeRate: '86.53',
              wickets: '189',
            ),
            '2': CreatePlayerModel(
              firstName: 'Jasprit',
              lastName: 'Bumrah',
              country: 'India',
              batAvg: '6.71',
              matches: '72',
              runs: '47',
              topScore: '14',
              hundreds: '0',
              fifties: '0',
              strikeRate: '50.54',
              wickets: '121',
            ),
            '3': CreatePlayerModel(
              firstName: 'David',
              lastName: 'Warner',
              country: 'Australia',
              batAvg: '44.83',
              matches: '142',
              hundreds: '19',
              fifties: '27',
              runs: '6007',
              topScore: '179',
              strikeRate: '95.26',
              wickets: '0',
            ),
            '4': CreatePlayerModel(
              firstName: 'Mitchell',
              lastName: 'Santner',
              country: 'New Zealand',
              batAvg: '28.36',
              matches: '93',
              runs: '1248',
              topScore: '67',
              hundreds: '0',
              fifties: '3',
              strikeRate: '89.4',
              wickets: '90',
            ),
          })
    });
    Provider.of<GameProvider>(context, listen: false).hostRoom(gameRoom);

    NavigationRoute().animationRoute(context, const PlayersDetailsPage());
  }
}
