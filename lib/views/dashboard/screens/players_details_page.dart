import 'package:ds_game/views/authentication/provider/name_provider.dart';
import 'package:ds_game/widgets/app_button.dart';
import 'package:ds_game/widgets/app_text_styles.dart';
import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PlayersDetailsPage extends StatefulWidget {
  const PlayersDetailsPage({Key? key}) : super(key: key);

  @override
  State<PlayersDetailsPage> createState() => _PlayersDetailsPageState();
}

class _PlayersDetailsPageState extends State<PlayersDetailsPage> {
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
                                      style:
                                          AppTextStyles.instance.loginSubHeader,
                                    );
                                  }),
                                  SizedBox(height: 5.sp),
                                  Text(
                                    '(You)',
                                    style:
                                        AppTextStyles.instance.loginSubHeader,
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
                      padding: EdgeInsets.fromLTRB(6.sp, 12.sp, 6.sp, 4.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                          color: const Color(0xff237a57)),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              'Your IP: 192.168.1.182',
                              style: AppTextStyles.instance.loginSubHeader,
                            ),
                            SizedBox(width: 4.sp),
                            Icon(
                              Icons.copy_all_outlined,
                              color: Colors.white,
                              size: 20.sp,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  SizedBox(
                      width: 200.sp,
                      child: AppButton(label: 'Start Game', onPressed: () {}))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Chevron extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xffc33764), Color(0xff1d2671)],
      tileMode: TileMode.clamp,
    );

    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = Paint()..shader = gradient.createShader(colorBounds);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height - size.height / 3);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
