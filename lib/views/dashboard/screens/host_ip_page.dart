import 'dart:developer';

import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/screens/coin_flip_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HostIpPage extends StatefulWidget {
  const HostIpPage({Key? key}) : super(key: key);

  @override
  State<HostIpPage> createState() => _HostIpPageState();
}

class _HostIpPageState extends State<HostIpPage> {
  TextEditingController hostIpController = TextEditingController();

  @override
  void initState() {
    getBegin();
    super.initState();
  }

  DatabaseReference getBegin() {
    setState(() {});
    print('Room/${hostIpController.text}/selectCard');
    print('object');
    print(
        'Room/${Provider.of<GameProvider>(context, listen: false).updatedRoomId}/selectCard');
    DatabaseReference refDb = FirebaseDatabase.instance.ref(
        'Room/${Provider.of<GameProvider>(context, listen: false).updatedRoomId}/selectCard');

    return refDb;
  }

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
            padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 20.sp),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white70.withOpacity(0.3), //New
                                blurRadius: 5.0,
                                spreadRadius: 5.0)
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              children: [
                                Container(
                                  height: 200.sp,
                                  width: 200.sp,
                                  padding: EdgeInsets.all(16.sp),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1d2671),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.sp))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Enter Host IP address and press begin button',
                                        style: AppTextStyles
                                            .instance.hostAndJoinName,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.sp),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: -15,
                                  child: RotationTransition(
                                    turns:
                                        const AlwaysStoppedAnimation(15 / 360),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(left: 90.sp),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 5),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              left: -15,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(15 / 360),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.only(right: 90.sp),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 5),
                                      shape: BoxShape.circle),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.sp),
                      Container(
                          width: 200.sp,
                          padding: EdgeInsets.fromLTRB(4.sp, 12.sp, 4.sp, 4.sp),
                          decoration: BoxDecoration(
                              color: const Color(0xff093028),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.sp))),
                          child: TextFormField(
                              controller: hostIpController,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.sp),
                              decoration: InputDecoration(
                                  fillColor: const Color(0xff237a57),
                                  filled: true,
                                  errorStyle: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.sp,
                                      color: const Color(0xffF15252)),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    borderSide: const BorderSide(
                                        color: Color(0xffF15252)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      borderSide: const BorderSide(
                                          color: Color(0xffD2D2D4), width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      borderSide: const BorderSide(
                                          color: Colors.black87, width: 1)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.sp),
                                      borderSide: const BorderSide(
                                          color: Color(0xffD2D2D4), width: 1)),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.sp, 15.sp, 0.sp, 0.sp),
                                  labelStyle: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.sp),
                                  hintStyle: GoogleFonts.openSans(
                                      fontSize: 16.sp,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                  hintText: 'Enter Host IP'))),
                      SizedBox(height: 20.sp),
                      GameStartButton(
                          text: 'Begin',
                          color: Colors.blue,
                          onPressed: () {
                            if (hostIpController.text == '') {
                              Fluttertoast.showToast(
                                  msg: "Please enter host ip",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return false;
                            } else {
                              GamePlayerModel joinGame = GamePlayerModel(
                                  name: Provider.of<NameProvider>(context,
                                          listen: false)
                                      .playerName,
                                  timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  playerCharacters: {
                                    '0': CreatePlayerModel(
                                      playerName: 'MS Dhoni',
                                      country: 'India',
                                      batAvg: '50.58',
                                      bowlAvg: '31.0',
                                      runs: '10773',
                                      topScore: '183',
                                      economyRate: '5.17',
                                      strikeRate: '87.56',
                                      wickets: '1',
                                    ),
                                    '1': CreatePlayerModel(
                                      playerName: 'R Jadeja',
                                      country: 'India',
                                      batAvg: '32.63',
                                      bowlAvg: '37.37',
                                      runs: '2447',
                                      topScore: '87',
                                      economyRate: '4.92',
                                      strikeRate: '86.53',
                                      wickets: '189',
                                    ),
                                    '2': CreatePlayerModel(
                                      playerName: 'Jasprit Bumrah',
                                      country: 'India',
                                      batAvg: '6.71',
                                      bowlAvg: '24.31',
                                      runs: '47',
                                      topScore: '14',
                                      economyRate: '4.64',
                                      strikeRate: '50.54',
                                      wickets: '121',
                                    ),
                                    '3': CreatePlayerModel(
                                      playerName: 'David Warner',
                                      country: 'Australia',
                                      batAvg: '44.83',
                                      bowlAvg: '0.0',
                                      runs: '6007',
                                      topScore: '179',
                                      economyRate: '8.0',
                                      strikeRate: '95.26',
                                      wickets: '0',
                                    ),
                                    '4': CreatePlayerModel(
                                      playerName: 'Mitchell Santner',
                                      country: 'New Zealand',
                                      batAvg: '28.36',
                                      bowlAvg: '38.59',
                                      runs: '1248',
                                      topScore: '67',
                                      economyRate: '4.87',
                                      strikeRate: '89.4',
                                      wickets: '90',
                                    ),
                                  });
                              Provider.of<GameProvider>(context, listen: false)
                                  .joinRoom(joinGame, hostIpController.text);
                              NavigationRoute().animationRoute(
                                  context,
                                  CoinFlipScreen(
                                      roomId: hostIpController.text));
                            }
                          }),
                      // StreamBuilder(
                      //   stream: getBegin().onValue,
                      //   builder: (context, snapShot) {
                      //     if (snapShot.data != null) {
                      //       return GameStartButton(
                      //           text: snapShot.data!.snapshot.value == true
                      //               ? "Let's Toss"
                      //               : 'Begin',
                      //           color: Colors.blue,
                      //           onPressed: () {
                      //             if (hostIpController.text == '') {
                      //               Fluttertoast.showToast(
                      //                   msg: "Please enter host ip",
                      //                   toastLength: Toast.LENGTH_SHORT,
                      //                   gravity: ToastGravity.BOTTOM,
                      //                   timeInSecForIosWeb: 1,
                      //                   backgroundColor: Colors.blueGrey,
                      //                   textColor: Colors.white,
                      //                   fontSize: 16.0);
                      //               return false;
                      //             } else {
                      //               GamePlayerModel joinGame = GamePlayerModel(
                      //                   name: Provider.of<NameProvider>(context,
                      //                           listen: false)
                      //                       .playerName,
                      //                   timestamp: DateTime.now()
                      //                       .millisecondsSinceEpoch,
                      //                   playerCharacters: {
                      //                     '0': CreatePlayerModel(
                      //                       playerName: 'MS Dhoni',
                      //                       country: 'India',
                      //                       batAvg: '50.58',
                      //                       bowlAvg: '31.0',
                      //                       runs: '10773',
                      //                       topScore: '183',
                      //                       economyRate: '5.17',
                      //                       strikeRate: '87.56',
                      //                       wickets: '1',
                      //                     ),
                      //                     '1': CreatePlayerModel(
                      //                       playerName: 'R Jadeja',
                      //                       country: 'India',
                      //                       batAvg: '32.63',
                      //                       bowlAvg: '37.37',
                      //                       runs: '2447',
                      //                       topScore: '87',
                      //                       economyRate: '4.92',
                      //                       strikeRate: '86.53',
                      //                       wickets: '189',
                      //                     ),
                      //                     '2': CreatePlayerModel(
                      //                       playerName: 'Jasprit Bumrah',
                      //                       country: 'India',
                      //                       batAvg: '6.71',
                      //                       bowlAvg: '24.31',
                      //                       runs: '47',
                      //                       topScore: '14',
                      //                       economyRate: '4.64',
                      //                       strikeRate: '50.54',
                      //                       wickets: '121',
                      //                     ),
                      //                     '3': CreatePlayerModel(
                      //                       playerName: 'David Warner',
                      //                       country: 'Australia',
                      //                       batAvg: '44.83',
                      //                       bowlAvg: '0.0',
                      //                       runs: '6007',
                      //                       topScore: '179',
                      //                       economyRate: '8.0',
                      //                       strikeRate: '95.26',
                      //                       wickets: '0',
                      //                     ),
                      //                     '4': CreatePlayerModel(
                      //                       playerName: 'Mitchell Santner',
                      //                       country: 'New Zealand',
                      //                       batAvg: '28.36',
                      //                       bowlAvg: '38.59',
                      //                       runs: '1248',
                      //                       topScore: '67',
                      //                       economyRate: '4.87',
                      //                       strikeRate: '89.4',
                      //                       wickets: '90',
                      //                     ),
                      //                   });
                      //               Provider.of<GameProvider>(context,
                      //                       listen: false)
                      //                   .joinRoom(
                      //                       joinGame, hostIpController.text);
                      //               if (snapShot.data!.snapshot.value == true) {
                      //                 NavigationRoute().animationRoute(
                      //                     context,
                      //                     CoinFlipScreen(
                      //                         roomId: hostIpController.text));
                      //               }
                      //             }
                      //           });
                      //     }
                      //     return const RefreshProgressIndicator();
                      //   },
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
  // else {
  //   log(Provider.of<GameProvider>(context, listen: false)
  //       .game
  //       .gameId
  //       .toString());
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10.sp))),
  //           clipBehavior: Clip.none,
  //           title: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text('Invalid Code', style: AppTextStyles.instance.popError),
  //               SizedBox(height: 4.sp),
  //               Text('Game does not exist',
  //                   style: AppTextStyles.instance.popError),
  //               SizedBox(height: 15.sp),
  //               HeadTailsButton(
  //                   text: 'Okay',
  //                   color: Colors.red,
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   })
  //             ],
  //           ),
  //         );
  //       });
  // }
}
