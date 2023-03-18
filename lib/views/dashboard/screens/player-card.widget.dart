import 'dart:developer';
import 'package:ds_game/views/dashboard/model/game_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../widgets/app_text_styles.dart';

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
            width: 250.sp,
            decoration: BoxDecoration(
                color: const Color(0xff243b55),
                borderRadius: BorderRadius.all(Radius.circular(16.sp))),
            child: Column(
              children: [
                ...playerList.map((data) {
                  return Column(
                    children: [
                      Container(
                        width: 250.sp,
                        padding:
                            EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 12.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.firstName,
                                      style:
                                          AppTextStyles.instance.cardFirstName),
                                  Text(data.lastName,
                                      style: AppTextStyles
                                          .instance.cardSecondName),
                                  SizedBox(height: 10.sp),
                                  Text(data.country.toUpperCase(),
                                      style:
                                          AppTextStyles.instance.countryName),
                                ]),
                            Image.asset(
                                'assets/images/Virat-Kohli-T20I2020.png',
                                height: 50.sp,
                                width: 50.sp)
                          ],
                        ),
                      ),
                      if (data.feature != null)
                        ...data.feature!.keys.map((e) {
                          return Container(
                            width: double.infinity,
                            padding:
                                EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 12.sp),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.sp))),
                            child: Column(
                              children: [
                                StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  itemCount:
                                      data.feature?[e]!.toJson().keys.length,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 4,
                                  itemBuilder: (context, index) {
                                    dynamic feat = data.feature![e]!
                                        .toJson()[index]
                                        .toString();
                                    // log(feat.toString());
                                    // log('FEST');
                                    return GestureDetector(
                                      onTap: () {
                                        onFeatureSelect(
                                            '${data.firstName}-${index}');
                                        log(index.toString());
                                        log('Feature Select');
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedFeature ==
                                                      '${data.firstName}-${index}'
                                                  ? Colors.green
                                                  : const Color(0xff243b55),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.sp))),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    data.feature![e]!
                                                        .toJson()[index]
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .instance.playersStats),
                                                Text(' : ${feat.toString()}',
                                                    style: AppTextStyles
                                                        .instance.playersStats)
                                              ])),
                                    );
                                  },
                                  staggeredTileBuilder: (index) {
                                    if (playerList.length % 2 != 0 &&
                                        playerList.length - 1 == index) {
                                      return const StaggeredTile.count(4, 1);
                                    }
                                    return const StaggeredTile.count(2, 1);
                                  },
                                ),
                              ],
                            ),
                          );
                        })
                    ],
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
