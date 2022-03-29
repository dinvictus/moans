import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moans/utils/utilities.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show File;

enum AudioRecordState { main, record, playrecord, saverecord }

class TimeRecordState {
  Duration curtime;
  TimeRecordState(this.curtime);
}

final pageAudioRecordNotifier =
    ValueNotifier<AudioRecordState>(AudioRecordState.main);

class AudioRecorder {
  late final Record _audioRecorder;

  AudioRecorder() {
    init();
  }
  final timeNotifier =
      ValueNotifier<TimeRecordState>(TimeRecordState(Duration.zero));
  bool _isInitialize = false;
  String? url = "";
  late Timer _timer;
  bool isRecording = false;
  bool _isFile = false;
  String? pathToFile = "";
  File? recordFile;

  init() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      _audioRecorder = Record();
      _isInitialize = true;
    }
  }

  loadFile(String ur) {
    _isFile = true;
    url = ur;
    pathToFile = ur;
    Utilities.managerForRecord.setUR(ur);
    timeNotifier.value.curtime = Duration.zero;
    Timer(const Duration(milliseconds: 500), () {
      timeNotifier.value = TimeRecordState(
          Utilities.managerForRecord.progressNotifier.value.total);
    });
    pageAudioRecordNotifier.value = AudioRecordState.playrecord;
  }

  dispose() {
    _isInitialize = false;
  }

  save() {
    pageAudioRecordNotifier.value = AudioRecordState.saverecord;
    Utilities.managerForRecord.stop();
  }

  back() async {
    try {
      if (_isInitialize) {
        FocusManager.instance.primaryFocus?.unfocus();
        Utilities.managerForRecord.stop();
        Utilities.managerForRecord.resetDuration();
        if (await _audioRecorder.isRecording()) {
          _audioRecorder.stop();
        }
        clearTimer();
        pageAudioRecordNotifier.value = AudioRecordState.main;
      }
    } catch (e) {
      Utilities.showToast(Utilities.curLang.value["Error"]);
    }
  }

  clearTimer() {
    if (timeNotifier.value.curtime != Duration.zero && !_isFile) {
      _timer.cancel();
    }
    _isFile = false;
    timeNotifier.value = TimeRecordState(Duration.zero);
  }

  backSave() {
    FocusManager.instance.primaryFocus?.unfocus();
    pageAudioRecordNotifier.value = AudioRecordState.playrecord;
  }

  _record() async {
    if (!_isInitialize) {
      init();
    } else {
      if (_isInitialize && !await _audioRecorder.isRecording()) {
        clearTimer();
        Utilities.isPlaying.value = Utilities.isPlaying.value ? false : true;
        pageAudioRecordNotifier.value = AudioRecordState.record;
        _audioRecorder.start();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          timeNotifier.value = TimeRecordState(Duration(seconds: timer.tick));
        });
      }
    }
  }

  Future<String?> _stop() async {
    if (_isInitialize) {
      pageAudioRecordNotifier.value = AudioRecordState.playrecord;
      _timer.cancel();
      return _audioRecorder.stop();
    }
    return null;
  }

  Future<void> toggleRecording() async {
    try {
      if (!isRecording) {
        _record();
        isRecording = true;
      } else {
        if (await _audioRecorder.isRecording()) {
          isRecording = false;
          pathToFile = await _stop();
          Utilities.managerForRecord.setUR(pathToFile);
        }
      }
    } catch (e) {
      back();
    }
  }
}
