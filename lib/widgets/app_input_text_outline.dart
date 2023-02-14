import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInputTextOutline extends StatelessWidget {
  final TextEditingController inputController;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final String hintText;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final bool? isNumber;
  final List<TextInputFormatter>? inputFormatters;

  const AppInputTextOutline(
      {Key? key,
      required this.inputController,
      required this.hintText,
      this.onChanged,
      this.focusNode,
      this.validator,
      this.fillColor,
      this.keyBoardType,
      this.textInputAction,
      this.isNumber,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: (isNumber ?? false)
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        inputFormatters: ((isNumber ?? false) && inputFormatters == null)
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : (inputFormatters != null)
                ? inputFormatters
                : null,
        textInputAction: textInputAction,
        controller: inputController,
        onChanged: onChanged,
        focusNode: focusNode,
        validator: validator,
        decoration: InputDecoration(
            fillColor: fillColor,
            filled: true,
            errorStyle: GoogleFonts.openSans(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 12.sp,
                color: const Color(0xffF15252)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.sp),
              borderSide: const BorderSide(color: Color(0xffF15252)),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide:
                    const BorderSide(color: Color(0xffD2D2D4), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide: const BorderSide(color: Colors.black87, width: 1)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide:
                    const BorderSide(color: Color(0xffD2D2D4), width: 1)),
            contentPadding: EdgeInsets.fromLTRB(20.sp, 15.sp, 0.sp, 0.sp),
            labelStyle: GoogleFonts.openSans(
                color: const Color(0xff78787D),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16.sp),
            hintStyle: GoogleFonts.openSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
            hintText: hintText));
  }
}
