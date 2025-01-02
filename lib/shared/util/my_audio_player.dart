import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _playListener;
  StreamSubscription? _stateMonitor;
  Duration? duration;

  Function(Duration) durationUpdate;

  bool playing = false;
  late Ticker _ticker;
  void Function(VoidCallback fn) setState;

  MyAudioPlayer(this.setState, this.durationUpdate);

  void play(String path) async {
    // setupStateMonitor();
    _ticker = Ticker((d) {
      durationUpdate(d);
      if (d.inSeconds >= duration!.inSeconds) {
        pause();
      }
    });
    if (_audioPlayer.playing) {
      _audioPlayer.stop();
    }
    duration = await _audioPlayer.setFilePath(path);
    _audioPlayer.play();
    _ticker.start();
    setState(() {
      playing = true;
    });
  }

  void pause() {
    if (_ticker != null) {
      _ticker.stop();
    }
    _audioPlayer.pause();
    setState(() {
      playing = false;
    });
  }

  void stop() {
    _audioPlayer.stop();
    setState(() {
      playing = false;
    });
  }

  void onPositionChanged(Function(Duration) onChanged) {
    if (_playListener != null) {
      _playListener!.cancel();
    }
  }

  void closeListeners() {
    if (_playListener != null) {
      _playListener!.cancel();
    }
    if (_stateMonitor != null) {
      _stateMonitor!.cancel();
    }
  }

  setupStateMonitor() {}

  void disposeTicker() {
    if (_ticker != null) {
      _ticker.dispose();
    }
  }
}
