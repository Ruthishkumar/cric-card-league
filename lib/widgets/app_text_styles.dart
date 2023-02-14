import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final AppTextStyles _singleton = AppTextStyles._internal();
  AppTextStyles._internal();
  static AppTextStyles get instance => _singleton;

  final TextStyle? loginHeader = GoogleFonts.openSans(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
  );

  final TextStyle? otpHeader = GoogleFonts.openSans(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 20.sp,
  );

  final TextStyle? playGame = GoogleFonts.openSans(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 25.sp,
  );

  final TextStyle? loginSubHeader = GoogleFonts.poppins(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
  );
}
