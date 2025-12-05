import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final AppTextStyles _singleton = AppTextStyles._internal();
  AppTextStyles._internal();
  static AppTextStyles get instance => _singleton;

  final TextStyle? loginHeader = GoogleFonts.prompt(
    color: const Color(0xff2c3e50),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
  );

  final TextStyle? otpHeader = GoogleFonts.prompt(
    color: const Color(0xff2c3e50),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 20.sp,
  );

  final TextStyle? playGame = GoogleFonts.openSans(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontSize: 20.sp,
  );

  final TextStyle? loginSubHeader = GoogleFonts.prompt(
    color: const Color(0xff2c3e50),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
  );

  final TextStyle? emailVerificationLinkSubHeader = GoogleFonts.prompt(
    color: const Color(0xff2c3e50),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 15.sp,
  );

  final TextStyle? hostAndJoinName = GoogleFonts.prompt(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );

  final TextStyle? ipAddress = GoogleFonts.prompt(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
  );

  final TextStyle? tossHeader = GoogleFonts.prompt(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );

  final TextStyle? tossStatus = GoogleFonts.prompt(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 15.sp,
  );

  final TextStyle? cardWinStatus = GoogleFonts.prompt(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );
  final TextStyle? winStatus = GoogleFonts.prompt(
    color: Colors.green,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );
  final TextStyle? loseStatus = GoogleFonts.prompt(
    color: Colors.red,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );

  final TextStyle? points = GoogleFonts.prompt(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
  );

  final TextStyle? cardFirstName = GoogleFonts.poppins(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w200,
    fontSize: 25.sp,
  );
  final TextStyle? visibleNames = GoogleFonts.poppins(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 20.sp,
  );
  final TextStyle? visibleCountry = GoogleFonts.poppins(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    fontSize: 20.sp,
  );

  final TextStyle? cardSecondName = GoogleFonts.poppins(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 30.sp,
  );

  final TextStyle? countryName = GoogleFonts.poppins(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    fontSize: 15.sp,
  );

  final TextStyle? playersStats = GoogleFonts.prompt(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
    fontSize: 15.sp,
  );

  final TextStyle? playersStat1 = GoogleFonts.prompt(
    color: Colors.black87,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    fontSize: 15.sp,
  );

  final TextStyle? popError = GoogleFonts.prompt(
      color: Colors.black,
      fontSize: 20.sp,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600);

  final TextStyle? alert = GoogleFonts.prompt(
      color: Colors.black,
      fontSize: 15.sp,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}
