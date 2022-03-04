import 'dart:async';
import 'package:moans/res.dart';
import 'package:record/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _isRecording = false;
  bool _isFile = false;

  init() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Нет разрешения для использования микрофона
    } else {
      _audioRecorder = Record();
      _isInitialize = true;
    }
  }

  loadFile(String ur) {
    _isFile = true;
    url = ur;
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
    Utilities.descLength.value = 0;
    Utilities.tagsCountForSave.value = 0;
    Utilities.titleLength.value = 0;
    Utilities.managerForRecord.stop();
    Utilities.managerForRecord.resetDuration();
    if (await _audioRecorder.isRecording()) {
      _audioRecorder.stop();
    }
    if (timeNotifier.value.curtime != Duration.zero && !_isFile) {
      _timer.cancel();
    }
    _isFile = false;
    timeNotifier.value = TimeRecordState(Duration.zero);
    pageAudioRecordNotifier.value = AudioRecordState.main;
  }

  backSave() {
    pageAudioRecordNotifier.value = AudioRecordState.playrecord;
  }

  _record() async {
    if (_isInitialize && !await _audioRecorder.isRecording()) {
      Utilities.isPlaying.value = Utilities.isPlaying.value ? false : true;
      pageAudioRecordNotifier.value = AudioRecordState.record;
      _audioRecorder.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        timeNotifier.value = TimeRecordState(Duration(seconds: timer.tick));
      });
    }
  }

  Future<String?> _stop() async {
    if (_isInitialize) {
      pageAudioRecordNotifier.value = AudioRecordState.playrecord;
      _timer.cancel();
      return _audioRecorder.stop();
    }
  }

  Future<void> toggleRecording() async {
    if (!_isRecording) {
      _record();
      _isRecording = true;
    } else {
      if (await _audioRecorder.isRecording()) {
        _isRecording = false;
        Utilities.managerForRecord.setUR(await _stop());
      }
    }
  }
}
