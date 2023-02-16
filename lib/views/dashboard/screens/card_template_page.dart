import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTemplatePage extends StatefulWidget {
  const CardTemplatePage({Key? key}) : super(key: key);

  @override
  State<CardTemplatePage> createState() => _CardTemplatePageState();
}

class _CardTemplatePageState extends State<CardTemplatePage> {
  @override
  Widget build(BuildContext context) {
    var gridList = [
      {'statsHeader': 'Matches :'},
      {'statsHeader': 'Balls bwld :'},
      {'statsHeader': 'Runs :'},
      {'statsHeader': 'Wickets :'},
      {'statsHeader': 'Bat avg :'},
      {'statsHeader': 'Bowl avg :'},
      {'statsHeader': '100s :'},
      {'statsHeader': 'Catches :'},
      {'statsHeader': '50s :'},
      {'statsHeader': 'Stumping :'},
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        padding: EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 0.sp),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Virat',
                                        style: AppTextStyles
                                            .instance.cardFirstName,
                                      ),
                                      Text(
                                        'Kohli',
                                        style: AppTextStyles
                                            .instance.cardSecondName,
                                      ),
                                      SizedBox(height: 10.sp),
                                      Text(
                                        'India'.toUpperCase(),
                                        style:
                                            AppTextStyles.instance.countryName,
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/Virat-Kohli-T20I2020.png',
                                  height: 150.sp,
                                  width: 100.sp,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 12.sp),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.sp))),
                        child: Column(
                          children: [
                            GridView.builder(
                                shrinkWrap: true,
                                itemCount: gridList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: (1 / .3),
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                itemBuilder: (BuildContext context, int index) {
                                  Map data = gridList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xff243b55),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.sp))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['statsHeader'],
                                          style: AppTextStyles
                                              .instance.playersStats,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            SizedBox(height: 15.sp),
                            Container(
                              width: 120.sp,
                              padding:
                                  EdgeInsets.fromLTRB(12.sp, 8.sp, 12.sp, 8.sp),
                              decoration: BoxDecoration(
                                  color: const Color(0xff243b55),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.sp))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top Score :',
                                    style: AppTextStyles.instance.playersStats,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
