import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ds_game/views/authentication/screens/otp_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_input_text_outline.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();

  late final myFocusNode = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  static String verify = "";

  @override
  Widget build(BuildContext context) {
    TextStyle colorizeTextStyle = GoogleFonts.actor(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal);
    const colorizeColors = [
      Colors.white,
      Colors.blue,
      Colors.orange,
      Colors.red,
    ];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.fromLTRB(20.sp, 10.sp, 20.sp, 20.sp),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DefaultTextStyle(
                      style: GoogleFonts.lato(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      child: Center(
                        child: AnimatedTextKit(
                          repeatForever: true,
                          isRepeatingAnimation: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Welcome Creeds',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                            ColorizeAnimatedText(
                              'Stay Curious',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                            ColorizeAnimatedText(
                              'Get Ready !!!',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                          ],
                          onTap: () {
                            log("Tap Event");
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 50.sp),
                    Text('Login', style: AppTextStyles.instance.loginHeader),
                    SizedBox(height: 15.sp),
                    Text(
                        'We need to register your phone before getting started !',
                        style: AppTextStyles.instance.loginSubHeader),
                    SizedBox(height: 30.sp),
                    AppInputTextOutline(
                        inputController: phoneNumberController,
                        hintText: 'Enter Your Phone Number',
                        focusNode: myFocusNode,
                        isNumber: true,
                        fillColor: myFocusNode.hasFocus
                            ? Colors.white
                            : Colors.white70.withOpacity(0.7),
                        textInputAction: TextInputAction.done,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Valid name' : null),
                    SizedBox(height: 20.sp),
                    AppButton(
                      label: 'Send the code',
                      onPressed: _onSummitLogin,
                    ),
                    SizedBox(height: 20.sp),
                    Center(
                        child: Text('Or',
                            style: AppTextStyles.instance.loginSubHeader)),
                    SizedBox(height: 20.sp),
                    Row(
                      children: [
                        Container(
                            height: 1.sp, width: 100.sp, color: Colors.white),
                        SizedBox(width: 10.sp),
                        Text('Continue with',
                            style: AppTextStyles.instance.loginSubHeader),
                        SizedBox(width: 10.sp),
                        Container(
                            height: 1.sp, width: 100.sp, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: _googleLogin,
                            child:
                                SvgPicture.asset('assets/images/google.svg')),
                        GestureDetector(
                            onTap: _faceBookSignIn,
                            child:
                                SvgPicture.asset('assets/images/facebook.svg')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  /// LogIn Summit function
  _onSummitLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (validate()) {
      log('Success');
      // await FirebaseAuth.instance.verifyPhoneNumber(
      //   phoneNumber: '+91 ${phoneNumberController.text}',
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     await auth.signInWithCredential(credential);
      //   },
      //   verificationFailed: (FirebaseAuthException e) {
      //     log(e.toString());
      //   },
      //   codeSent: (String verificationId, int? resendToken) {
      //     verify = verificationId.toString();
      //     log('Code Sent');
      //   },
      //   codeAutoRetrievalTimeout: (String verificationId) {},
      // );
      // if (!mounted) {
      //   return;
      // }
      NavigationRoute().animationRoute(context,
          OtpPage(mobileNumber: phoneNumberController.text, vid: verify));
    }
  }

  /// google auth
  _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// facebook auth
  _faceBookSignIn() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
    }
  }

  /// controller validation
  bool validate() {
    if (phoneNumberController.text == '') {
      // Fluttertoast.showToast(
      //     msg: "New features is coming",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: const Color(0xff22BBB0),
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return false;
    } else {
      return true;
    }
  }
}
