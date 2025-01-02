import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:record/record.dart';

class MyAudioRecorder {
  // static const theSource = AudioSource.microphone;
  bool recording = false;
  bool recorded = false;
  Duration recordingDuration = Duration.zero;
  Duration maxRecordingDuration = Duration.zero;

  void Function(VoidCallback fn) setState;
  Ticker ticker;

  MyAudioRecorder(this.setState, this.ticker, this.maxRecordingDuration);

  final _record = Record();
  String path = '';
  late Future stopper;

  startRecord(
      {AudioEncoder encoder = AudioEncoder.aacLc,
      int numChannels = 2,
      int samplingRate = 44100,
      String fileExt = "m4a"}) async {
    if (await _record.hasPermission()) {
      var dir = await path_provider.getApplicationDocumentsDirectory();
      int random = DateTime.now().millisecondsSinceEpoch;
      path = '${dir.path}/${random}_rec.$fileExt';
      // Start recording

      await _record.start(
          path: path,
          encoder: encoder, // by default
          bitRate: 16000, // by default
          samplingRate: samplingRate, // by default
          numChannels: numChannels);
      ticker.start();
      setState(() {
        recording = true;
        recorded = false;
      });
      stopper = Future.delayed(maxRecordingDuration, () {
        if (recording) {
          stopRecording();
        }
      });
    }
  }

  Future<bool> isRecording() async {
    return await _record.isRecording();
  }

  Future<String?> stopRecording() async {
    try {
      stopper.ignore();
    } catch (e) {}
    ticker.stop();
    var p = await _record.stop();
    setState(() {
      recording = false;
      recorded = true;
    });
    return p;
  }
}
