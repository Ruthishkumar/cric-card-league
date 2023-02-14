import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AppButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 15,
          onPrimary: Colors.grey, // foreground
          enabledMouseCursor: MouseCursor.defer,
          surfaceTintColor: Colors.white,
          primary: Colors.black,
          minimumSize: Size.fromHeight(45.sp),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          shadowColor: Colors.black),
      onPressed: () {
        onPressed();
      },
      child: Text(
        label,
        style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal),
      ),
    );
  }
}
