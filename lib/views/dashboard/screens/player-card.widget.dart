import 'package:delayed_display/delayed_display.dart';
import 'package:ds_game/views/dashboard/game_provider/game_provider.dart';
import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/views/dashboard/services/game_services.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PlayerCardWidget extends StatefulWidget {
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

  @override
  State<PlayerCardWidget> createState() => _PlayerCardWidgetState();
}

class _PlayerCardWidgetState extends State<PlayerCardWidget> {
  canClick() {
    return widget.currentPlayer ==
        FirebaseAuth.instance.currentUser?.uid.toString();
  }

  DatabaseReference getStats() {
    DatabaseReference refDb = FirebaseDatabase.instance.ref(
        'Room/${Provider.of<GameProvider>(context, listen: false).host == true ? Provider.of<GameProvider>(context, listen: false).roomId : Provider.of<GameProvider>(context, listen: false).joinRoomId.toString()}');
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
                    ...[widget.playerList.first].map((data) {
                      if (widget.playerList.isNotEmpty) {
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
                                      // bowlAvgAndEcoRate(
                                      //     data, data.toJson().length),
                                      // SizedBox(height: 10.sp),
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
        getMatchStatus(),
        SizedBox(height: 15.sp),
        getLoserCard(),
      ],
    );
  }

  /// matches and batting widget
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
                            currentPlayer: widget.currentPlayer,
                            selectedName: matchAndAverage.firstName,
                            roomId: matches['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId);
                        widget.onFeatureSelect(
                            '${matchAndAverage.matches}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStats: widget.selectedFeature ==
                                    '${matchAndAverage.matches}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: matches['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            featureSelect: featureSelect);
                        HideStatus hide = HideStatus(statusHide: true);
                        GameServices().hideStatus(
                            roomId: matches['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            hideStatus: hide);
                      },
                child: Row(
                  children: [
                    Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: widget.selectedFeature ==
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
                            currentPlayer: widget.currentPlayer,
                            selectedName: matchAndAverage.firstName,
                            roomId: stats['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId);
                        widget.onFeatureSelect(
                            '${matchAndAverage.batAvg}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStats: widget.selectedFeature ==
                                    '${matchAndAverage.batAvg}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: stats['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            featureSelect: featureSelect);
                        HideStatus hide = HideStatus(statusHide: true);
                        GameServices().hideStatus(
                            roomId: stats['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            hideStatus: hide);
                      },
                child: Row(children: [
                  Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: widget.selectedFeature ==
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

  /// strike rate and runs widget
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
                            currentPlayer: widget.currentPlayer,
                            selectedName: strikeAndRuns.firstName,
                            roomId: strikeRate['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId);
                        widget.onFeatureSelect(
                            '${strikeAndRuns.strikeRate}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStats: widget.selectedFeature ==
                                    '${strikeAndRuns.strikeRate}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: strikeRate['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            featureSelect: featureSelect);
                        HideStatus hide = HideStatus(statusHide: true);
                        GameServices().hideStatus(
                            roomId: strikeRate['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            hideStatus: hide);
                      },
                child: Row(
                  children: [
                    Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: widget.selectedFeature ==
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
                            currentPlayer: widget.currentPlayer,
                            selectedName: strikeAndRuns.firstName,
                            roomId: runs['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId);
                        widget
                            .onFeatureSelect('${strikeAndRuns.runs}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStats: widget.selectedFeature ==
                                    '${strikeAndRuns.runs}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: runs['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            featureSelect: featureSelect);
                        HideStatus hide = HideStatus(statusHide: true);
                        GameServices().hideStatus(
                            roomId: runs['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            hideStatus: hide);
                      },
                child: Row(children: [
                  Container(
                      width: 120.sp,
                      height: 65.sp,
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                          color: widget.selectedFeature ==
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

  /// bowl and eco rate widget
  bowlAvgAndEcoRate(CreatePlayerModel bowlAvgAndEcoRate, int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      StreamBuilder(
        stream: getStats().onValue,
        builder: (context, snapShot) {
          if (snapShot.data != null) {
            var bowlAvg =
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
                          selectedKey: 'bowlAvg',
                          selectedValue: bowlAvgAndEcoRate.bowlAvg,
                          currentPlayer: widget.currentPlayer,
                          selectedName: bowlAvgAndEcoRate.firstName,
                          roomId: bowlAvg['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId);
                      widget.onFeatureSelect(
                          '${bowlAvgAndEcoRate.bowlAvg}-${index}');
                      FeatureSelect featureSelect = FeatureSelect(
                          selectStats: widget.selectedFeature ==
                                  '${bowlAvgAndEcoRate.bowlAvg}-${index}'
                              ? true
                              : false);
                      GameServices().selectFeature(
                          roomId: bowlAvg['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          featureSelect: featureSelect);
                      HideStatus hide = HideStatus(statusHide: true);
                      GameServices().hideStatus(
                          roomId: bowlAvg['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          hideStatus: hide);
                    },
              child: Row(children: [
                Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: widget.selectedFeature ==
                                    '${bowlAvgAndEcoRate.bowlAvg}-${index}' &&
                                bowlAvg['selectedKey'] == 'bowlAvg'
                            ? const Color(0xff2C7744)
                            : (bowlAvg['selectedKey'] == 'bowlAvg' &&
                                    bowlAvg['players'][FirebaseAuth.instance
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
                          child: Center(
                            child: Text(
                                'Bowl.Avg : ${bowlAvgAndEcoRate.bowlAvg}',
                                style: AppTextStyles.instance.playersStats),
                          ),
                        ),
                        Text(
                          (bowlAvg['selectedKey'] == 'bowlAvg' &&
                                  bowlAvg['players'][FirebaseAuth.instance
                                          .currentUser!.uid]['selectStats'] ==
                                      true)
                              ? 'vs ${bowlAvg['selectedValue']}'
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
            var ecoRate =
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
                          selectedKey: 'ecoRate',
                          selectedValue: bowlAvgAndEcoRate.ecoRate,
                          currentPlayer: widget.currentPlayer,
                          selectedName: bowlAvgAndEcoRate.firstName,
                          roomId: ecoRate['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId);
                      widget.onFeatureSelect(
                          '${bowlAvgAndEcoRate.ecoRate}-${index}');
                      FeatureSelect featureSelect = FeatureSelect(
                          selectStats: widget.selectedFeature ==
                                  '${bowlAvgAndEcoRate.ecoRate}-${index}'
                              ? true
                              : false);
                      GameServices().selectFeature(
                          roomId: ecoRate['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          featureSelect: featureSelect);
                      HideStatus hide = HideStatus(statusHide: true);
                      GameServices().hideStatus(
                          roomId: ecoRate['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          hideStatus: hide);
                    },
              child: Row(children: [
                Container(
                  width: 120.sp,
                  height: 65.sp,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: widget.selectedFeature ==
                                  '${bowlAvgAndEcoRate.ecoRate}-${index}' &&
                              ecoRate['selectedKey'] == 'ecoRate'
                          ? const Color(0xff2C7744)
                          : (ecoRate['selectedKey'] == 'ecoRate' &&
                                  ecoRate['players'][FirebaseAuth.instance
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
                        child: Text('Eco.Rate : ${bowlAvgAndEcoRate.ecoRate}',
                            style: AppTextStyles.instance.playersStats),
                      ),
                      Text(
                        (ecoRate['selectedKey'] == 'ecoRate' &&
                                ecoRate['players'][FirebaseAuth.instance
                                        .currentUser!.uid]['selectStats'] ==
                                    true)
                            ? 'vs ${ecoRate['selectedValue']}'
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

  /// hundreds and fifties widget
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
                          currentPlayer: widget.currentPlayer,
                          selectedName: hundredsAndFifties.firstName,
                          roomId: hundreds['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId);
                      widget.onFeatureSelect(
                          '${hundredsAndFifties.hundreds}-${index}');
                      FeatureSelect featureSelect = FeatureSelect(
                          selectStats: widget.selectedFeature ==
                                  '${hundredsAndFifties.hundreds}-${index}'
                              ? true
                              : false);
                      GameServices().selectFeature(
                          roomId: hundreds['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          featureSelect: featureSelect);
                      HideStatus hide = HideStatus(statusHide: true);
                      GameServices().hideStatus(
                          roomId: hundreds['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          hideStatus: hide);
                    },
              child: Row(children: [
                Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: widget.selectedFeature ==
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
                          currentPlayer: widget.currentPlayer,
                          selectedName: hundredsAndFifties.firstName,
                          roomId: fifties['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId);
                      widget.onFeatureSelect(
                          '${hundredsAndFifties.fifties}-${index}');
                      FeatureSelect featureSelect = FeatureSelect(
                          selectStats: widget.selectedFeature ==
                                  '${hundredsAndFifties.fifties}-${index}'
                              ? true
                              : false);
                      GameServices().selectFeature(
                          roomId: fifties['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          featureSelect: featureSelect);
                      HideStatus hide = HideStatus(statusHide: true);
                      GameServices().hideStatus(
                          roomId: fifties['hostId'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Provider.of<GameProvider>(context,
                                      listen: false)
                                  .joinRoomId
                              : Provider.of<GameProvider>(context,
                                      listen: false)
                                  .roomId,
                          hideStatus: hide);
                    },
              child: Row(children: [
                Container(
                  width: 120.sp,
                  height: 65.sp,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: widget.selectedFeature ==
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

  /// top score and wickets widget
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
                            currentPlayer: widget.currentPlayer,
                            selectedName: highScoreAndWickets.firstName,
                            roomId: topScore['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId);
                        widget.onFeatureSelect(
                          '${highScoreAndWickets.topScore}-${index}',
                        );
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStats: widget.selectedFeature ==
                                    '${highScoreAndWickets.topScore}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: topScore['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            featureSelect: featureSelect);
                        HideStatus hide = HideStatus(statusHide: true);
                        GameServices().hideStatus(
                            roomId: topScore['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            hideStatus: hide);
                      },
                child: Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: widget.selectedFeature ==
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
                            currentPlayer: widget.currentPlayer,
                            selectedName: highScoreAndWickets.firstName,
                            roomId: wickets['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId);
                        widget.onFeatureSelect(
                            '${highScoreAndWickets.wickets}-${index}');
                        FeatureSelect featureSelect = FeatureSelect(
                            selectStats: widget.selectedFeature ==
                                    '${highScoreAndWickets.wickets}-${index}'
                                ? true
                                : false);
                        GameServices().selectFeature(
                            roomId: wickets['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            featureSelect: featureSelect);
                        HideStatus hide = HideStatus(statusHide: true);
                        GameServices().hideStatus(
                            roomId: wickets['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Provider.of<GameProvider>(context,
                                        listen: false)
                                    .joinRoomId
                                : Provider.of<GameProvider>(context,
                                        listen: false)
                                    .roomId,
                            hideStatus: hide);
                      },
                child: Row(children: [
                  Container(
                    width: 120.sp,
                    height: 65.sp,
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                        color: widget.selectedFeature ==
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

  /// player header widget
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

  /// match status
  getMatchStatus() {
    return StreamBuilder(
      stream: getStats().onValue,
      builder: (context, snapShot) {
        if (snapShot.data != null) {
          var getWon = snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
          return (getWon['statusHide'] == true)
              ? Column(
                  children: [
                    (getWon['selectedKey'] == 'matches' ||
                                getWon['selectedKey'] == 'batAvg' ||
                                getWon['selectedKey'] == 'strikeRate' ||
                                getWon['selectedKey'] == 'runs' ||
                                getWon['selectedKey'] == 'hundreds' ||
                                getWon['selectedKey'] == 'fifties' ||
                                getWon['selectedKey'] == 'topScore' ||
                                getWon['selectedKey'] == 'wickets' ||
                                getWon['selectedKey'] == 'bowlAvg' ||
                                getWon['selectedKey'] == 'ecoRate') &&
                            (getWon['hostId'] !=
                                    FirebaseAuth.instance.currentUser!.uid) !=
                                ''
                        ? DelayedDisplay(
                            slidingBeginOffset: getWon['statusHide'] == true
                                ? const Offset(-1, 0)
                                : const Offset(0, -1),
                            delay: const Duration(microseconds: 1),
                            child: Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.sp)),
                                    color: const Color(0xff243b55),
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Text(
                                    getWon['matchDrawn'] == true
                                        ? 'Match Drawn'
                                        : canClick() == true
                                            ? 'You Won'
                                            : 'You Lose',
                                    style:
                                        AppTextStyles.instance.cardWinStatus)),
                          )
                        : Container()
                  ],
                )
              : Container();
        }
        return Container();
      },
    );
  }

  /// loser card banner
  getLoserCard() {
    return StreamBuilder(
      stream: getStats().onValue,
      builder: (context, snapShot) {
        if (snapShot.data != null) {
          var getLoserCard =
              snapShot.data?.snapshot.value as Map<dynamic, dynamic>;
          return getLoserCard['players'][FirebaseAuth.instance.currentUser!.uid]
                      ['recentlyWon'] ==
                  null
              ? Container()
              : getLoserCard['matchDrawn'] == true
                  ? Container()
                  : canClick() == true
                      ? DelayedDisplay(
                          slidingBeginOffset: const Offset(0.0, 0.35),
                          delay: const Duration(milliseconds: 1),
                          child: Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.sp)),
                                color: const Color(0xff243b55),
                                border: Border.all(
                                    color: getLoserCard['players'][FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid]['recentlyWon'] ==
                                            null
                                        ? Colors.transparent
                                        : Colors.white,
                                    width: 1)),
                            child: Column(
                              children: [
                                Text(
                                  getLoserCard['players'][FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid]['recentlyWon'] ==
                                          null
                                      ? ''
                                      : '${getLoserCard['players'][FirebaseAuth.instance.currentUser!.uid]['recentlyWon']['firstName']}'
                                          ' ${getLoserCard['players'][FirebaseAuth.instance.currentUser!.uid]['recentlyWon']['lastName']}',
                                  style: AppTextStyles.instance.cardWinStatus,
                                ),
                                SizedBox(height: 10.sp),
                                Text(
                                    getLoserCard['players'][FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid]['recentlyWon'] ==
                                            null
                                        ? ''
                                        : getLoserCard['players'][FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid]['recentlyWon']['country'],
                                    style:
                                        AppTextStyles.instance.cardWinStatus),
                              ],
                            ),
                          ),
                        )
                      : Container();
        }
        return Container();
      },
    );
  }
}
