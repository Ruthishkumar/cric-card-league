import 'dart:developer';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/screens/coin_flip_page.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlayersDetailsPage extends StatefulWidget {
  const PlayersDetailsPage({Key? key}) : super(key: key);

  @override
  State<PlayersDetailsPage> createState() => _PlayersDetailsPageState();
}

class _PlayersDetailsPageState extends State<PlayersDetailsPage> {
  final List<String> cardItems = [
    '5',
    '10',
    '15',
    '20',
  ];

  DatabaseReference getCardSelect() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref(
        'Room/${Provider.of<GameProvider>(context, listen: false).roomId}/players');
    return refDb;
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    var deckCardsTotal = [
      {'cardValue': '15', 'cardId': 0},
      {'cardValue': '25', 'cardId': 1},
      {'cardValue': '30', 'cardId': 2},
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
              padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 20.sp),
              child: Consumer<GameProvider>(
                builder: (context, gameData, child) {
                  return Column(
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
                                        Provider.of<NameProvider>(context,
                                                listen: false)
                                            .playerName,
                                        style: AppTextStyles
                                            .instance.hostAndJoinName,
                                      ),
                                      SizedBox(height: 5.sp),
                                      Text(
                                        '(You)',
                                        style: AppTextStyles
                                            .instance.hostAndJoinName,
                                      ),
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
                      Consumer<GameProvider>(builder: (context, ip, child) {
                        log(ip.roomId);
                        log('ROOMID');
                        return Column(
                          children: [
                            Container(
                              width: 200.sp,
                              padding:
                                  EdgeInsets.fromLTRB(4.sp, 12.sp, 4.sp, 4.sp),
                              decoration: BoxDecoration(
                                  color: const Color(0xff093028),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.sp))),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                    4.sp, 10.sp, 4.sp, 4.sp),
                                padding: EdgeInsets.fromLTRB(
                                    4.sp, 12.sp, 4.sp, 4.sp),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.sp)),
                                    color: const Color(0xff237a57)),
                                child: Center(
                                  child: Text(
                                    'Your IP: ${ip.roomId}',
                                    style: AppTextStyles.instance.ipAddress,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.sp),
                            ShareIdButton(
                              text: 'Click To Share Id',
                              color: Colors.blue,
                              onPressed: () async {
                                await FlutterShare.share(
                                    title: 'Cric Card League',
                                    text: '',
                                    linkUrl: ip.roomId,
                                    chooserTitle: 'Cric Card League');
                              },
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 20.sp),
                      StreamBuilder(
                          stream: getCardSelect().onValue,
                          builder: (context, snapShot) {
                            if (snapShot.data != null) {
                              var data = snapShot.data!.snapshot.value
                                  as Map<dynamic, dynamic>;
                              return data.entries.length > 1
                                  ? Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/ribbon_green.png',
                                              height: 150,
                                            ),
                                            Text(
                                              'Select deck of cards',
                                              style: GoogleFonts.prompt(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (int i = 0;
                                                i < deckCardsTotal.length;
                                                i++)
                                              _cardDetails(deckCardsTotal[i]),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(
                                      width: 190.sp,
                                      padding: EdgeInsets.all(10.sp),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12
                                                    .withOpacity(0.3), //New
                                                blurRadius: 5.0,
                                                spreadRadius: 5.0)
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.sp)),
                                          color: Colors.white),
                                      child: Center(
                                        child: AnimatedTextKit(
                                          repeatForever: true,
                                          isRepeatingAnimation: true,
                                          animatedTexts: [
                                            TyperAnimatedText(
                                                'Waiting for players to join'),
                                            ScaleAnimatedText('Loading'),
                                          ],
                                        ),
                                      ),
                                    );
                            }
                            return const CircularProgressIndicator();
                          }),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int selectCardValue = -1;

  String selectCardNumbers = "";

  getTotalPoint() {
    if (selectCardValue == 0) {
      return '500';
    } else if (selectCardValue == 1) {
      return '1000';
    } else {
      return '1500';
    }
  }

  _cardDetails(options) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectCardValue = options['cardId'];
          selectCardNumbers = options['cardValue'];
          NavigationRoute().animationRoute(
              context,
              const CoinFlipScreen(
                roomId: '',
              ));
          Provider.of<NameProvider>(context, listen: false)
              .addCards(value: selectCardValue);
          Provider.of<NameProvider>(context, listen: false)
              .cardTotalValue(value: selectCardNumbers);
        });
        SelectCardModel selectCardModel = SelectCardModel(
            selectCard: selectCardValue != -1 ? true : false,
            totalCards: selectCardNumbers,
            totalPoints: getTotalPoint());
        GameServices().selectCard(
            roomId: Provider.of<GameProvider>(context, listen: false).roomId,
            selectCardModel: selectCardModel);
        if (selectCardValue == 0) {
          fifteenCardPlayers();
        } else if (selectCardValue == 1) {
          twentyFiveCardPlayers();
        } else if (selectCardValue == 2) {
          thirtyCardPlayers();
        }
      },
      child: Stack(
        children: [
          RotationTransition(
            turns: const AlwaysStoppedAnimation(12 / 360),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: const Color(0xff243b55),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 5)
                  ],
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(8.sp))),
            ),
          ),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: const Color(0xff243b55),
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(8.sp))),
            child: Center(
                child: Text(options['cardValue'],
                    style: GoogleFonts.prompt(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500))),
          ),
        ],
      ),
    );
  }

  /// fifteen card players
  fifteenCardPlayers() {
    GamePlayerAdd gamePlayerAdd = GamePlayerAdd(playerCharacters: {
      '0': CreatePlayerModel(
          firstName: 'Virat',
          lastName: 'Kohli',
          country: 'India',
          batAvg: '57.7',
          matches: '274',
          runs: '12809',
          topScore: '183',
          hundreds: '46',
          fifties: '65',
          strikeRate: '93.77',
          wickets: '4',
          bowlAvg: '166.25',
          ecoRate: '6.22'),
      '1': CreatePlayerModel(
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
          bowlAvg: '0.0',
          ecoRate: '8.0'),
      '2': CreatePlayerModel(
          firstName: 'Faf du',
          lastName: 'Plessis',
          country: 'South Africa',
          batAvg: '46.67',
          matches: '143',
          runs: '5507',
          topScore: '185',
          hundreds: '12',
          fifties: '35',
          strikeRate: '88.57',
          wickets: '2',
          bowlAvg: '94.5',
          ecoRate: '5.91'),
      '3': CreatePlayerModel(
          firstName: 'Lendl',
          lastName: 'Simmons',
          country: 'West Indies',
          batAvg: '31.58',
          matches: '68',
          hundreds: '2',
          fifties: '16',
          runs: '1958',
          topScore: '122',
          strikeRate: '73.06',
          wickets: '1',
          bowlAvg: '172.0',
          ecoRate: '6.62'),
      '4': CreatePlayerModel(
          firstName: 'Ravichandran',
          lastName: 'Ashwin',
          country: 'India',
          batAvg: '16.44',
          matches: '113',
          runs: '707',
          topScore: '65',
          hundreds: '0',
          fifties: '1',
          strikeRate: '86.96',
          wickets: '151',
          bowlAvg: '33.5',
          ecoRate: '4.94'),
      '5': CreatePlayerModel(
          firstName: 'Suresh',
          lastName: 'Raina',
          country: 'India',
          batAvg: '35.31',
          matches: '226',
          runs: '5615',
          topScore: '116',
          hundreds: '5',
          fifties: '36',
          strikeRate: '93.51',
          wickets: '36',
          bowlAvg: '50.31',
          ecoRate: '5.11'),
      '6': CreatePlayerModel(
          firstName: 'Steven',
          lastName: 'Smith',
          country: 'Australia',
          batAvg: '44.5',
          matches: '142',
          runs: '4939',
          topScore: '164',
          hundreds: '12',
          fifties: '29',
          strikeRate: '87.52',
          wickets: '28',
          bowlAvg: '34.68',
          ecoRate: '5.41'),
      '7': CreatePlayerModel(
          firstName: 'Thisara',
          lastName: 'Perera',
          country: 'Sri Lanka',
          batAvg: '19.98',
          matches: '166',
          runs: '2338',
          topScore: '140',
          hundreds: '1',
          fifties: '10',
          strikeRate: '112.08',
          wickets: '175',
          bowlAvg: '32.8',
          ecoRate: '5.84'),
      '8': CreatePlayerModel(
          firstName: 'Kane',
          lastName: 'Williamson',
          country: 'New Zealand',
          batAvg: '47.85',
          matches: '161',
          runs: '6555',
          topScore: '148',
          hundreds: '13',
          fifties: '42',
          strikeRate: '80.99',
          wickets: '37',
          bowlAvg: '35.41',
          ecoRate: '5.36'),
      '9': CreatePlayerModel(
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
          bowlAvg: '24.31',
          ecoRate: '4.64'),
      '10': CreatePlayerModel(
          firstName: 'James',
          lastName: 'Anderson',
          country: 'England',
          batAvg: '7.58',
          matches: '194',
          runs: '273',
          topScore: '28',
          hundreds: '0',
          fifties: '0',
          strikeRate: '48.75',
          wickets: '269',
          bowlAvg: '29.22',
          ecoRate: '4.92'),
      '11': CreatePlayerModel(
          firstName: 'Glenn',
          lastName: 'Maxwell',
          country: 'Australia',
          batAvg: '33.88',
          matches: '128',
          runs: '3490',
          topScore: '108',
          hundreds: '2',
          fifties: '23',
          strikeRate: '124.82',
          wickets: '60',
          bowlAvg: '50.23',
          ecoRate: '5.57'),
      '12': CreatePlayerModel(
          firstName: 'Dwayne',
          lastName: 'Bravo',
          country: 'West Indies',
          batAvg: '25.37',
          matches: '164',
          runs: '2968',
          topScore: '112',
          hundreds: '2',
          fifties: '10',
          strikeRate: '82.31',
          wickets: '199',
          bowlAvg: '29.52',
          ecoRate: '5.41'),
      '13': CreatePlayerModel(
          firstName: 'Kusal',
          lastName: 'Mendis',
          country: 'Sri Lanka',
          batAvg: '30.16',
          matches: '95',
          runs: '2654',
          topScore: '119',
          hundreds: '2',
          fifties: '20',
          strikeRate: '84.2',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '14': CreatePlayerModel(
          firstName: 'Hardik',
          lastName: 'Pandya',
          country: 'India',
          batAvg: '33.0',
          matches: '74',
          runs: '1584',
          topScore: '92',
          hundreds: '0',
          fifties: '9',
          strikeRate: '112.02',
          wickets: '72',
          bowlAvg: '37.65',
          ecoRate: '5.62'),
    });
    GameServices().createPlayerCharacters(
        roomId: Provider.of<GameProvider>(context, listen: false).roomId,
        gamePlayerAdd: gamePlayerAdd);
  }

  /// twenty five card players
  twentyFiveCardPlayers() {
    GamePlayerAdd gamePlayerAdd = GamePlayerAdd(playerCharacters: {
      '0': CreatePlayerModel(
          firstName: 'Virat',
          lastName: 'Kohli',
          country: 'India',
          batAvg: '57.7',
          matches: '274',
          runs: '12809',
          topScore: '183',
          hundreds: '46',
          fifties: '65',
          strikeRate: '93.77',
          wickets: '4',
          bowlAvg: '166.25',
          ecoRate: '6.22'),
      '1': CreatePlayerModel(
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
          bowlAvg: '0.0',
          ecoRate: '8.0'),
      '2': CreatePlayerModel(
          firstName: 'Faf du',
          lastName: 'Plessis',
          country: 'South Africa',
          batAvg: '46.67',
          matches: '143',
          runs: '5507',
          topScore: '185',
          hundreds: '12',
          fifties: '35',
          strikeRate: '88.57',
          wickets: '2',
          bowlAvg: '94.5',
          ecoRate: '5.91'),
      '3': CreatePlayerModel(
          firstName: 'Lendl',
          lastName: 'Simmons',
          country: 'West Indies',
          batAvg: '31.58',
          matches: '68',
          hundreds: '2',
          fifties: '16',
          runs: '1958',
          topScore: '122',
          strikeRate: '73.06',
          wickets: '1',
          bowlAvg: '172.0',
          ecoRate: '6.62'),
      '4': CreatePlayerModel(
          firstName: 'Ravichandran',
          lastName: 'Ashwin',
          country: 'India',
          batAvg: '16.44',
          matches: '113',
          runs: '707',
          topScore: '65',
          hundreds: '0',
          fifties: '1',
          strikeRate: '86.96',
          wickets: '151',
          bowlAvg: '33.5',
          ecoRate: '4.94'),
      '5': CreatePlayerModel(
          firstName: 'Suresh',
          lastName: 'Raina',
          country: 'India',
          batAvg: '35.31',
          matches: '226',
          runs: '5615',
          topScore: '116',
          hundreds: '5',
          fifties: '36',
          strikeRate: '93.51',
          wickets: '36',
          bowlAvg: '50.31',
          ecoRate: '5.11'),
      '6': CreatePlayerModel(
          firstName: 'Steven',
          lastName: 'Smith',
          country: 'Australia',
          batAvg: '44.5',
          matches: '142',
          runs: '4939',
          topScore: '164',
          hundreds: '12',
          fifties: '29',
          strikeRate: '87.52',
          wickets: '28',
          bowlAvg: '34.68',
          ecoRate: '5.41'),
      '7': CreatePlayerModel(
          firstName: 'Thisara',
          lastName: 'Perera',
          country: 'Sri Lanka',
          batAvg: '19.98',
          matches: '166',
          runs: '2338',
          topScore: '140',
          hundreds: '1',
          fifties: '10',
          strikeRate: '112.08',
          wickets: '175',
          bowlAvg: '32.8',
          ecoRate: '5.84'),
      '8': CreatePlayerModel(
          firstName: 'Kane',
          lastName: 'Williamson',
          country: 'New Zealand',
          batAvg: '47.85',
          matches: '161',
          runs: '6555',
          topScore: '148',
          hundreds: '13',
          fifties: '42',
          strikeRate: '80.99',
          wickets: '37',
          bowlAvg: '35.41',
          ecoRate: '5.36'),
      '9': CreatePlayerModel(
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
          bowlAvg: '24.31',
          ecoRate: '4.64'),
      '10': CreatePlayerModel(
          firstName: 'James',
          lastName: 'Anderson',
          country: 'England',
          batAvg: '7.58',
          matches: '194',
          runs: '273',
          topScore: '28',
          hundreds: '0',
          fifties: '0',
          strikeRate: '48.75',
          wickets: '269',
          bowlAvg: '29.22',
          ecoRate: '4.92'),
      '11': CreatePlayerModel(
          firstName: 'Glenn',
          lastName: 'Maxwell',
          country: 'Australia',
          batAvg: '33.88',
          matches: '128',
          runs: '3490',
          topScore: '108',
          hundreds: '2',
          fifties: '23',
          strikeRate: '124.82',
          wickets: '60',
          bowlAvg: '50.23',
          ecoRate: '5.57'),
      '12': CreatePlayerModel(
          firstName: 'Dwayne',
          lastName: 'Bravo',
          country: 'West Indies',
          batAvg: '25.37',
          matches: '164',
          runs: '2968',
          topScore: '112',
          hundreds: '2',
          fifties: '10',
          strikeRate: '82.31',
          wickets: '199',
          bowlAvg: '29.52',
          ecoRate: '5.41'),
      '13': CreatePlayerModel(
          firstName: 'Kusal',
          lastName: 'Mendis',
          country: 'Sri Lanka',
          batAvg: '30.16',
          matches: '95',
          runs: '2654',
          topScore: '119',
          hundreds: '2',
          fifties: '20',
          strikeRate: '84.2',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '14': CreatePlayerModel(
          firstName: 'Hardik',
          lastName: 'Pandya',
          country: 'India',
          batAvg: '33.0',
          matches: '74',
          runs: '1584',
          topScore: '92',
          hundreds: '0',
          fifties: '9',
          strikeRate: '112.02',
          wickets: '72',
          bowlAvg: '37.65',
          ecoRate: '5.62'),
      '15': CreatePlayerModel(
          firstName: 'KL',
          lastName: 'Rahul',
          country: 'India',
          batAvg: '45.14',
          matches: '54',
          runs: '1986',
          topScore: '112',
          hundreds: '5',
          fifties: '13',
          strikeRate: '86.57',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '16': CreatePlayerModel(
          firstName: 'Jason',
          lastName: 'Roy',
          country: 'England',
          batAvg: '39.92',
          matches: '116',
          runs: '4271',
          topScore: '180',
          hundreds: '12',
          fifties: '21',
          strikeRate: '105.53',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '17': CreatePlayerModel(
          firstName: 'Nathan',
          lastName: 'Lyon',
          country: 'Australia',
          batAvg: '19.25',
          matches: '29',
          runs: '77',
          topScore: '30',
          hundreds: '0',
          fifties: '9',
          strikeRate: '92.77',
          wickets: '29',
          bowlAvg: '46.0',
          ecoRate: '4.92'),
      '18': CreatePlayerModel(
          firstName: 'Marcus',
          lastName: 'Stoinis',
          country: 'Austraila',
          batAvg: '28.21',
          matches: '60',
          runs: '1326',
          topScore: '146',
          hundreds: '1',
          fifties: '6',
          strikeRate: '92.53',
          wickets: '40',
          bowlAvg: '34.11',
          ecoRate: '8.61'),
      '19': CreatePlayerModel(
          firstName: 'Sam',
          lastName: 'Curran',
          country: 'England',
          batAvg: '24.46',
          matches: '23',
          runs: '318',
          topScore: '95',
          hundreds: '0',
          fifties: '1',
          strikeRate: '96.36',
          wickets: '26',
          bowlAvg: '36.38',
          ecoRate: '5.86'),
      '20': CreatePlayerModel(
          firstName: 'Babar',
          lastName: 'Azam',
          country: 'Pakistan',
          batAvg: '59.42',
          matches: '95',
          runs: '4813',
          topScore: '158',
          hundreds: '17',
          fifties: '24',
          strikeRate: '89.03',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '21': CreatePlayerModel(
          firstName: 'Mushfiqur',
          lastName: 'Rahim',
          country: 'Bangladesh',
          batAvg: '36.69',
          matches: '245',
          runs: '7045',
          topScore: '144',
          hundreds: '9',
          fifties: '43',
          strikeRate: '79.48',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '22': CreatePlayerModel(
          firstName: 'Jason',
          lastName: 'Holder',
          country: 'West Indies',
          batAvg: '24.34',
          matches: '133',
          runs: '2093',
          topScore: '99',
          hundreds: '0',
          fifties: '11',
          strikeRate: '90.25',
          wickets: '153',
          bowlAvg: '37.03',
          ecoRate: '5.55'),
      '23': CreatePlayerModel(
          firstName: 'Sachin',
          lastName: 'Tendulkar',
          country: 'India',
          batAvg: '44.83',
          matches: '463',
          runs: '18426',
          topScore: '200',
          hundreds: '49',
          fifties: '96',
          strikeRate: '86.24',
          wickets: '154',
          bowlAvg: '44.48',
          ecoRate: '5.1'),
      '24': CreatePlayerModel(
          firstName: 'Nicholas',
          lastName: 'Pooran',
          country: 'West Indies',
          batAvg: '36.29',
          matches: '54',
          runs: '1633',
          topScore: '118',
          hundreds: '1',
          fifties: '11',
          strikeRate: '96.06',
          wickets: '6',
          bowlAvg: '29.0',
          ecoRate: '6.18'),
    });
    GameServices().createPlayerCharacters(
        roomId: Provider.of<GameProvider>(context, listen: false).roomId,
        gamePlayerAdd: gamePlayerAdd);
  }

  thirtyCardPlayers() {
    GamePlayerAdd gamePlayerAdd = GamePlayerAdd(playerCharacters: {
      '0': CreatePlayerModel(
          firstName: 'Virat',
          lastName: 'Kohli',
          country: 'India',
          batAvg: '57.7',
          matches: '274',
          runs: '12809',
          topScore: '183',
          hundreds: '46',
          fifties: '65',
          strikeRate: '93.77',
          wickets: '4',
          bowlAvg: '166.25',
          ecoRate: '6.22'),
      '1': CreatePlayerModel(
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
          bowlAvg: '0.0',
          ecoRate: '8.0'),
      '2': CreatePlayerModel(
          firstName: 'Faf du',
          lastName: 'Plessis',
          country: 'South Africa',
          batAvg: '46.67',
          matches: '143',
          runs: '5507',
          topScore: '185',
          hundreds: '12',
          fifties: '35',
          strikeRate: '88.57',
          wickets: '2',
          bowlAvg: '94.5',
          ecoRate: '5.91'),
      '3': CreatePlayerModel(
          firstName: 'Lendl',
          lastName: 'Simmons',
          country: 'West Indies',
          batAvg: '31.58',
          matches: '68',
          hundreds: '2',
          fifties: '16',
          runs: '1958',
          topScore: '122',
          strikeRate: '73.06',
          wickets: '1',
          bowlAvg: '172.0',
          ecoRate: '6.62'),
      '4': CreatePlayerModel(
          firstName: 'Ravichandran',
          lastName: 'Ashwin',
          country: 'India',
          batAvg: '16.44',
          matches: '113',
          runs: '707',
          topScore: '65',
          hundreds: '0',
          fifties: '1',
          strikeRate: '86.96',
          wickets: '151',
          bowlAvg: '33.5',
          ecoRate: '4.94'),
      '5': CreatePlayerModel(
          firstName: 'Suresh',
          lastName: 'Raina',
          country: 'India',
          batAvg: '35.31',
          matches: '226',
          runs: '5615',
          topScore: '116',
          hundreds: '5',
          fifties: '36',
          strikeRate: '93.51',
          wickets: '36',
          bowlAvg: '50.31',
          ecoRate: '5.11'),
      '6': CreatePlayerModel(
          firstName: 'Steven',
          lastName: 'Smith',
          country: 'Australia',
          batAvg: '44.5',
          matches: '142',
          runs: '4939',
          topScore: '164',
          hundreds: '12',
          fifties: '29',
          strikeRate: '87.52',
          wickets: '28',
          bowlAvg: '34.68',
          ecoRate: '5.41'),
      '7': CreatePlayerModel(
          firstName: 'Thisara',
          lastName: 'Perera',
          country: 'Sri Lanka',
          batAvg: '19.98',
          matches: '166',
          runs: '2338',
          topScore: '140',
          hundreds: '1',
          fifties: '10',
          strikeRate: '112.08',
          wickets: '175',
          bowlAvg: '32.8',
          ecoRate: '5.84'),
      '8': CreatePlayerModel(
          firstName: 'Kane',
          lastName: 'Williamson',
          country: 'New Zealand',
          batAvg: '47.85',
          matches: '161',
          runs: '6555',
          topScore: '148',
          hundreds: '13',
          fifties: '42',
          strikeRate: '80.99',
          wickets: '37',
          bowlAvg: '35.41',
          ecoRate: '5.36'),
      '9': CreatePlayerModel(
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
          bowlAvg: '24.31',
          ecoRate: '4.64'),
      '10': CreatePlayerModel(
          firstName: 'James',
          lastName: 'Anderson',
          country: 'England',
          batAvg: '7.58',
          matches: '194',
          runs: '273',
          topScore: '28',
          hundreds: '0',
          fifties: '0',
          strikeRate: '48.75',
          wickets: '269',
          bowlAvg: '29.22',
          ecoRate: '4.92'),
      '11': CreatePlayerModel(
          firstName: 'Glenn',
          lastName: 'Maxwell',
          country: 'Australia',
          batAvg: '33.88',
          matches: '128',
          runs: '3490',
          topScore: '108',
          hundreds: '2',
          fifties: '23',
          strikeRate: '124.82',
          wickets: '60',
          bowlAvg: '50.23',
          ecoRate: '5.57'),
      '12': CreatePlayerModel(
          firstName: 'Dwayne',
          lastName: 'Bravo',
          country: 'West Indies',
          batAvg: '25.37',
          matches: '164',
          runs: '2968',
          topScore: '112',
          hundreds: '2',
          fifties: '10',
          strikeRate: '82.31',
          wickets: '199',
          bowlAvg: '29.52',
          ecoRate: '5.41'),
      '13': CreatePlayerModel(
          firstName: 'Kusal',
          lastName: 'Mendis',
          country: 'Sri Lanka',
          batAvg: '30.16',
          matches: '95',
          runs: '2654',
          topScore: '119',
          hundreds: '2',
          fifties: '20',
          strikeRate: '84.2',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '14': CreatePlayerModel(
          firstName: 'Hardik',
          lastName: 'Pandya',
          country: 'India',
          batAvg: '33.0',
          matches: '74',
          runs: '1584',
          topScore: '92',
          hundreds: '0',
          fifties: '9',
          strikeRate: '112.02',
          wickets: '72',
          bowlAvg: '37.65',
          ecoRate: '5.62'),
      '15': CreatePlayerModel(
          firstName: 'KL',
          lastName: 'Rahul',
          country: 'India',
          batAvg: '45.14',
          matches: '54',
          runs: '1986',
          topScore: '112',
          hundreds: '5',
          fifties: '13',
          strikeRate: '86.57',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '16': CreatePlayerModel(
          firstName: 'Jason',
          lastName: 'Roy',
          country: 'England',
          batAvg: '39.92',
          matches: '116',
          runs: '4271',
          topScore: '180',
          hundreds: '12',
          fifties: '21',
          strikeRate: '105.53',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '17': CreatePlayerModel(
          firstName: 'Nathan',
          lastName: 'Lyon',
          country: 'Australia',
          batAvg: '19.25',
          matches: '29',
          runs: '77',
          topScore: '30',
          hundreds: '0',
          fifties: '9',
          strikeRate: '92.77',
          wickets: '29',
          bowlAvg: '46.0',
          ecoRate: '4.92'),
      '18': CreatePlayerModel(
          firstName: 'Marcus',
          lastName: 'Stoinis',
          country: 'Austraila',
          batAvg: '28.21',
          matches: '60',
          runs: '1326',
          topScore: '146',
          hundreds: '1',
          fifties: '6',
          strikeRate: '92.53',
          wickets: '40',
          bowlAvg: '34.11',
          ecoRate: '8.61'),
      '19': CreatePlayerModel(
          firstName: 'Sam',
          lastName: 'Curran',
          country: 'England',
          batAvg: '24.46',
          matches: '23',
          runs: '318',
          topScore: '95',
          hundreds: '0',
          fifties: '1',
          strikeRate: '96.36',
          wickets: '26',
          bowlAvg: '36.38',
          ecoRate: '5.86'),
      '20': CreatePlayerModel(
          firstName: 'Babar',
          lastName: 'Azam',
          country: 'Pakistan',
          batAvg: '59.42',
          matches: '95',
          runs: '4813',
          topScore: '158',
          hundreds: '17',
          fifties: '24',
          strikeRate: '89.03',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '21': CreatePlayerModel(
          firstName: 'Mushfiqur',
          lastName: 'Rahim',
          country: 'Bangladesh',
          batAvg: '36.69',
          matches: '245',
          runs: '7045',
          topScore: '144',
          hundreds: '9',
          fifties: '43',
          strikeRate: '79.48',
          wickets: '0',
          bowlAvg: '0.0',
          ecoRate: '0.0'),
      '22': CreatePlayerModel(
          firstName: 'Jason',
          lastName: 'Holder',
          country: 'West Indies',
          batAvg: '24.34',
          matches: '133',
          runs: '2093',
          topScore: '99',
          hundreds: '0',
          fifties: '11',
          strikeRate: '90.25',
          wickets: '153',
          bowlAvg: '37.03',
          ecoRate: '5.55'),
      '23': CreatePlayerModel(
          firstName: 'Sachin',
          lastName: 'Tendulkar',
          country: 'India',
          batAvg: '44.83',
          matches: '463',
          runs: '18426',
          topScore: '200',
          hundreds: '49',
          fifties: '96',
          strikeRate: '86.24',
          wickets: '154',
          bowlAvg: '44.48',
          ecoRate: '5.1'),
      '24': CreatePlayerModel(
          firstName: 'Nicholas',
          lastName: 'Pooran',
          country: 'West Indies',
          batAvg: '36.29',
          matches: '54',
          runs: '1633',
          topScore: '118',
          hundreds: '1',
          fifties: '11',
          strikeRate: '96.06',
          wickets: '6',
          bowlAvg: '29.0',
          ecoRate: '6.18'),
      '25': CreatePlayerModel(
        firstName: 'Ross',
        lastName: 'Taylor',
        country: 'New Zealand',
        batAvg: '47.52',
        matches: '236',
        runs: '8602',
        topScore: '181',
        hundreds: '21',
        fifties: '51',
        strikeRate: '83.26',
        wickets: '3',
        bowlAvg: '0.0',
        ecoRate: '5.0',
      ),
      '26': CreatePlayerModel(
        firstName: 'Bhuvneshwar',
        lastName: 'Kumar',
        country: 'India',
        batAvg: '14.15',
        matches: '121',
        runs: '552',
        topScore: '53',
        hundreds: '',
        fifties: '1',
        strikeRate: '73.9',
        wickets: '141',
        bowlAvg: '35.11',
        ecoRate: '5.08',
      ),
      '27': CreatePlayerModel(
        firstName: 'Pat',
        lastName: 'Cummins',
        country: 'Australia',
        batAvg: '10.12',
        matches: '75',
        runs: '324',
        topScore: '36',
        hundreds: '0',
        fifties: '0',
        strikeRate: '73.97',
        wickets: '124',
        bowlAvg: '27.61',
        ecoRate: '5.22',
      ),
      '28': CreatePlayerModel(
        firstName: 'Tim',
        lastName: 'Southee',
        country: 'New Zealand',
        batAvg: '12.45',
        matches: '154',
        runs: '722',
        topScore: '55',
        hundreds: '0',
        fifties: '1',
        strikeRate: '96.65',
        wickets: '210',
        bowlAvg: '33.46',
        ecoRate: '5.44',
      ),
      '29': CreatePlayerModel(
        firstName: 'Shubman',
        lastName: 'Gill',
        country: 'India',
        batAvg: '65.55',
        matches: '24',
        runs: '1311',
        topScore: '208',
        hundreds: '4',
        fifties: '5',
        strikeRate: '107.11',
        wickets: '0',
        bowlAvg: '0.0',
        ecoRate: '0.0',
      ),
    });
    GameServices().createPlayerCharacters(
        roomId: Provider.of<GameProvider>(context, listen: false).roomId,
        gamePlayerAdd: gamePlayerAdd);
  }
}
