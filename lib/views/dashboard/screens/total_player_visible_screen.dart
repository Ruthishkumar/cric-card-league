import 'package:ds_game/views/dashboard/model/game_model.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalPlayerVisibleScreen extends StatelessWidget {
  final List<CreatePlayerModel> playerList;

  const TotalPlayerVisibleScreen({
    Key? key,
    required this.playerList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 20.sp,
            runSpacing: 20.sp,
            children: [
              for (int i = 0; i < playerList.length; i++)
                ...[playerList[i]].map((data) {
                  if (playerList.isNotEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff141E30),
                          border: Border.all(color: Colors.white, width: 1.sp),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.sp))),
                      child: SizedBox(
                        height: 180.sp,
                        width: 190.sp,
                        child: playerHeaderWidget(data),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
            ],
          ),
        ],
      ),
    );
  }

  matchesAndBatAvg(CreatePlayerModel matchAndAverage, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Container(
              width: 120.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                  color: const Color(0xff243b55),
                  borderRadius: BorderRadius.all(Radius.circular(12.sp))),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Matches : ${matchAndAverage.matches}',
                  style: AppTextStyles.instance.playersStats,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        Row(children: [
          Container(
              width: 120.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                  color: const Color(0xff243b55),
                  borderRadius: BorderRadius.all(Radius.circular(12.sp))),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text('Bat.Avg : ${matchAndAverage.batAvg}',
                    style: AppTextStyles.instance.playersStats),
              ))
        ])
      ],
    );
  }

  strikeRateAndRuns(CreatePlayerModel strikeAndRuns, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Container(
              width: 120.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                  color: const Color(0xff243b55),
                  borderRadius: BorderRadius.all(Radius.circular(12.sp))),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Str.Rate : ${strikeAndRuns.strikeRate}',
                  style: AppTextStyles.instance.playersStats,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.sp),
        Row(children: [
          Container(
              width: 120.sp,
              height: 40.sp,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                  color: const Color(0xff243b55),
                  borderRadius: BorderRadius.all(Radius.circular(12.sp))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('Runs : ${strikeAndRuns.runs}',
                        style: AppTextStyles.instance.playersStats),
                  ),
                ],
              ))
        ])
      ],
    );
  }

  hundredsAndFifties(CreatePlayerModel hundredsAndFifties, int index) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(children: [
        Container(
            width: 120.sp,
            height: 40.sp,
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
                color: const Color(0xff243b55),
                borderRadius: BorderRadius.all(Radius.circular(12.sp))),
            child: Center(
              child: Text('100\'s : ${hundredsAndFifties.hundreds}',
                  style: AppTextStyles.instance.playersStats),
            ))
      ]),
      Row(children: [
        Container(
          width: 120.sp,
          height: 40.sp,
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
              color: const Color(0xff243b55),
              borderRadius: BorderRadius.all(Radius.circular(12.sp))),
          child: Center(
            child: Text('50\'s : ${hundredsAndFifties.fifties}',
                style: AppTextStyles.instance.playersStats),
          ),
        )
      ])
    ]);
  }

  topScoreAndWickets(CreatePlayerModel highScoreAndWickets, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 120.sp,
            height: 40.sp,
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
                color: const Color(0xff243b55),
                borderRadius: BorderRadius.all(Radius.circular(12.sp))),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text('Top Score : ${highScoreAndWickets.topScore}',
                  style: AppTextStyles.instance.playersStats),
            )),
        Row(children: [
          Container(
            width: 120.sp,
            height: 40.sp,
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
                color: const Color(0xff243b55),
                borderRadius: BorderRadius.all(Radius.circular(12.sp))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Wickets : ${highScoreAndWickets.wickets}',
                    style: AppTextStyles.instance.playersStats),
              ],
            ),
          )
        ])
      ],
    );
  }

  playerHeaderWidget(CreatePlayerModel playerHeaderData) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(playerHeaderData.firstName,
          style: AppTextStyles.instance.visibleNames),
      SizedBox(height: 2.sp),
      Text(
        playerHeaderData.lastName,
        style: AppTextStyles.instance.visibleNames,
      ),
      SizedBox(height: 2.sp),
      Text(playerHeaderData.country.toUpperCase(),
          style: AppTextStyles.instance.visibleCountry),
    ]);
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * .03, size.height);
    path.quadraticBezierTo(
        size.width * .2, size.height * .5, size.width * .03, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
