import 'package:ds_game/widgets/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HostJoinPage extends StatefulWidget {
  const HostJoinPage({Key? key}) : super(key: key);

  @override
  State<HostJoinPage> createState() => _HostJoinPageState();
}

class _HostJoinPageState extends State<HostJoinPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        bodyWidget: Container(
      padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 20.sp),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/images/yger_va3l_160530.jpg')),
            SizedBox(height: 20.sp),
            ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.sp)))),
              child: Container(
                width: 250.sp,
                padding: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 10.sp),
                decoration: const BoxDecoration(
                    color: Colors.green,
                    border: Border(
                        top: BorderSide(color: Colors.white, width: 7.0))),
                child: Text(
                  'Host'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.actor(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp),
                ),
              ),
            ),
            SizedBox(height: 30.sp),
            ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.sp)))),
              child: Container(
                width: 250.sp,
                padding: EdgeInsets.fromLTRB(15.sp, 10.sp, 15.sp, 10.sp),
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    border: Border(
                        top: BorderSide(color: Colors.white, width: 7.0))),
                child: Text(
                  'Join'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.actor(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
