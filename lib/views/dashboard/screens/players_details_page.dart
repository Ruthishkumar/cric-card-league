import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/views/dashboard/screens/card_template_page.dart';
import 'package:ds_game/views/dashboard/screens/coin_flip_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlayersDetailsPage extends StatefulWidget {
  const PlayersDetailsPage({Key? key}) : super(key: key);

  @override
  State<PlayersDetailsPage> createState() => _PlayersDetailsPageState();
}

class _PlayersDetailsPageState extends State<PlayersDetailsPage> {
  final List<String> cardItems = [
    '10',
    '20',
    '30',
    '40',
  ];
  String? selectedValue;
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
              child: Column(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.sp))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer<NameProvider>(
                                      builder: (context, data, value) {
                                    return Text(
                                      data.playerName,
                                      style: AppTextStyles
                                          .instance.hostAndJoinName,
                                    );
                                  }),
                                  SizedBox(height: 5.sp),
                                  Text(
                                    '(You)',
                                    style:
                                        AppTextStyles.instance.hostAndJoinName,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: -15,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(15 / 360),
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
                                  border:
                                      Border.all(color: Colors.white, width: 5),
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
                        borderRadius: BorderRadius.all(Radius.circular(8.sp))),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(4.sp, 10.sp, 4.sp, 4.sp),
                      padding: EdgeInsets.fromLTRB(4.sp, 12.sp, 4.sp, 4.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                          color: const Color(0xff237a57)),
                      child: Center(
                        child: Text(
                          'Your IP: 192.168.1.182',
                          style: AppTextStyles.instance.ipAddress,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.sp,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            icon: Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.white,
                              size: 25.sp,
                            ),
                            hint: Text(
                              'Cards',
                              style: GoogleFonts.prompt(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            buttonPadding: const EdgeInsets.only(
                              left: 14,
                              right: 14,
                            ),
                            itemPadding:
                                EdgeInsets.only(left: 14.sp, right: 14.sp),
                            itemHighlightColor: Colors.blue,
                            items: cardItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Row(
                                        children: [
                                          Text(
                                            item,
                                            style: GoogleFonts.prompt(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          // Icon(Icons.add)
                                        ],
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              border: Border.all(
                                color: const Color(0xff093028),
                              ),
                              color: const Color(0xff093028),
                            ),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.sp),
                              color: const Color(0xff093028),
                            ),
                            itemHeight: 40,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.sp),
                      SizedBox(
                          width: 150.sp,
                          child: AppButton(
                              label: 'New Game',
                              onPressed: () {
                                NavigationRoute()
                                    .animationRoute(context, CoinFlipScreen());
                              }))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
