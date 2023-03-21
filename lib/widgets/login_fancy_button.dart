import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:ds_game/widgets/fancy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginFancyButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const LoginFancyButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      child: SizedBox(
        width: 300,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      size: 45,
      color: color,
      onPressed: () {
        final player = AudioCache();
        player.play('images/button_sound.mp3');
        onPressed();
      },
    );
  }
}

class HostingButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const HostingButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      child: SizedBox(
        width: 220,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      size: 45,
      color: color,
      onPressed: () {
        final player = AudioCache();
        player.play('images/button_sound.mp3');
        onPressed();
      },
    );
  }
}

class GameStartButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const GameStartButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      child: SizedBox(
        width: 150.sp,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      size: 45,
      color: color,
      onPressed: () {
        final player = AudioCache();
        player.play('images/button_sound.mp3');
        onPressed();
      },
    );
  }
}

class HeadTailsButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const HeadTailsButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      child: SizedBox(
        width: 80.sp,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      size: 45,
      color: color,
      onPressed: () {
        onPressed();
      },
    );
  }
}

class ShareIdButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const ShareIdButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      child: SizedBox(
        width: 150.sp,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      size: 45,
      color: color,
      onPressed: () {
        final player = AudioCache();
        player.play('images/button_sound.mp3');
        onPressed();
      },
    );
  }
}

class ExitButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;

  const ExitButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyButton(
      child: SizedBox(
        width: 50.sp,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      size: 45,
      color: color,
      onPressed: () {
        onPressed();
      },
    );
  }
}
