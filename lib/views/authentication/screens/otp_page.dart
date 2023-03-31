import 'dart:developer';

import 'package:ds_game/views/authentication/screens/success_page.dart';
import 'package:ds_game/views/authentication/services/storage_services.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/login_fancy_button.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

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
                    PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      textStyle: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10.sp),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        inactiveFillColor: Colors.white,
                        inactiveColor: Colors.white,
                        selectedColor: Colors.grey.withOpacity(0.8),
                        selectedFillColor: Colors.white,
                        activeFillColor: Colors.white,
                        activeColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        _otp = v;
                      },
                      onChanged: (value) {
                        setState(() {
                          _otp = value;
                        });
                      },
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
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// validate otp
  bool validate() {
    if (_otp == '') {
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
