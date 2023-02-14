import 'package:ds_game/views/dashboard/screens/home_page.dart';
import 'package:ds_game/widgets/animation_route.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
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
        body: Container(
          padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 20.sp),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie_images/success.json'),
                  SizedBox(height: 25.sp),
                  Text(
                    'Let\'s play a game !',
                    style: AppTextStyles.instance.playGame,
                  ),
                  SizedBox(height: 25.sp),
                  SizedBox(
                    width: 200.sp,
                    child: AppButton(
                      label: 'Get Started',
                      onPressed: () {
                        NavigationRoute()
                            .animationRoute(context, const HomePage());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
