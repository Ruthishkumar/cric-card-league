import 'dart:developer';

import 'package:delayed_display/delayed_display.dart';
import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/screens/coin_flip_page.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
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

  DatabaseReference getBegin() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref('Room');
    return refDb;
  }

  @override
  void initState() {
    getCardSelectData();
    super.initState();
  }

  getCardSelectData() {
    GameServices().joinSelectOfCard().asStream().listen((event) {
      event.onValue.listen((event) {
        log(event.snapshot.value.toString());
        log("Message");
        log(Provider.of<GameProvider>(context, listen: false).joinRoomId);
        log('**********JOINROOMID**********');
        if (event.snapshot.value == "15") {
          getJoinFifteenCards();
        } else if (event.snapshot.value == "25") {
          twentyFiveCardsPlayers();
        } else if (event.snapshot.value == "30") {
          thirtyCardsPlayers();
          setState(() {});
        }
        event.snapshot.value != null
            ? Future.delayed(const Duration(seconds: 3), () {
                NavigationRoute().animationRoute(
                    context, CoinFlipScreen(roomId: hostIpController.text));
              })
            : null;
        setState(() {});
      });
    });
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
                      StreamBuilder(
                        stream: getBegin().onValue,
                        builder: (context, snapShot) {
                          if (snapShot.data != null) {
                            var joinValidate = snapShot.data!.snapshot.value
                                as Map<dynamic, dynamic>;
                            return GameStartButton(
                                text: 'Begin',
                                color: Colors.blue,
                                onPressed: () {
                                  log(joinValidate['roomId'].toString());
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
                                  } else if (joinValidate['roomId'] ==
                                      hostIpController.text) {
                                    GamePlayerModel joinGame = GamePlayerModel(
                                        name: Provider.of<NameProvider>(context,
                                                listen: false)
                                            .playerName,
                                        timestamp: DateTime.now()
                                            .millisecondsSinceEpoch);
                                    Provider.of<GameProvider>(context,
                                            listen: false)
                                        .joinRoom(
                                            joinGame, hostIpController.text);
                                    Provider.of<GameProvider>(context,
                                            listen: false)
                                        .createJoinRoomId(
                                            value: hostIpController.text);
                                    WaitCardJoin status = WaitCardJoin(
                                        playerWaiting:
                                            hostIpController.text == ''
                                                ? false
                                                : true);
                                    GameServices().waitingCardSelect(
                                        waitCardJoin: status);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.sp))),
                                            clipBehavior: Clip.none,
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('Invalid Code',
                                                    style: AppTextStyles
                                                        .instance.popError),
                                                SizedBox(height: 4.sp),
                                                Text('Game does not exist',
                                                    style: AppTextStyles
                                                        .instance.popError),
                                                SizedBox(height: 15.sp),
                                                HeadTailsButton(
                                                    text: 'Okay',
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                              ],
                                            ),
                                          );
                                        });
                                  }
                                });
                          }
                          return const RefreshProgressIndicator();
                        },
                      ),
                      SizedBox(height: 20.sp),
                      StreamBuilder(
                          stream: getBegin().onValue,
                          builder: (context, snapShot) {
                            if (snapShot.data != null) {
                              var getStatus = snapShot.data!.snapshot.value
                                  as Map<dynamic, dynamic>;
                              return getStatus['playerWaiting'] == null
                                  ? Container()
                                  : DelayedDisplay(
                                      slidingBeginOffset:
                                          const Offset(0.0, 0.35),
                                      delay: const Duration(milliseconds: 1),
                                      child: Container(
                                        width: 200.sp,
                                        padding: EdgeInsets.all(16.sp),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.sp)),
                                            color: const Color(0xff243b55),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Text(
                                          getStatus['playerWaiting'] == true
                                              ? 'Please wait your Opponent has select the card'
                                              : '',
                                          style:
                                              AppTextStyles.instance.tossHeader,
                                        ),
                                      ),
                                    );
                            }
                            return Container();
                          })
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

  /// Join fifteen card
  getJoinFifteenCards() {
    GamePlayerAdd gamePlayerAdd = GamePlayerAdd(playerCharacters: {
      '0': CreatePlayerModel(
          firstName: 'Martin',
          lastName: 'Guptil',
          country: 'New Zealand',
          batAvg: '41.5',
          matches: '198',
          runs: '7346',
          topScore: '237',
          hundreds: '18',
          fifties: '39',
          strikeRate: '87.31',
          wickets: '4',
          bowlAvg: '24.5',
          ecoRate: '5.39'),
      '1': CreatePlayerModel(
          firstName: 'Rohit',
          lastName: 'Sharma',
          country: 'India',
          batAvg: '48.64',
          matches: '243',
          hundreds: '30',
          fifties: '48',
          runs: '9825',
          topScore: '264',
          strikeRate: '90.02',
          wickets: '8',
          bowlAvg: '64.38',
          ecoRate: '5.21'),
      '2': CreatePlayerModel(
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
          bowlAvg: '31.0',
          ecoRate: '5.17'),
      '3': CreatePlayerModel(
          firstName: 'AB de',
          lastName: 'Villiers',
          country: 'West Indies',
          batAvg: '53.5',
          matches: '228',
          hundreds: '25',
          fifties: '53',
          runs: '9577',
          topScore: '176',
          strikeRate: '101.1',
          wickets: '7',
          bowlAvg: '28.86',
          ecoRate: '6.31'),
      '4': CreatePlayerModel(
          firstName: 'Ben',
          lastName: 'Stokes',
          country: 'England',
          batAvg: '38.99',
          runs: '2924',
          topScore: '102',
          matches: '105',
          hundreds: '3',
          fifties: '21',
          strikeRate: '95.09',
          wickets: '74',
          bowlAvg: '42.39',
          ecoRate: '6.05'),
      '5': CreatePlayerModel(
          firstName: 'Ravindra',
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
          bowlAvg: '37.39',
          ecoRate: '4.91'),
      '6': CreatePlayerModel(
          firstName: 'Hashim',
          lastName: 'Amla',
          country: 'South Africa',
          batAvg: '49.47',
          matches: '181',
          runs: '8113',
          topScore: '159',
          hundreds: '27',
          fifties: '39',
          strikeRate: '88.39',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '7': CreatePlayerModel(
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
          bowlAvg: '38.59',
          ecoRate: '4.87'),
      '8': CreatePlayerModel(
          firstName: 'Marnus',
          lastName: 'Labuschagne',
          country: 'Australia',
          batAvg: '31.37',
          matches: '30',
          runs: '847',
          topScore: '108',
          hundreds: '1',
          fifties: '6',
          strikeRate: '83.2',
          wickets: '2',
          bowlAvg: '98.5',
          ecoRate: '6.39'),
      '9': CreatePlayerModel(
          firstName: 'Kagiso',
          lastName: 'Rabada',
          country: 'South Africa',
          batAvg: '15.85',
          matches: '89',
          runs: '317',
          topScore: '31',
          hundreds: '0',
          fifties: '0',
          strikeRate: '82.77',
          wickets: '137',
          bowlAvg: '27.95',
          ecoRate: '5.02'),
      '10': CreatePlayerModel(
          firstName: 'Ish',
          lastName: 'Sodhi',
          country: 'New Zealand',
          batAvg: '9.62',
          matches: '41',
          runs: '154',
          topScore: '25',
          hundreds: '0',
          fifties: '0',
          strikeRate: '70.64',
          wickets: '51',
          bowlAvg: '35.18',
          ecoRate: '5.42'),
      '11': CreatePlayerModel(
          firstName: 'Quinton',
          lastName: 'de Kock',
          country: 'South Africa',
          batAvg: '44.86',
          matches: '140',
          runs: '5966',
          topScore: '178',
          hundreds: '17',
          fifties: '29',
          strikeRate: '96.09',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '12': CreatePlayerModel(
          firstName: 'Jos',
          lastName: 'Buttler',
          country: 'England',
          batAvg: '41.49',
          matches: '165',
          runs: '4647',
          topScore: '162',
          hundreds: '11',
          fifties: '24',
          strikeRate: '117.94',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '13': CreatePlayerModel(
          firstName: 'Krunal',
          lastName: 'Pandya',
          country: 'India',
          batAvg: '65.0',
          matches: '5',
          runs: '130',
          topScore: '58',
          hundreds: '0',
          fifties: '1',
          strikeRate: '101.56',
          wickets: '15',
          bowlAvg: '111.5',
          ecoRate: '5.87'),
      '14': CreatePlayerModel(
          firstName: 'Tom',
          lastName: 'Latham',
          country: 'New Zealand',
          batAvg: '34.46',
          matches: '125',
          runs: '3480',
          topScore: '145',
          hundreds: '7',
          fifties: '18',
          strikeRate: '84.92',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
    });
    GameServices().createPlayerCharacters(
        roomId: Provider.of<GameProvider>(context, listen: false).joinRoomId,
        gamePlayerAdd: gamePlayerAdd);
  }

  /// twenty five cara join
  twentyFiveCardsPlayers() {
    GamePlayerAdd gamePlayerAdd = GamePlayerAdd(playerCharacters: {
      '0': CreatePlayerModel(
          firstName: 'Martin',
          lastName: 'Guptil',
          country: 'New Zealand',
          batAvg: '41.5',
          matches: '198',
          runs: '7346',
          topScore: '237',
          hundreds: '18',
          fifties: '39',
          strikeRate: '87.31',
          wickets: '4',
          bowlAvg: '24.5',
          ecoRate: '5.39'),
      '1': CreatePlayerModel(
          firstName: 'Rohit',
          lastName: 'Sharma',
          country: 'India',
          batAvg: '48.64',
          matches: '243',
          hundreds: '30',
          fifties: '48',
          runs: '9825',
          topScore: '264',
          strikeRate: '90.02',
          wickets: '8',
          bowlAvg: '64.38',
          ecoRate: '5.21'),
      '2': CreatePlayerModel(
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
          bowlAvg: '31.0',
          ecoRate: '5.17'),
      '3': CreatePlayerModel(
          firstName: 'AB de',
          lastName: 'Villiers',
          country: 'West Indies',
          batAvg: '53.5',
          matches: '228',
          hundreds: '25',
          fifties: '53',
          runs: '9577',
          topScore: '176',
          strikeRate: '101.1',
          wickets: '7',
          bowlAvg: '28.86',
          ecoRate: '6.31'),
      '4': CreatePlayerModel(
          firstName: 'Ben',
          lastName: 'Stokes',
          country: 'England',
          batAvg: '38.99',
          runs: '2924',
          topScore: '102',
          matches: '105',
          hundreds: '3',
          fifties: '21',
          strikeRate: '95.09',
          wickets: '74',
          bowlAvg: '42.39',
          ecoRate: '6.05'),
      '5': CreatePlayerModel(
          firstName: 'Ravindra',
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
          bowlAvg: '37.39',
          ecoRate: '4.91'),
      '6': CreatePlayerModel(
          firstName: 'Hashim',
          lastName: 'Amla',
          country: 'South Africa',
          batAvg: '49.47',
          matches: '181',
          runs: '8113',
          topScore: '159',
          hundreds: '27',
          fifties: '39',
          strikeRate: '88.39',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '7': CreatePlayerModel(
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
          bowlAvg: '38.59',
          ecoRate: '4.87'),
      '8': CreatePlayerModel(
          firstName: 'Marnus',
          lastName: 'Labuschagne',
          country: 'Australia',
          batAvg: '31.37',
          matches: '30',
          runs: '847',
          topScore: '108',
          hundreds: '1',
          fifties: '6',
          strikeRate: '83.2',
          wickets: '2',
          bowlAvg: '98.5',
          ecoRate: '6.39'),
      '9': CreatePlayerModel(
          firstName: 'Kagiso',
          lastName: 'Rabada',
          country: 'South Africa',
          batAvg: '15.85',
          matches: '89',
          runs: '317',
          topScore: '31',
          hundreds: '0',
          fifties: '0',
          strikeRate: '82.77',
          wickets: '137',
          bowlAvg: '27.95',
          ecoRate: '5.02'),
      '10': CreatePlayerModel(
          firstName: 'Ish',
          lastName: 'Sodhi',
          country: 'New Zealand',
          batAvg: '9.62',
          matches: '41',
          runs: '154',
          topScore: '25',
          hundreds: '0',
          fifties: '0',
          strikeRate: '70.64',
          wickets: '51',
          bowlAvg: '35.18',
          ecoRate: '5.42'),
      '11': CreatePlayerModel(
          firstName: 'Quinton',
          lastName: 'de Kock',
          country: 'South Africa',
          batAvg: '44.86',
          matches: '140',
          runs: '5966',
          topScore: '178',
          hundreds: '17',
          fifties: '29',
          strikeRate: '96.09',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '12': CreatePlayerModel(
          firstName: 'Jos',
          lastName: 'Buttler',
          country: 'England',
          batAvg: '41.49',
          matches: '165',
          runs: '4647',
          topScore: '162',
          hundreds: '11',
          fifties: '24',
          strikeRate: '117.94',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '13': CreatePlayerModel(
          firstName: 'Krunal',
          lastName: 'Pandya',
          country: 'India',
          batAvg: '65.0',
          matches: '5',
          runs: '130',
          topScore: '58',
          hundreds: '0',
          fifties: '1',
          strikeRate: '101.56',
          wickets: '15',
          bowlAvg: '111.5',
          ecoRate: '5.87'),
      '14': CreatePlayerModel(
          firstName: 'Tom',
          lastName: 'Latham',
          country: 'New Zealand',
          batAvg: '34.46',
          matches: '125',
          runs: '3480',
          topScore: '145',
          hundreds: '7',
          fifties: '18',
          strikeRate: '84.92',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '15': CreatePlayerModel(
          firstName: 'Shreyas',
          lastName: 'Iyer',
          country: 'India',
          batAvg: '46.6',
          matches: '42',
          runs: '1631',
          topScore: '113',
          hundreds: '2',
          fifties: '14',
          strikeRate: '96.51',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '6.32'),
      '16': CreatePlayerModel(
          firstName: 'Usman',
          lastName: 'Khawaja',
          country: 'Australia',
          batAvg: '42.0',
          matches: '40',
          runs: '1554',
          topScore: '104',
          hundreds: '2',
          fifties: '12',
          strikeRate: '84.09',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '17': CreatePlayerModel(
          firstName: 'Jonny',
          lastName: 'Bairstow',
          country: 'England',
          batAvg: '46.59',
          matches: '95',
          runs: '3634',
          topScore: '141',
          hundreds: '11',
          fifties: '15',
          strikeRate: '104.13',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '18': CreatePlayerModel(
          firstName: 'Rashid',
          lastName: 'Khan',
          country: 'Afghanistan',
          batAvg: '20.25',
          matches: '86',
          runs: '1134',
          topScore: '60',
          hundreds: '0',
          fifties: '5',
          strikeRate: '105.29',
          wickets: '34',
          bowlAvg: '18.55',
          ecoRate: '4.17'),
      '19': CreatePlayerModel(
          firstName: 'Shakib',
          lastName: 'Al Hasan',
          country: 'Bangladesh',
          batAvg: '37.69',
          matches: '230',
          runs: '7086',
          topScore: '134',
          hundreds: '9',
          fifties: '18',
          strikeRate: '82.59',
          wickets: '301',
          bowlAvg: '28.94',
          ecoRate: '4.45'),
      '20': CreatePlayerModel(
          firstName: 'Mahmudullah',
          lastName: '',
          country: 'Bangladesh',
          batAvg: '35.36',
          matches: '218',
          runs: '4950',
          topScore: '128',
          hundreds: '3',
          fifties: '27',
          strikeRate: '76.14',
          wickets: '82',
          bowlAvg: '45.28',
          ecoRate: '5.21'),
      '21': CreatePlayerModel(
          firstName: 'Fakhar',
          lastName: 'Zaman',
          country: 'Pakistan',
          batAvg: '45.66',
          matches: '65',
          runs: '2785',
          topScore: '210',
          hundreds: '8',
          fifties: '15',
          strikeRate: '92.52',
          wickets: '1',
          bowlAvg: '111.0',
          ecoRate: '4.93'),
      '22': CreatePlayerModel(
          firstName: 'Graeme',
          lastName: 'Smith',
          country: 'South Africa',
          batAvg: '37.78',
          matches: '197',
          runs: '6989',
          topScore: '141',
          hundreds: '10',
          fifties: '47',
          strikeRate: '80.82',
          wickets: '18',
          bowlAvg: '52.83',
          ecoRate: '5.56'),
      '23': CreatePlayerModel(
          firstName: 'Evin',
          lastName: 'Lewis',
          country: 'West Indies',
          batAvg: '36.22',
          matches: '57',
          runs: '1847',
          topScore: '176',
          hundreds: '4',
          fifties: '10',
          strikeRate: '82.97',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '24': CreatePlayerModel(
          firstName: 'Virender',
          lastName: 'Sehwag',
          country: 'India',
          batAvg: '35.06',
          matches: '251',
          runs: '8273',
          topScore: '219',
          hundreds: '15',
          fifties: '38',
          strikeRate: '104.34',
          wickets: '96',
          bowlAvg: '40.14',
          ecoRate: '5.26'),
    });
    GameServices().createPlayerCharacters(
        roomId: Provider.of<GameProvider>(context, listen: false).joinRoomId,
        gamePlayerAdd: gamePlayerAdd);
  }

  /// thirty card players join
  thirtyCardsPlayers() {
    GamePlayerAdd gamePlayerAdd = GamePlayerAdd(playerCharacters: {
      '0': CreatePlayerModel(
          firstName: 'Martin',
          lastName: 'Guptil',
          country: 'New Zealand',
          batAvg: '41.5',
          matches: '198',
          runs: '7346',
          topScore: '237',
          hundreds: '18',
          fifties: '39',
          strikeRate: '87.31',
          wickets: '4',
          bowlAvg: '24.5',
          ecoRate: '5.39'),
      '1': CreatePlayerModel(
          firstName: 'Rohit',
          lastName: 'Sharma',
          country: 'India',
          batAvg: '48.64',
          matches: '243',
          hundreds: '30',
          fifties: '48',
          runs: '9825',
          topScore: '264',
          strikeRate: '90.02',
          wickets: '8',
          bowlAvg: '64.38',
          ecoRate: '5.21'),
      '2': CreatePlayerModel(
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
          bowlAvg: '31.0',
          ecoRate: '5.17'),
      '3': CreatePlayerModel(
          firstName: 'AB de',
          lastName: 'Villiers',
          country: 'West Indies',
          batAvg: '53.5',
          matches: '228',
          hundreds: '25',
          fifties: '53',
          runs: '9577',
          topScore: '176',
          strikeRate: '101.1',
          wickets: '7',
          bowlAvg: '28.86',
          ecoRate: '6.31'),
      '4': CreatePlayerModel(
          firstName: 'Ben',
          lastName: 'Stokes',
          country: 'England',
          batAvg: '38.99',
          runs: '2924',
          topScore: '102',
          matches: '105',
          hundreds: '3',
          fifties: '21',
          strikeRate: '95.09',
          wickets: '74',
          bowlAvg: '42.39',
          ecoRate: '6.05'),
      '5': CreatePlayerModel(
          firstName: 'Ravindra',
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
          bowlAvg: '37.39',
          ecoRate: '4.91'),
      '6': CreatePlayerModel(
          firstName: 'Hashim',
          lastName: 'Amla',
          country: 'South Africa',
          batAvg: '49.47',
          matches: '181',
          runs: '8113',
          topScore: '159',
          hundreds: '27',
          fifties: '39',
          strikeRate: '88.39',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '7': CreatePlayerModel(
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
          bowlAvg: '38.59',
          ecoRate: '4.87'),
      '8': CreatePlayerModel(
          firstName: 'Marnus',
          lastName: 'Labuschagne',
          country: 'Australia',
          batAvg: '31.37',
          matches: '30',
          runs: '847',
          topScore: '108',
          hundreds: '1',
          fifties: '6',
          strikeRate: '83.2',
          wickets: '2',
          bowlAvg: '98.5',
          ecoRate: '6.39'),
      '9': CreatePlayerModel(
          firstName: 'Kagiso',
          lastName: 'Rabada',
          country: 'South Africa',
          batAvg: '15.85',
          matches: '89',
          runs: '317',
          topScore: '31',
          hundreds: '0',
          fifties: '0',
          strikeRate: '82.77',
          wickets: '137',
          bowlAvg: '27.95',
          ecoRate: '5.02'),
      '10': CreatePlayerModel(
          firstName: 'Ish',
          lastName: 'Sodhi',
          country: 'New Zealand',
          batAvg: '9.62',
          matches: '41',
          runs: '154',
          topScore: '25',
          hundreds: '0',
          fifties: '0',
          strikeRate: '70.64',
          wickets: '51',
          bowlAvg: '35.18',
          ecoRate: '5.42'),
      '11': CreatePlayerModel(
          firstName: 'Quinton',
          lastName: 'de Kock',
          country: 'South Africa',
          batAvg: '44.86',
          matches: '140',
          runs: '5966',
          topScore: '178',
          hundreds: '17',
          fifties: '29',
          strikeRate: '96.09',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '12': CreatePlayerModel(
          firstName: 'Jos',
          lastName: 'Buttler',
          country: 'England',
          batAvg: '41.49',
          matches: '165',
          runs: '4647',
          topScore: '162',
          hundreds: '11',
          fifties: '24',
          strikeRate: '117.94',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '13': CreatePlayerModel(
          firstName: 'Krunal',
          lastName: 'Pandya',
          country: 'India',
          batAvg: '65.0',
          matches: '5',
          runs: '130',
          topScore: '58',
          hundreds: '0',
          fifties: '1',
          strikeRate: '101.56',
          wickets: '15',
          bowlAvg: '111.5',
          ecoRate: '5.87'),
      '14': CreatePlayerModel(
          firstName: 'Tom',
          lastName: 'Latham',
          country: 'New Zealand',
          batAvg: '34.46',
          matches: '125',
          runs: '3480',
          topScore: '145',
          hundreds: '7',
          fifties: '18',
          strikeRate: '84.92',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '15': CreatePlayerModel(
          firstName: 'Shreyas',
          lastName: 'Iyer',
          country: 'India',
          batAvg: '46.6',
          matches: '42',
          runs: '1631',
          topScore: '113',
          hundreds: '2',
          fifties: '14',
          strikeRate: '96.51',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '6.32'),
      '16': CreatePlayerModel(
          firstName: 'Usman',
          lastName: 'Khawaja',
          country: 'Australia',
          batAvg: '42.0',
          matches: '40',
          runs: '1554',
          topScore: '104',
          hundreds: '2',
          fifties: '12',
          strikeRate: '84.09',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '17': CreatePlayerModel(
          firstName: 'Jonny',
          lastName: 'Bairstow',
          country: 'England',
          batAvg: '46.59',
          matches: '95',
          runs: '3634',
          topScore: '141',
          hundreds: '11',
          fifties: '15',
          strikeRate: '104.13',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '18': CreatePlayerModel(
          firstName: 'Rashid',
          lastName: 'Khan',
          country: 'Afghanistan',
          batAvg: '20.25',
          matches: '86',
          runs: '1134',
          topScore: '60',
          hundreds: '0',
          fifties: '5',
          strikeRate: '105.29',
          wickets: '34',
          bowlAvg: '18.55',
          ecoRate: '4.17'),
      '19': CreatePlayerModel(
          firstName: 'Shakib',
          lastName: 'Al Hasan',
          country: 'Bangladesh',
          batAvg: '37.69',
          matches: '230',
          runs: '7086',
          topScore: '134',
          hundreds: '9',
          fifties: '18',
          strikeRate: '82.59',
          wickets: '301',
          bowlAvg: '28.94',
          ecoRate: '4.45'),
      '20': CreatePlayerModel(
          firstName: 'Mahmudullah',
          lastName: '',
          country: 'Bangladesh',
          batAvg: '35.36',
          matches: '218',
          runs: '4950',
          topScore: '128',
          hundreds: '3',
          fifties: '27',
          strikeRate: '76.14',
          wickets: '82',
          bowlAvg: '45.28',
          ecoRate: '5.21'),
      '21': CreatePlayerModel(
          firstName: 'Fakhar',
          lastName: 'Zaman',
          country: 'Pakistan',
          batAvg: '45.66',
          matches: '65',
          runs: '2785',
          topScore: '210',
          hundreds: '8',
          fifties: '15',
          strikeRate: '92.52',
          wickets: '1',
          bowlAvg: '111.0',
          ecoRate: '4.93'),
      '22': CreatePlayerModel(
          firstName: 'Graeme',
          lastName: 'Smith',
          country: 'South Africa',
          batAvg: '37.78',
          matches: '197',
          runs: '6989',
          topScore: '141',
          hundreds: '10',
          fifties: '47',
          strikeRate: '80.82',
          wickets: '18',
          bowlAvg: '52.83',
          ecoRate: '5.56'),
      '23': CreatePlayerModel(
          firstName: 'Evin',
          lastName: 'Lewis',
          country: 'West Indies',
          batAvg: '36.22',
          matches: '57',
          runs: '1847',
          topScore: '176',
          hundreds: '4',
          fifties: '10',
          strikeRate: '82.97',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '24': CreatePlayerModel(
          firstName: 'Virender',
          lastName: 'Sehwag',
          country: 'India',
          batAvg: '35.06',
          matches: '251',
          runs: '8273',
          topScore: '219',
          hundreds: '15',
          fifties: '38',
          strikeRate: '104.34',
          wickets: '96',
          bowlAvg: '40.14',
          ecoRate: '5.26'),
      '25': CreatePlayerModel(
          firstName: 'Shane',
          lastName: 'Watson',
          country: 'Australia',
          batAvg: '40.54',
          matches: '190',
          runs: '5757',
          topScore: '185',
          hundreds: '9',
          fifties: '33',
          strikeRate: '90.45',
          wickets: '75',
          bowlAvg: '31.8',
          ecoRate: '4.96'),
      '26': CreatePlayerModel(
        firstName: 'Lasith',
        lastName: 'Malinga',
        country: 'Sri Lanka',
        batAvg: '6.83',
        matches: '226',
        runs: '567',
        topScore: '56',
        hundreds: '0',
        fifties: '1',
        strikeRate: '74.51',
        wickets: '338',
        bowlAvg: '28.87',
        ecoRate: '5.35',
      ),
      '27': CreatePlayerModel(
          firstName: 'Shaheen',
          lastName: 'Afridi',
          country: 'Pakistan',
          batAvg: '17.0',
          matches: '32',
          runs: '102',
          topScore: '19',
          hundreds: '0',
          fifties: '0',
          strikeRate: '68.46',
          wickets: '62',
          bowlAvg: '25.74',
          ecoRate: '4.25'),
      '28': CreatePlayerModel(
          firstName: 'Imran',
          lastName: 'Tahir',
          country: 'South Africa',
          batAvg: '7.85',
          matches: '107',
          runs: '157',
          topScore: '29',
          hundreds: '0',
          fifties: '0',
          strikeRate: '69.78',
          wickets: '173',
          bowlAvg: '23.87',
          ecoRate: '5.51'),
      '29': CreatePlayerModel(
          firstName: 'Mohammad',
          lastName: 'Nabi',
          country: 'Afghanistan',
          batAvg: '27.12',
          matches: '136',
          runs: '2956',
          topScore: '116',
          hundreds: '1',
          fifties: '15',
          strikeRate: '85.14',
          wickets: '144',
          bowlAvg: '32.14',
          ecoRate: '4.29'),
    });
    GameServices().createPlayerCharacters(
        roomId: Provider.of<GameProvider>(context, listen: false).joinRoomId,
        gamePlayerAdd: gamePlayerAdd);
  }
}
