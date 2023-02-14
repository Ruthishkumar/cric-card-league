import 'dart:developer';

import 'package:ds_game/views/authentication/screens/success_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final String mobileNumber;
  final String vid;
  const OtpPage({Key? key, required this.mobileNumber, required this.vid})
      : super(key: key);

  static String verify = "";

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();
  String _otp = '';

  late final otpFocusNode = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 100.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/otp_success.png'),
                      Text(
                        'Enter Verification Code',
                        style: AppTextStyles.instance.otpHeader,
                      ),
                      SizedBox(height: 20.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'OTP Sent to',
                            style: GoogleFonts.openSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '+91 ${widget.mobileNumber}',
                            style: GoogleFonts.openSans(
                                fontSize: 14.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp),
                      Pinput(
                        showCursor: true,
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsUserConsentApi,
                        defaultPinTheme: defaultPinTheme,
                        focusNode: otpFocusNode,
                        focusedPinTheme: defaultPinTheme.copyDecorationWith(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _otp = value;
                          });
                        },
                        controller: otpController,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration?.copyWith(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xff1E1E26)))),
                      ),
                    ],
                  ),
                ),
              ),
              AppButton(
                label: 'Verify Otp',
                onPressed: _onVerifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// pin put default theme
  final defaultPinTheme = PinTheme(
    width: 48.sp,
    height: 48.sp,
    textStyle: GoogleFonts.openSans(
        fontSize: 16.sp,
        fontStyle: FontStyle.normal,
        color: const Color(0xff1E1E26),
        fontWeight: FontWeight.w400),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffD2D2D4)),
      color: Colors.white70.withOpacity(0.7),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  /// verify otp summit
  _onVerifyOtp() async {
    try {
      NavigationRoute().animationRoute(context, const SuccessPage());
      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
      //     verificationId: widget.vid, smsCode: otpController.text);
      // await auth.signInWithCredential(credential).then((value) {
      //   if (value.user != null) {
      //     setState(() {
      //       log('Authentication Successful');
      //
      //     });
      //   } else {
      //     setState(() {
      //       log('Authentication Failed');
      //     });
      //   }
      // });
    } on FirebaseAuthException catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// validate otp
  bool validate() {
    if (otpController.text == '') {
      return false;
    } else {
      return true;
    }
  }
}
