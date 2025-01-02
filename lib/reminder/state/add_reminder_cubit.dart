import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shevarms_user/reminder/reminder.dart';
import 'package:shevarms_user/shared/shared.dart';

class AddReminderCubit extends Cubit<AddReminderState> {
  AddReminderCubit(super.initialState);

  MyAudioRecorder? audioRecorder;

  MyAudioPlayer? audioPlayer;

  void updateRecordDuration(Duration value) {
    emit(state.copyWith(recordedDuration: value));
  }

  void updatePlaybackDuration(Duration value) {
    if (!(state.playingVoice ?? false)) {
      audioPlayer?.stop();
      audioPlayer?.closeListeners();
      emit(
          state.copyWith(playbackDuration: Duration.zero, playingVoice: false));
      return;
    }
    emit(state.copyWith(
        playbackDuration: value,
        playingVoice:
            value.inSeconds < (state.recordedDuration?.inSeconds ?? 0)));
  }

  void updateName(String value) {
    emit(state.copyWith(reminderName: value));
  }

  void updateType(String value) {
    emit(state.copyWith(calendarType: value));
  }

  void updateTime(DateTime value) {
    emit(state.copyWith(time: value));
  }

  void updateDescription(String value) {
    print("Updating description $value");
    emit(state.copyWith(description: value));
  }

  void addChannel(String value) {
    if (state.channels == null || !state.channels!.contains(value)) {
      final otherChannels = (state.channels ?? <String>[]);
      switch (value) {
        case "SMS":
          otherChannels.remove("SMS Flash");
          break;
        case "SMS Flash":
          otherChannels.remove("SMS");
          break;
        case "Ring":
          otherChannels.remove("Text to Speech");
          otherChannels.remove("Voice");
          break;
        case "Text to Speech":
          otherChannels.remove("Ring");
          otherChannels.remove("Voice");
          break;
        case "Voice":
          otherChannels.remove("Ring");
          otherChannels.remove("Text to Speech");
          break;
      }
      emit(state.copyWith(channels: [value, ...otherChannels]));
    }
  }

  void togglePlayback() {
    if (state.recordedVoice != null) {
      if (state.playingVoice ?? false) {
        audioPlayer?.closeListeners();
        audioPlayer?.stop();
        emit(state.copyWith(playingVoice: false));
      } else {
        audioPlayer = MyAudioPlayer((fn) {}, updatePlaybackDuration);
        audioPlayer?.play(
          state.recordedVoice!.path,
        );
        audioPlayer?.onPositionChanged(updatePlaybackDuration);
        emit(state.copyWith(
            playingVoice: true, playbackDuration: Duration.zero));
      }
    }
  }

