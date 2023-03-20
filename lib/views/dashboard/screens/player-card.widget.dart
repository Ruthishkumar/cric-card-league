import 'dart:developer';

import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerCardWidget extends StatelessWidget {
  final List<CreatePlayerModel> playerList;
  final Function(String) onFeatureSelect;
  final String selectedFeature;
  const PlayerCardWidget(
      {Key? key,
      required this.playerList,
      required this.onFeatureSelect,
      required this.selectedFeature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.sp,
      decoration: BoxDecoration(
          color: const Color(0xff243b55),
          boxShadow: [
            BoxShadow(
                color: Colors.white70.withOpacity(0.3), //New
                blurRadius: 5.0,
                spreadRadius: 5.0)
          ],
          borderRadius: BorderRadius.all(Radius.circular(16.sp))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xff243b55),
                borderRadius: BorderRadius.all(Radius.circular(16.sp))),
            child: Column(
              children: [
                ...[playerList.first].map((data) {
                  if (playerList.isNotEmpty) {
                    return Column(
                      children: [
                        playerHeaderWidget(data),
                        Container(
                          width: 300.sp,
                          decoration: BoxDecoration(
                              color: const Color(0xff243b55),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.sp))),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                    2.sp, 12.sp, 2.sp, 12.sp),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.sp))),
                                child: Column(children: [
                                  avgWidget(data, data.toJson().length),
                                  SizedBox(height: 10.sp),
                                  strikeAndEconomyWidget(
                                      data, data.toJson().length),
                                  SizedBox(height: 10.sp),
                                  runsAndWickets(data, data.toJson().length),
                                  SizedBox(height: 10.sp),
                                  highScore(data, data.toJson().length),
                                ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  DatabaseReference getStats() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref('Room/test');
    return refDb;
  }

  avgWidget(CreatePlayerModel createAvgModel, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var stats =
                  snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
              return GestureDetector(
                onTap: stats['players'][FirebaseAuth.instance.currentUser!.uid]
                            ['wonToss'] ==
                        true
                    ? () {
                        onFeatureSelect('${createAvgModel.batAvg}-${index}');
                        GameServices().createSelectStats(
                            selectedKey: 'batAvg',
                            selectedValue: createAvgModel.batAvg);
                      }
                    : () {
                        showDialog(
                          barrierColor: Colors.transparent,
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return alertDialogWidget(context);
                          },
                        );
                        log('You Does not Click');
                      },
                child: Row(children: [
                  Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: stats['selectedKey'] == 'batAvg' &&
                                  stats['hostId'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                              ? Colors.red
                              : selectedFeature ==
                                      '${createAvgModel.batAvg}-${index}'
                                  ? Colors.green
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text('Bat.Avg : ${createAvgModel.batAvg}',
                                style: AppTextStyles.instance.playersStats),
                          ),
                          Text(
                            stats['selectedKey'] == 'batAvg' &&
                                    stats['hostId'] !=
                                        FirebaseAuth.instance.currentUser!.uid
                                ? 'vs ${stats['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                          )
                        ],
                      ))
                ]),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        GestureDetector(
            onTap: () {
              GameServices().createSelectStats(
                  selectedKey: 'bowlAvg',
                  selectedValue: createAvgModel.bowlAvg);
              onFeatureSelect('${createAvgModel.bowlAvg}-${index}');
            },
            child: StreamBuilder(
              stream: getStats().onValue,
              builder: (context, snapShot) {
                if (snapShot.data != null) {
                  var bowlingAvg =
                      snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
                  return Row(
                    children: [
                      Container(
                        width: 120.sp,
                        height: 65.sp,
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                            color: bowlingAvg['selectedKey'] == 'bowlAvg' &&
                                    bowlingAvg['hostId'] !=
                                        FirebaseAuth.instance.currentUser!.uid
                                ? Colors.red
                                : selectedFeature ==
                                        '${createAvgModel.bowlAvg}-${index}'
                                    ? Colors.green
                                    : const Color(0xff243b55),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.sp))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Bowl Avg : ${createAvgModel.bowlAvg}',
                                style: AppTextStyles.instance.playersStats,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              bowlingAvg['selectedKey'] == 'bowlAvg' &&
                                      bowlingAvg['hostId'] !=
                                          FirebaseAuth.instance.currentUser!.uid
                                  ? 'vs ${bowlingAvg['selectedValue']}'
                                  : '',
                              style: AppTextStyles.instance.playersStat1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            )),
      ],
    );
  }

  strikeAndEconomyWidget(CreatePlayerModel seData, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            GameServices().createSelectStats(
                selectedKey: 'strRate', selectedValue: seData.strikeRate);
            onFeatureSelect('${seData.strikeRate}-${index}');
          },
          child: StreamBuilder(
            stream: getStats().onValue,
            builder: (context, snapShot) {
              if (snapShot.data != null) {
                var strikeRate =
                    snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
                return Row(
                  children: [
                    Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: strikeRate['selectedKey'] == 'strRate' &&
                                  strikeRate['hostId'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                              ? Colors.red
                              : selectedFeature ==
                                      '${seData.strikeRate}-${index}'
                                  ? Colors.green
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Str.Rate : ${seData.strikeRate}',
                              style: AppTextStyles.instance.playersStats,
                            ),
                          ),
                          Text(
                            strikeRate['selectedKey'] == 'strRate' &&
                                    strikeRate['hostId'] !=
                                        FirebaseAuth.instance.currentUser!.uid
                                ? 'vs ${strikeRate['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
        SizedBox(height: 10.sp),
        GestureDetector(
          onTap: () {
            GameServices().createSelectStats(
                selectedKey: 'ecoRate', selectedValue: seData.economyRate);
            onFeatureSelect('${seData.economyRate}-${index}');
          },
          child: StreamBuilder(
            stream: getStats().onValue,
            builder: (context, snapShot) {
              var economyRate =
                  snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
              if (snapShot.data != null) {
                return Row(
                  children: [
                    Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: economyRate['selectedKey'] == 'ecoRate' &&
                                  economyRate['hostId'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                              ? Colors.red
                              : selectedFeature ==
                                      '${seData.economyRate}-${index}'
                                  ? Colors.green
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Eco.Rate : ${seData.economyRate}',
                              style: AppTextStyles.instance.playersStats,
                            ),
                          ),
                          Text(
                            economyRate['selectedKey'] == 'ecoRate' &&
                                    economyRate['hostId'] !=
                                        FirebaseAuth.instance.currentUser!.uid
                                ? 'vs ${economyRate['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }

  runsAndWickets(CreatePlayerModel runsWickets, int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      StreamBuilder(
        stream: getStats().onValue,
        builder: (context, snapShot) {
          if (snapShot.data != null) {
            var runs = snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
            return GestureDetector(
              onTap: () {
                log(runs['selectedValue'].toString());
                log('New Turns');
                GameServices().createSelectStats(
                    selectedKey: 'runs', selectedValue: runsWickets.runs);
                onFeatureSelect('${runsWickets.runs}-${index}');
                if (int.parse(runs['selectedValue']) >
                    int.parse(runsWickets.runs)) {
                  log('You Win');
                  log(FirebaseAuth.instance.currentUser!.uid);
                } else {
                  log('You Lose');
                  runs['selectedValue'] =
                      FirebaseAuth.instance.currentUser!.uid;
                  runs['players'][FirebaseAuth.instance.currentUser!.uid]
                      ['playerCharacters'];
                  log(FirebaseAuth.instance.currentUser!.uid);
                  // log(playerList.removeAt(index).runs.toString());
                }
              },
              child: Row(children: [
                Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: runs['selectedKey'] == 'runs' &&
                                runs['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                            ? Colors.red
                            : selectedFeature == '${runsWickets.runs}-${index}'
                                ? Colors.green
                                : const Color(0xff243b55),
                        borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('Runs : ${runsWickets.runs}',
                              style: AppTextStyles.instance.playersStats),
                        ),
                        Text(
                          runs['selectedKey'] == 'runs' &&
                                  runs['hostId'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                              ? 'vs ${runs['selectedValue']}'
                              : '',
                          style: AppTextStyles.instance.playersStat1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ))
              ]),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      GestureDetector(
        onTap: () {
          GameServices().createSelectStats(
              selectedKey: 'wickets', selectedValue: runsWickets.wickets);
          onFeatureSelect('${runsWickets.wickets}-${index}');
        },
        child: StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var wickets =
                  snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
              return Row(children: [
                Container(
                  width: 120.sp,
                  height: 65.sp,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: wickets['selectedKey'] == 'wickets' &&
                              wickets['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                          ? Colors.red
                          : selectedFeature == '${runsWickets.wickets}-${index}'
                              ? Colors.green
                              : const Color(0xff243b55),
                      borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Wickets : ${runsWickets.wickets}',
                          style: AppTextStyles.instance.playersStats),
                      Visibility(
                        child: Text(
                          wickets['selectedKey'] == 'wickets' &&
                                  wickets['hostId'] !=
                                      FirebaseAuth.instance.currentUser!.uid
                              ? 'vs ${wickets['selectedValue']}'
                              : '',
                          style: AppTextStyles.instance.playersStat1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ]);
            }
            return const CircularProgressIndicator();
          },
        ),
      )
    ]);
  }

  highScore(CreatePlayerModel highScore, int index) {
    return GestureDetector(
        onTap: () {
          GameServices().createSelectStats(
              selectedKey: 'topScore', selectedValue: highScore.topScore);
          onFeatureSelect('${highScore.topScore}-${index}');
        },
        child: StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var topScore =
                  snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
              return Container(
                  width: 300.sp,
                  height: 65.sp,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: topScore['selectedKey'] == 'topScore' &&
                              topScore['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                          ? Colors.red
                          : selectedFeature == '${highScore.topScore}-${index}'
                              ? Colors.green
                              : const Color(0xff243b55),
                      borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Top Score : ${highScore.topScore}',
                          style: AppTextStyles.instance.playersStats),
                      Text(
                        topScore['selectedKey'] == 'topScore' &&
                                topScore['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                            ? 'vs ${topScore['selectedValue']}'
                            : '',
                        style: AppTextStyles.instance.playersStat1,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ));
            }
            return const CircularProgressIndicator();
          },
        ));
  }

  playerHeaderWidget(CreatePlayerModel playerHeaderData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 12.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(playerHeaderData.firstName,
                style: AppTextStyles.instance.cardFirstName),
            Text(playerHeaderData.lastName,
                style: AppTextStyles.instance.cardSecondName),
            SizedBox(height: 10.sp),
            Text(playerHeaderData.country.toUpperCase(),
                style: AppTextStyles.instance.countryName),
          ]),
          Image.asset('assets/images/Virat-Kohli-T20I2020.png',
              height: 150.sp, width: 130.sp)
        ],
      ),
    );
  }

  alertDialogWidget(BuildContext context) {
    return AlertDialog(
      elevation: 100,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.sp)),
      ),
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Wait for your', style: AppTextStyles.instance.popError),
          SizedBox(height: 4.sp),
          Text('Opponent turn', style: AppTextStyles.instance.popError),
          SizedBox(height: 15.sp),
          HeadTailsButton(
              text: 'Okay',
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
