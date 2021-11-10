import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';

class audioWave extends StatefulWidget {
  const audioWave({ Key? key }) : super(key: key);

  @override
  _audioWaveState createState() => _audioWaveState();
}

class _audioWaveState extends State<audioWave> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        AudioWave(
        height: 32,
        width: 88,
        spacing: 2.5,
        bars: [
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
          AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
          AudioWaveBar(height: 30, color: Colors.blue),
          AudioWaveBar(height: 70, color: Colors.black),
          AudioWaveBar(height: 40),
          AudioWaveBar(height: 20, color: Colors.orange),
        ],
      ),
    );
  }
}