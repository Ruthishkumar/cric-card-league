import 'dart:developer';

import 'package:ds_game/views/authentication/screens/success_page.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final String mobileNumber;
  final String verifyId;
  final FirebaseAuth auth;
  const OtpPage(
      {Key? key,
      required this.mobileNumber,
      required this.verifyId,
      required this.auth})
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

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      bodyWidget: Container(
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
                    Image.asset('assets/images/cricket_fever.jpg'),
                    SizedBox(height: 25.sp),
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
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            color: const Color(0xff2c3e50),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '+91 ${widget.mobileNumber}',
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2c3e50),
                          ),
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
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xff1E1E26)))),
                    ),
                  ],
                ),
              ),
            ),
            LoginFancyButton(
              text: 'Verify Otp',
              color: const Color(0xffFF951A),
              onPressed: _onVerifyOtp,
            ),
          ],
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
        color: Colors.white,
        fontWeight: FontWeight.w400),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffD2D2D4)),
      color: Colors.grey.withOpacity(0.8),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  /// verify otp summit
  _onVerifyOtp() async {
    try {
      if (validate()) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: widget.verifyId, smsCode: otpController.text);
        await widget.auth.signInWithCredential(credential).then((value) async {
          log(FirebaseAuth.instance.currentUser!.uid.toString());
          await StorageServices()
              .setUserId(FirebaseAuth.instance.currentUser!.uid.toString());
          await StorageServices().setUserActive(
              FirebaseAuth.instance.currentUser!.uid != '' ? true : false);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SuccessPage()),
              (route) => false);
        });
      }
    } on FirebaseAuthException catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// validate otp
  bool validate() {
    if (otpController.text == '') {
      Fluttertoast.showToast(
          msg: "Invalid Otp",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else {
      return true;
    }
  }
}
