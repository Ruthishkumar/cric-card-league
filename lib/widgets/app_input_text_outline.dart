import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppInputTextOutline extends StatefulWidget {
  final TextEditingController inputController;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final String hintText;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final bool? isNumber;
  final TextStyle? hintTextStyle;
  final TextStyle? hintFontStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isPassword;
  bool? isEnabled;

  AppInputTextOutline(
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
      this.inputFormatters,
      this.hintTextStyle,
      this.hintFontStyle,
      this.isPassword,
      this.isEnabled = false})
      : super(key: key);

  @override
  State<AppInputTextOutline> createState() => _AppInputTextOutlineState();
}

class _AppInputTextOutlineState extends State<AppInputTextOutline> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
            keyboardType: (widget.isNumber ?? false)
                ? const TextInputType.numberWithOptions(decimal: true)
                : null,
            inputFormatters:
                ((widget.isNumber ?? false) && widget.inputFormatters == null)
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ]
                    : (widget.inputFormatters != null)
                        ? widget.inputFormatters
                        : null,
            textInputAction: widget.textInputAction,
            controller: widget.inputController,
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            validator: widget.validator,
            style: widget.hintFontStyle,
            obscureText: (widget.isPassword == true)
                ? !(widget.isEnabled ?? true)
                : false,
            decoration: InputDecoration(
                fillColor: widget.fillColor,
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
                    borderSide:
                        const BorderSide(color: Colors.black87, width: 1)),
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
                hintStyle: widget.hintTextStyle,
                hintText: widget.hintText)),
        widget.isPassword == true
            ? Positioned(
                right: 15,
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      log('Tapped');
                      setState(() {
                        widget.isEnabled = !(widget.isEnabled ?? true);
                      });
                      log('Is Enabled: ${widget.isEnabled}');
                    },
                    child: widget.isEnabled == true
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off)))
            : Container()
      ],
    );
  }
}
