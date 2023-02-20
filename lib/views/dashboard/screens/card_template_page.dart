import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardTemplatePage extends StatefulWidget {
  const CardTemplatePage({Key? key}) : super(key: key);

  @override
  State<CardTemplatePage> createState() => _CardTemplatePageState();
}

class _CardTemplatePageState extends State<CardTemplatePage> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

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
            padding: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 20.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffF2C94C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.sp))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 57,
                                    height: 57,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.sp)),
                                        color: Colors.white),
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    )),
                                Container(
                                  padding: EdgeInsets.all(16.sp),
                                  child: Text(
                                    'Your Cards',
                                    style: GoogleFonts.prompt(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.sp,
                                        color: Colors.white),
                                  ),
                                ),
                                Container(
                                  width: 57,
                                  height: 57,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.sp)),
                                  ),
                                  child: Center(child: Consumer<NameProvider>(
                                    builder: (widget, data, child) {
                                      return Text(data.cardTotal.toString(),
                                          style: GoogleFonts.prompt(
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.sp,
                                              color: Colors.black));
                                    },
                                  )),
                                )
                              ],
                            )),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(15.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xffF2C94C),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 12)
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100.sp),
                          bottomRight: Radius.circular(100.sp),
                        ),
                      ),
                      child: scorePoints(),
                    ),
                  ],
                ),
                SizedBox(height: 30.sp),
                FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff243b55),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white70.withOpacity(0.3), //New
                                blurRadius: 5.0,
                                spreadRadius: 5.0)
                          ],
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.sp))),
                      alignment: Alignment.center,
                      width: 250.sp,
                      height: 450.sp,
                      child: Text(
                        "Tap to Open the Card",
                        style: AppTextStyles.instance.points,
                      ),
                    ),
                    back: Container(
                      width: 250.sp,
                      decoration: BoxDecoration(
                          color: const Color(0xff243b55),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white70.withOpacity(0.3), //New
                                blurRadius: 5.0,
                                spreadRadius: 5.0)
                          ],
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.sp))),
                      child: Column(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.fromLTRB(12.sp, 12.sp, 12.sp, 0.sp),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            style: AppTextStyles
                                                .instance.countryName,
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: (1 / .3),
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                  padding: EdgeInsets.fromLTRB(
                                      12.sp, 8.sp, 12.sp, 8.sp),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff243b55),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.sp))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Top Score :',
                                        style:
                                            AppTextStyles.instance.playersStats,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 30.sp),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  scorePoints() {
    if (Provider.of<NameProvider>(context, listen: false).noOfCards == 0) {
      return Text(
        '1000\nPoints',
        style: AppTextStyles.instance.points,
      );
    } else if (Provider.of<NameProvider>(context, listen: false).noOfCards ==
        1) {
      return Text(
        '2000\nPoints',
        style: AppTextStyles.instance.points,
      );
    } else if (Provider.of<NameProvider>(context, listen: false).noOfCards ==
        2) {
      return Text(
        '3000\nPoints',
        style: AppTextStyles.instance.points,
      );
    }
    return const Text(
      'No Points',
    );
  }
}
