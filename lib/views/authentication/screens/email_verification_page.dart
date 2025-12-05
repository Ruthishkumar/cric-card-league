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

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        bodyWidget: Container(
            padding: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 20.sp),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 100,
                    color: Color(0xff2c3e50),
                  ),
                  Text("Verify your email address",
                      style: AppTextStyles.instance.loginHeader),
                  SizedBox(height: 10.sp),
                  Text(
                    "We have just send email verification link on your email. Please check email and click on that link to verify your email address.",
                    style:
                        AppTextStyles.instance.emailVerificationLinkSubHeader,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.sp),
                  Text(
                    "If not auto redirected after verification, please click on the continue button.",
                    style:
                        AppTextStyles.instance.emailVerificationLinkSubHeader,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.sp),
                  HostingButton(
                      text: 'Continue',
                      color: const Color(0xff12c2e9),
                      onPressed:
                          isChecking ? () {} : continueVerificationEmail),
                  SizedBox(height: 20.sp),
                  HostingButton(
                    text: 'Resend E-Mail Link',
                    color: const Color(0xffFF951A),
                    onPressed: resentEmailLink,
                  ),
                  SizedBox(height: 20.sp),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back,
                            size: 20.sp, color: const Color(0xff2c3e50)),
                        SizedBox(width: 10.w),
                        Text(
                          'Back to Login',
                          style: AppTextStyles
                              .instance.emailVerificationLinkSubHeader,
                        )
                      ],
                    ),
                  )
                ])));
  }

  bool isChecking = false;

  /// continue verification email
  continueVerificationEmail() async {
    setState(() => isChecking = true);
    bool isVerified = false;

    await FirebaseAuth.instance.currentUser!.reload();
    final user = FirebaseAuth.instance.currentUser!;
    isVerified = user.emailVerified;

    setState(() => isChecking = false);

    if (isVerified) {
      log('User Id ${user.uid}');
      await StorageServices().setUserId(user.uid.toString());
      await StorageServices().setUserActive(user.uid != '' ? true : false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SuccessPage()),
          (route) => false);
    } else {
      Fluttertoast.showToast(
          msg: "Email not verified yet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  /// resent email link
  resentEmailLink() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    Fluttertoast.showToast(
        msg: "Verification email sent again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
