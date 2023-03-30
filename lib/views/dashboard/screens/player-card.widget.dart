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
  final String currentPlayer;
  const PlayerCardWidget(
      {Key? key,
      required this.playerList,
      required this.onFeatureSelect,
      required this.currentPlayer,
      required this.selectedFeature})
      : super(key: key);

  canClick() {
    return currentPlayer == FirebaseAuth.instance.currentUser?.uid.toString();
  }

  DatabaseReference getStats() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref('Room/test');
    return refDb;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                                      matchesAndBatAvg(
                                          data, data.toJson().length),
                                      SizedBox(height: 10.sp),
                                      strikeRateAndRuns(
                                          data, data.toJson().length),
                                      SizedBox(height: 10.sp),
                                      hundredsAndFifties(
                                          data, data.toJson().length),
                                      SizedBox(height: 10.sp),
                                      topScoreAndWickets(
                                          data, data.toJson().length),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
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
        ),
        SizedBox(height: 25.sp),
        ...[playerList.first].map((status) {
          return Column(
            children: [
              getMatchStatus(status, status.toJson().length),
            ],
          );
        }),
      ],
    );
  }

  matchesAndBatAvg(CreatePlayerModel matchAndAverage, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var matches =
                  snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
              return InkWell(
                onTap: !canClick()
                    ? () {
                        showDialog(
                            barrierColor: Colors.black87,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return alertDialogWidget(context);
                            });
                      }
                    : () {
                        GameServices().createSelectStats(
                            selectedKey: 'matches',
                            selectedValue: matchAndAverage.matches,
                            currentPlayer: currentPlayer,
                            playerName:
                                '${matchAndAverage.firstName} ${matchAndAverage.lastName}',
                            country: matchAndAverage.country);
                        onFeatureSelect('${matchAndAverage.matches}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStatValue: 'Ruthish',
                            selectStats: selectedFeature ==
                                    '${matchAndAverage.matches}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: 'test', featureSelect: featureSelect);
                      },
                child: Row(
                  children: [
                    Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: selectedFeature ==
                                      '${matchAndAverage.matches}-${index}' &&
                                  matches['selectedKey'] == 'matches'
                              ? const Color(0xff2C7744)
                              : (matches['selectedKey'] == 'matches' &&
                                      matches['players'][FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid]['selectStats'] ==
                                          true)
                                  ? const Color(0xffC02425)
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Matches : ${matchAndAverage.matches}',
                              style: AppTextStyles.instance.playersStats,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            (matches['selectedKey'] == 'matches' &&
                                    matches['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? 'vs ${matches['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var stats =
                  snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
              return InkWell(
                onTap: !canClick()
                    ? () {
                        showDialog(
                            barrierColor: Colors.black87,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return alertDialogWidget(context);
                            });
                      }
                    : () {
                        GameServices().createSelectStats(
                            selectedKey: 'batAvg',
                            selectedValue: matchAndAverage.batAvg,
                            currentPlayer: currentPlayer,
                            playerName:
                                '${matchAndAverage.firstName} ${matchAndAverage.lastName}',
                            country: matchAndAverage.country);
                        onFeatureSelect('${matchAndAverage.batAvg}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStatValue: 'Ruthish',
                            selectStats: selectedFeature ==
                                    '${matchAndAverage.batAvg}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: 'test', featureSelect: featureSelect);
                      },
                child: Row(children: [
                  Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: selectedFeature ==
                                      '${matchAndAverage.batAvg}-${index}' &&
                                  stats['selectedKey'] == 'batAvg'
                              ? const Color(0xff2C7744)
                              : (stats['selectedKey'] == 'batAvg' &&
                                      stats['players'][FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid]['selectStats'] ==
                                          true)
                                  ? const Color(0xffC02425)
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text('Bat.Avg : ${matchAndAverage.batAvg}',
                                style: AppTextStyles.instance.playersStats),
                          ),
                          Text(
                            (stats['selectedKey'] == 'batAvg' &&
                                    stats['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? 'vs ${stats['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ))
                ]),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  strikeRateAndRuns(CreatePlayerModel strikeAndRuns, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var strikeRate =
                  snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
              return InkWell(
                onTap: !canClick()
                    ? () {
                        showDialog(
                            barrierColor: Colors.black87,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return alertDialogWidget(context);
                            });
                      }
                    : () {
                        GameServices().createSelectStats(
                            selectedKey: 'strikeRate',
                            selectedValue: strikeAndRuns.strikeRate,
                            currentPlayer: currentPlayer,
                            playerName:
                                '${strikeAndRuns.firstName} ${strikeAndRuns.lastName}',
                            country: strikeAndRuns.country);
                        onFeatureSelect('${strikeAndRuns.strikeRate}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStatValue: 'Ruthish',
                            selectStats: selectedFeature ==
                                    '${strikeAndRuns.strikeRate}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: 'test', featureSelect: featureSelect);
                      },
                child: Row(
                  children: [
                    Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: selectedFeature ==
                                      '${strikeAndRuns.strikeRate}-${index}' &&
                                  strikeRate['selectedKey'] == 'strikeRate'
                              ? const Color(0xff2C7744)
                              : (strikeRate['selectedKey'] == 'strikeRate' &&
                                      strikeRate['players'][FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid]['selectStats'] ==
                                          true)
                                  ? const Color(0xffC02425)
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Str.Rate : ${strikeAndRuns.strikeRate}',
                              style: AppTextStyles.instance.playersStats,
                            ),
                          ),
                          Text(
                            (strikeRate['selectedKey'] == 'strikeRate' &&
                                    strikeRate['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? 'vs ${strikeRate['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        SizedBox(height: 10.sp),
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var runs = snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
              return InkWell(
                onTap: !canClick()
                    ? () {
                        showDialog(
                            barrierColor: Colors.black87,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return alertDialogWidget(context);
                            });
                      }
                    : () {
                        GameServices().createSelectStats(
                            selectedKey: 'runs',
                            selectedValue: strikeAndRuns.runs,
                            currentPlayer: currentPlayer,
                            playerName:
                                '${strikeAndRuns.firstName} ${strikeAndRuns.lastName}',
                            country: strikeAndRuns.country);
                        onFeatureSelect('${strikeAndRuns.runs}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStatValue: 'Ruthish',
                            selectStats: selectedFeature ==
                                    '${strikeAndRuns.runs}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: 'test', featureSelect: featureSelect);
                      },
                child: Row(children: [
                  Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: selectedFeature ==
                                      '${strikeAndRuns.runs}-${index}' &&
                                  runs['selectedKey'] == 'runs'
                              ? const Color(0xff2C7744)
                              : (runs['selectedKey'] == 'runs' &&
                                      runs['players'][FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid]['selectStats'] ==
                                          true)
                                  ? const Color(0xffC02425)
                                  : const Color(0xff243b55),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.sp))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text('Runs : ${strikeAndRuns.runs}',
                                style: AppTextStyles.instance.playersStats),
                          ),
                          Text(
                            (runs['selectedKey'] == 'runs' &&
                                    runs['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? 'vs ${runs['selectedValue']}'
                                : '',
                            style: AppTextStyles.instance.playersStat1,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ))
                ]),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  hundredsAndFifties(CreatePlayerModel hundredsAndFifties, int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      StreamBuilder(
        stream: getStats().onValue,
        builder: (context, snapShot) {
          if (snapShot.data != null) {
            var hundreds =
                snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
            return InkWell(
              onTap: !canClick()
                  ? () {
                      showDialog(
                          barrierColor: Colors.black87,
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return alertDialogWidget(context);
                          });
                    }
                  : () {
                      GameServices().createSelectStats(
                          selectedKey: 'hundreds',
                          selectedValue: hundredsAndFifties.hundreds,
                          currentPlayer: currentPlayer,
                          playerName:
                              '${hundredsAndFifties.firstName} ${hundredsAndFifties.lastName}',
                          country: hundredsAndFifties.country);
                      onFeatureSelect(
                          '${hundredsAndFifties.hundreds}-${index}');
                      FeatureSelect featureSelect = FeatureSelect(
                          selectStatValue: 'Ruthish',
                          selectStats: selectedFeature ==
                                  '${hundredsAndFifties.hundreds}-${index}'
                              ? true
                              : false);
                      GameServices().selectFeature(
                          roomId: 'test', featureSelect: featureSelect);
                    },
              child: Row(children: [
                Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: selectedFeature ==
                                    '${hundredsAndFifties.hundreds}-${index}' &&
                                hundreds['selectedKey'] == 'hundreds'
                            ? const Color(0xff2C7744)
                            : (hundreds['selectedKey'] == 'hundreds' &&
                                    hundreds['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? const Color(0xffC02425)
                                : const Color(0xff243b55),
                        borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('100\'s : ${hundredsAndFifties.hundreds}',
                              style: AppTextStyles.instance.playersStats),
                        ),
                        Text(
                          (hundreds['selectedKey'] == 'hundreds' &&
                                  hundreds['players'][FirebaseAuth.instance
                                          .currentUser!.uid]['selectStats'] ==
                                      true)
                              ? 'vs ${hundreds['selectedValue']}'
                              : '',
                          style: AppTextStyles.instance.playersStat1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))
              ]),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      StreamBuilder(
        stream: getStats().onValue,
        builder: (context, snapShot) {
          if (snapShot.data != null) {
            var fifties =
                snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
            return InkWell(
              onTap: !canClick()
                  ? () {
                      showDialog(
                          barrierColor: Colors.black87,
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return alertDialogWidget(context);
                          });
                    }
                  : () {
                      GameServices().createSelectStats(
                          selectedKey: 'fifties',
                          selectedValue: hundredsAndFifties.fifties,
                          currentPlayer: currentPlayer,
                          playerName:
                              '${hundredsAndFifties.firstName} ${hundredsAndFifties.lastName}',
                          country: hundredsAndFifties.country);
                      onFeatureSelect('${hundredsAndFifties.fifties}-${index}');
                      FeatureSelect featureSelect = FeatureSelect(
                          selectStatValue: 'Ruthish',
                          selectStats: selectedFeature ==
                                  '${hundredsAndFifties.fifties}-${index}'
                              ? true
                              : false);
                      GameServices().selectFeature(
                          roomId: 'test', featureSelect: featureSelect);
                    },
              child: Row(children: [
                Container(
                  width: 120.sp,
                  height: 65.sp,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: selectedFeature ==
                                  '${hundredsAndFifties.fifties}-${index}' &&
                              fifties['selectedKey'] == 'fifties'
                          ? const Color(0xff2C7744)
                          : (fifties['selectedKey'] == 'fifties' &&
                                  fifties['players'][FirebaseAuth.instance
                                          .currentUser!.uid]['selectStats'] ==
                                      true)
                              ? const Color(0xffC02425)
                              : const Color(0xff243b55),
                      borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('50\'s : ${hundredsAndFifties.fifties}',
                          style: AppTextStyles.instance.playersStats),
                      Text(
                        (fifties['selectedKey'] == 'fifties' &&
                                fifties['players'][FirebaseAuth.instance
                                        .currentUser!.uid]['selectStats'] ==
                                    true)
                            ? 'vs ${fifties['selectedValue']}'
                            : '',
                        style: AppTextStyles.instance.playersStat1,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              ]),
            );
          }
          return const CircularProgressIndicator();
        },
      )
    ]);
  }

  topScoreAndWickets(CreatePlayerModel highScoreAndWickets, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var topScore =
                  snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
              return InkWell(
                onTap: !canClick()
                    ? () {
                        showDialog(
                            barrierColor: Colors.black87,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return alertDialogWidget(context);
                            });
                      }
                    : () {
                        GameServices().createSelectStats(
                            selectedKey: 'topScore',
                            selectedValue: highScoreAndWickets.topScore,
                            currentPlayer: currentPlayer,
                            playerName:
                                '${highScoreAndWickets.firstName} ${highScoreAndWickets.lastName}',
                            country: highScoreAndWickets.country);
                        onFeatureSelect(
                            '${highScoreAndWickets.topScore}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStatValue: 'Ruthish',
                            selectStats: selectedFeature ==
                                    '${highScoreAndWickets.topScore}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: 'test', featureSelect: featureSelect);
                      },
                child: Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: selectedFeature ==
                                    '${highScoreAndWickets.topScore}-${index}' &&
                                topScore['selectedKey'] == 'topScore'
                            ? const Color(0xff2C7744)
                            : (topScore['selectedKey'] == 'topScore' &&
                                    topScore['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? const Color(0xffC02425)
                                : const Color(0xff243b55),
                        borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                              'Top Score : ${highScoreAndWickets.topScore}',
                              style: AppTextStyles.instance.playersStats),
                        ),
                        Text(
                          (topScore['selectedKey'] == 'topScore' &&
                                  topScore['players'][FirebaseAuth.instance
                                          .currentUser!.uid]['selectStats'] ==
                                      true)
                              ? 'vs ${topScore['selectedValue']}'
                              : '',
                          style: AppTextStyles.instance.playersStat1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        StreamBuilder(
          stream: getStats().onValue,
          builder: (context, snapShot) {
            if (snapShot.data != null) {
              var wickets =
                  snapShot.data!.snapshot.value as Map<dynamic, dynamic>;
              return InkWell(
                onTap: !canClick()
                    ? () {
                        showDialog(
                            barrierColor: Colors.black87,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return alertDialogWidget(context);
                            });
                      }
                    : () {
                        GameServices().createSelectStats(
                            selectedKey: 'wickets',
                            selectedValue: highScoreAndWickets.wickets,
                            currentPlayer: currentPlayer,
                            playerName:
                                '${highScoreAndWickets.firstName} ${highScoreAndWickets.lastName}',
                            country: highScoreAndWickets.country);
                        onFeatureSelect(
                            '${highScoreAndWickets.wickets}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStatValue: 'Ruthish',
                            selectStats: selectedFeature ==
                                    '${highScoreAndWickets.wickets}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: 'test', featureSelect: featureSelect);
                      },
                child: Row(children: [
                  Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: selectedFeature ==
                                    '${highScoreAndWickets.wickets}-${index}' &&
                                wickets['selectedKey'] == 'wickets'
                            ? const Color(0xff2C7744)
                            : (wickets['selectedKey'] == 'wickets' &&
                                    wickets['players'][FirebaseAuth.instance
                                            .currentUser!.uid]['selectStats'] ==
                                        true)
                                ? const Color(0xffC02425)
                                : const Color(0xff243b55),
                        borderRadius: BorderRadius.all(Radius.circular(12.sp))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Wickets : ${highScoreAndWickets.wickets}',
                            style: AppTextStyles.instance.playersStats),
                        Text(
                          (wickets['selectedKey'] == 'wickets' &&
                                  wickets['players'][FirebaseAuth.instance
                                          .currentUser!.uid]['selectStats'] ==
                                      true)
                              ? 'vs ${wickets['selectedValue']}'
                              : '',
                          style: AppTextStyles.instance.playersStat1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                ]),
              );
            }
            return const CircularProgressIndicator();
          },
        )
      ],
    );
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
              color: const Color(0xffC02425),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  getMatchStatus(CreatePlayerModel status, int index) {
    return StreamBuilder(
        stream: getStats().onValue,
        builder: (context, snapShot) {
          if (snapShot.data != null) {
            var getWon = snapShot.data?.snapshot.value as Map<dynamic, dynamic>;

            return Column(
              children: [
                (getWon['selectedKey'] == 'matches' ||
                            getWon['selectedKey'] == 'batAvg' ||
                            getWon['selectedKey'] == 'strikeRate' ||
                            getWon['selectedKey'] == 'runs' ||
                            getWon['selectedKey'] == 'hundreds' ||
                            getWon['selectedKey'] == 'fifties' ||
                            getWon['selectedKey'] == 'topScore' ||
                            getWon['selectedKey'] == 'wickets') &&
                        (getWon['hostId'] !=
                                FirebaseAuth.instance.currentUser!.uid) !=
                            ''
                    ? canClick() == true
                        ? Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.sp)),
                                color: const Color(0xff243b55),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            child: Text(
                              getWon['matchDrawn'] == true
                                  ? 'Match Drawn'
                                  : 'You Won',
                              style: getWon['matchDrawn'] == true
                                  ? AppTextStyles.instance.cardWinStatus
                                  : AppTextStyles.instance.winStatus,
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.sp)),
                                color: const Color(0xff243b55),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            child: Text(
                              getWon['matchDrawn'] == true
                                  ? 'Match Drawn'
                                  : 'You Loss',
                              style: getWon['matchDrawn'] == true
                                  ? AppTextStyles.instance.cardWinStatus
                                  : AppTextStyles.instance.loseStatus,
                            ),
                          )
                    : Container()
              ],
            );
          }
          return Container();
        });
  }
}
