import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:audio_wave/audio_wave.dart';

var path = "";
bool isCountVisible = false;
bool isRecordVisible = true;
bool isListenVisible = false;
Timer? _timer;
int _count = 3;
String countText = "3";
File? file;
String? date;

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  FlutterSoundRecorder? myRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();

  bool isPlaying = false;
  IconData listIcon = Icons.play_arrow;
  MaterialColor listColor = Colors.blue;
  String listText = 'Play';
  ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25.0),
      ),
      primary: Colors.blue);
  bool isRecording = false;
  IconData myIcon = Icons.mic;
  MaterialColor myColor = Colors.green;
  String myText = 'Record';
  ButtonStyle listStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25.0),
      ),
      primary: Colors.green);

  startRecording() async {
    await myRecorder!.openAudioSession();
    setState(() {
      isRecording = false;
      isCountVisible = true;
      isRecordVisible = false;
      isListenVisible = false;
    });
    countToThree();
  }

  void countToThree() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_count == 1 ) {
          setState(() {
            timer.cancel();
            countText = "recording...";
            isRecording = true;
          });
          recording();
        } else {
          setState(() {
            _count--;
            countText = _count.toString();
          });
        }
      },
    );
  }

  recording() async {
    String jrecord = 'Audiorecords';
    io.Directory? appDir = await getExternalStorageDirectory();
    DateTime now = DateTime.now();
    date = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
    String date2 = "${now.millisecondsSinceEpoch.toString()}.wav";
    io.Directory appDirec = io.Directory("${appDir!.path}/$jrecord/");
    path = appDir.path + "AudioRecords.wav";

    if (await appDirec.exists()) {
      path = "${appDirec.path}$date2";
      await myRecorder!.startRecorder(toFile: path);
    } else {
      appDirec.create(recursive: true);
      path = "${appDirec.path}$date2";
      await myRecorder!.startRecorder(toFile: path);
    }
    await Future.delayed(Duration(seconds: 10));
    await myRecorder!.stopRecorder();
    myRecorder!.closeAudioSession();
    setState(() {
      isRecording = false;
      isCountVisible = false;
      isRecordVisible = true;
      isListenVisible = true;
    });
    _count = 3;
    countText = "3";
    uploadFile();
  }

  Future uploadFile2() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));

    //file = File(path);
    if (file == null) return;
    final fileName = basename(path);
    final destination = 'files/$fileName';
    var task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
  }

  Future<void> uploadFile() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    File file = File(path);
    String fileName = date.toString();
    await firebase_storage.FirebaseStorage.instance
        .ref(fileName + '.wma')
        .putFile(file);
  }

  startPlaying() async {
    setState(() {
      listText = 'Stop';
      listIcon = Icons.stop;
      isPlaying = true;
      listStyle = ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
          primary: Colors.orange);
    });
    myPlayer.openAudioSession();
    myPlayer.startPlayer(fromURI: path);
  }

  endPlaying() async {
    setState(() {
      listText = 'Play';
      listIcon = Icons.play_arrow;
      isPlaying = false;
      listStyle = ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(25.0),
          ),
          primary: Colors.green);
    });
    myPlayer.stopPlayer();
  }

  @override
  void dispose() {
    myPlayer.closeAudioSession();
    // myPlayer = null;
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
            child: AudioWave(
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
            visible: isRecording),
        Visibility(child: Text(countText), visible: isCountVisible),
        Visibility(
          child: ElevatedButton.icon(
            onPressed: startRecording,
            icon: Icon(myIcon),
            label: Text(myText),
            style: style,
          ),
          visible: isRecordVisible,
        ),
        Visibility(
          child: ElevatedButton.icon(
            onPressed: isPlaying ? endPlaying : startPlaying,
            icon: Icon(listIcon),
            label: Text(listText),
            style: listStyle,
          ),
          visible: isListenVisible,
        ),
      ],
    );
  }
}
