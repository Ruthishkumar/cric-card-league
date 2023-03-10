import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ButtonSound extends StatefulWidget {
  const ButtonSound({Key? key}) : super(key: key);

  @override
  State<ButtonSound> createState() => _ButtonSoundState();
}

class _ButtonSoundState extends State<ButtonSound> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final player = AudioCache();
        player.play('images/button_sound.mp3');
        log(player.toString());
      },
    );
  }
}