  Future<bool> exportFile(BuildContext context, File internalFile,
      {Function(Object)? handleError}) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          final dir = await getDownloadsDirectory();
          if (dir == null) {
            throw "Sorry, we're unable to export your file at the moment";
          }
          directory = Directory(
              "${dir.path.replaceAll("/Android/data/", "/Android/media/")}/");
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.videos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(
            "${directory.path}${internalFile.path.substring(internalFile.path.lastIndexOf("/") + 1)}");
        return await copyFile(context, internalFile, saveFile);
      }
    } catch (e) {
      handleError?.call(e);
    }
    return false;
  }

  Future<bool> copyFile(
      BuildContext context, File internalFile, File externalFile) async {
    // Open the internal file for reading
    final Stream<List<int>> internalSink = internalFile.openRead();

    // Open the external file for writing
    final IOSink externalSink = externalFile.openWrite();

    // Pipe the contents of the internal file to the external file
    await internalSink.pipe(externalSink);

    // Close the file streams
    // await internalSink.drain();
    await externalSink.close();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('File contents copied successfully. ${externalFile.path}')));
    return true;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  void toggleRecording(BuildContext context) async {
    try {
      if (state.recordingVoice ?? false) {
        final recordedFilePath = await audioRecorder?.stopRecording();
        if (recordedFilePath != null) {
          final file = File(recordedFilePath);
          exportFile(context, file);
          final base64 = await MediaUtils.wavToBase64(file.path);
          exportFile(
              context,
              await File(recordedFilePath
                      .replaceAll(".m4a", ".64")
                      .replaceAll(".aac", ".64"))
                  .writeAsString(base64));
          emit(state.copyWith(recordedVoice: file));
        }
        emit(state.copyWith(recordingVoice: false));
      } else {
        audioRecorder = MyAudioRecorder(
            (fn) {}, Ticker(updateRecordDuration), const Duration(seconds: 60));
        audioRecorder?.startRecord(numChannels: 1, samplingRate: 44100);
        emit(state.copyWith(
          recordingVoice: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(recordingVoice: false));
      print(e);
    }
  }

  void updatedRecordedVoice(File? file) async {
    if (file == null && state.recordedVoice != null) {
      try {
        await state.recordedVoice?.delete();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    emit(state.copyWith(recordedVoice: file, clearRecordedVoice: file == null));
  }

  void removeChannel(String value) {
    if (state.channels != null || state.channels!.contains(value)) {
      final newList = state.channels ?? <String>[];
      newList.remove(value);
      emit(state.copyWith(channels: newList));
    }
  }

  Future<ReminderModel> addReminder(User user) async {
    try {
      emit(state.copyWith(loading: true, error: ''));
      final response = await ReminderService().createReminder(
        user,
        ReminderModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: state.reminderName!,
            description: state.description ?? "",
            calendarModelType: state.calendarType ?? "",
            date: state.time!,
            createdAt: DateTime.now(),
            sms: state.channels?.contains("SMS") ?? false,
            fsms: state.channels?.contains("SMS Flash") ?? false,
            ring: state.channels?.contains("Ring") ?? false,
            tts: state.channels?.contains("Text to Speech") ?? false,
            email: state.channels?.contains("Email") ?? false,
            voice: state.channels?.contains("Voice") ?? false,
            conferencing: state.channels?.contains("Conferencing") ?? false,
            voiceData: state.recordedVoice != null &&
                    (state.channels?.contains("Voice") ?? false)
                ? await MediaUtils.audioFileToBase64(state.recordedVoice!)
                : null),
      );
      emit(state.copyWith(loading: false, error: ''));
      return response;
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
      rethrow;
    }
  }
}

class AddReminderState {
  String? error;
  bool? loading;
  String? reminderName;
  String? calendarType;
  File? recordedVoice;
  DateTime? time;
  String? description;
  List<String>? channels;
  bool? recordingVoice;
  bool? playingVoice;
  Duration? recordedDuration;
  Duration? playbackDuration;

  AddReminderState({
    this.error,
    this.loading,
    this.reminderName,
    this.calendarType,
    this.time,
    this.description,
    this.channels,
    this.recordedVoice,
    this.recordingVoice,
    this.playingVoice,
    this.recordedDuration,
    this.playbackDuration,
  });

  AddReminderState copyWith({
    String? error,
    bool? loading,
    String? reminderName,
    String? calendarType,
    DateTime? time,
    String? description,
    List<String>? channels,
    File? recordedVoice,
    bool clearRecordedVoice = false,
    bool? recordingVoice,
    bool? playingVoice,
    Duration? recordedDuration,
    Duration? playbackDuration,
  }) {
    return AddReminderState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      reminderName: reminderName ?? this.reminderName,
      description: description ?? this.description,
      calendarType: calendarType ?? this.calendarType,
      time: time ?? this.time,
      channels: channels ?? this.channels,
      recordedVoice:
          clearRecordedVoice ? null : recordedVoice ?? this.recordedVoice,
      recordingVoice: recordingVoice ?? this.recordingVoice,
      playingVoice: playingVoice ?? this.playingVoice,
      recordedDuration:
          clearRecordedVoice ? null : recordedDuration ?? this.recordedDuration,
      playbackDuration:
          clearRecordedVoice ? null : playbackDuration ?? this.playbackDuration,
    );
  }
}
