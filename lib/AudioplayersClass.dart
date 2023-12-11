import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AudioPlayersClass extends StatelessWidget {
  const AudioPlayersClass({super.key});

  static var PARA = 50;

  @override
  Widget build(BuildContext context) {
    final Size size=MediaQuery.of(context).size;
    final oynatici = AudioPlayer();
    return ElevatedButton(
      child: Text("ÇAL"),
      onPressed: () async {

        //final oynatici = AudioPlayer();

        if(PARA==5)
        {
          oynatici.play(AssetSource('ses_kaydi/5TL.mp3'));
          Vibration.vibrate(pattern: [500, 1000]);
        }
        else if(PARA==10)
        {
          oynatici.play(AssetSource('ses_kaydi/10TL.mp3'));
          Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
        }
        else if(PARA==20)
        {
          oynatici.play(AssetSource('ses_kaydi/20TL.mp3'));
          Vibration.vibrate(pattern: [500, 1000, 500, 1000,500,1000]);
        }
        else if(PARA==50)
        {
          oynatici.play(AssetSource('ses_kaydi/50TL.mp3'));
          Vibration.vibrate(pattern: [500, 1000, 500, 1000,500,1000,500,1000]);
        }
        else if(PARA==100)
        {
          oynatici.play(AssetSource('ses_kaydi/100TL.mp3'));
          Vibration.vibrate(pattern: [500, 1000, 500, 1000,500,1000,500,1000,500,1000]);
        }
        else
        {
          oynatici.play(AssetSource('ses_kaydi/200TL.mp3'));
          Vibration.vibrate(pattern: [500, 1000, 500, 1000,500,1000,500,1000,500,1000,500,1000]);
        }

      },
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        //padding: const EdgeInsets.symmetric(horizontal: 192,vertical: 102,
        fixedSize: Size(size.width, 220),
      ),
    );
  }
}
