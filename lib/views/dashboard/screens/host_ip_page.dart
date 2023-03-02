import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HostIpPage extends StatefulWidget {
  const HostIpPage({Key? key}) : super(key: key);

  @override
  State<HostIpPage> createState() => _HostIpPageState();
}

class _HostIpPageState extends State<HostIpPage> {
  TextEditingController hostIpController = TextEditingController();
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
                                Text(
                                  'Enter Host IP address and press join button',
                                  style: AppTextStyles.instance.hostAndJoinName,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 5.sp),
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
                    child: TextFormField(
                        controller: hostIpController,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.sp),
                        decoration: InputDecoration(
                            fillColor: const Color(0xff237a57),
                            filled: true,
                            errorStyle: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.sp,
                                color: const Color(0xffF15252)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.sp),
                              borderSide:
                                  const BorderSide(color: Color(0xffF15252)),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                                borderSide: const BorderSide(
                                    color: Color(0xffD2D2D4), width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                                borderSide: const BorderSide(
                                    color: Colors.black87, width: 1)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                                borderSide: const BorderSide(
                                    color: Color(0xffD2D2D4), width: 1)),
                            contentPadding:
                                EdgeInsets.fromLTRB(10.sp, 15.sp, 0.sp, 0.sp),
                            labelStyle: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.sp),
                            hintStyle: GoogleFonts.openSans(
                                fontSize: 16.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                            hintText: 'Enter Host IP'))),
                SizedBox(height: 20.sp),
                SizedBox(
                    width: 200.sp,
                    child: AppButton(label: 'Join', onPressed: () {}))
              ],
            ),
          ),
        )
      ],
    ));
  }
}
