import 'dart:developer';

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

  @override
  void initState() {
    // getData();
    super.initState();
  }

  DatabaseReference getCardSelect() {
    log('Room/${Provider.of<GameProvider>(context, listen: false).roomId}/players');
    DatabaseReference refDb = FirebaseDatabase.instance.ref(
        'Room/${Provider.of<GameProvider>(context, listen: false).roomId}/players');
    return refDb;
  }

  getData() {
    String userId = (FirebaseAuth.instance.currentUser)!.uid;
    log(userId);
    log('firebase UserID');
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    var deckCardsTotal = [
      {'cardValue': '10', 'cardId': 0},
      {'cardValue': '20', 'cardId': 1},
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
                              Map<dynamic, dynamic> data = snapShot.data!
                                  .snapshot.value as Map<dynamic, dynamic>;
                              log(data.entries.length.toString() ?? '');
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
                                      padding: EdgeInsets.all(10.sp),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.sp)),
                                          color: Colors.white),
                                      child: Text(
                                        'Waiting for players to join',
                                        style: AppTextStyles
                                            .instance.loginSubHeader,
                                      ),
                                    );
                            }
                            return Container();
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

  _cardDetails(options) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectCardValue = options['cardId'];
          selectCardNumbers = options['cardValue'];
          SelectCardModel selectCardModel =
              SelectCardModel(selectCard: selectCardValue != -1 ? true : false);

          log(selectCardNumbers);
          NavigationRoute().animationRoute(context, const CoinFlipScreen());
          Provider.of<NameProvider>(context, listen: false)
              .addCards(value: selectCardValue);
          Provider.of<NameProvider>(context, listen: false)
              .cardTotalValue(value: selectCardNumbers);
          Provider.of<GameProvider>(context, listen: false).hostCardSelect(
              value: Provider.of<GameProvider>(context, listen: false).roomId,
              selectCardModel: selectCardModel);
        });
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
}
