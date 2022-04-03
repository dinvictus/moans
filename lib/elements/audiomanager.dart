import 'dart:async';
import 'dart:io' show File;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:moans/utils/utilities.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io' show Platform;

extension DemoAudioHandler on AudioHandler {
  Future<void> switchToHandler(int? index) async {
    if (index == null) return;
    await Utilities.audioHandler
        .customAction('switchToHandler', <String, dynamic>{'index': index});
  }
}

class CustomEvent {
  final int handlerIndex;

  CustomEvent(this.handlerIndex);
}

class AudioSwitchHandler extends SwitchAudioHandler {
  final List<AudioHandler> handlers;

  @override
  BehaviorSubject<dynamic> customState =
      BehaviorSubject<dynamic>.seeded(CustomEvent(0));

  AudioSwitchHandler(this.handlers) : super(handlers.first) {
    // Configure the app's audio category and attributes for speech.
    AudioSession.instance.then((session) {
      session.configure(const AudioSessionConfiguration.speech());
    });
  }

  @override
  Future<dynamic> customAction(String name,
      [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'switchToHandler':
        final index = extras!['index'] as int;
        inner = handlers[index];
        customState.add(CustomEvent(index));
        return null;
      default:
        return super.customAction(name, extras);
    }
  }
}

class AudioManager extends BaseAudioHandler with SeekHandler {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
  String? url;
  final String title;
  late MediaItem _source;
  final int _indexPage;
  bool initNoti = false;
  bool initDuration = false;

  late AudioPlayer _audioPlayer;
  @override
  AudioManager(this.url, this.title, this._indexPage) {
    _init();
  }

  setUR(String? ur) async {
    url = ur;
    File fileRecord = File.fromUri(Uri.parse(ur!));
    try {
      if (Platform.isIOS) {
        await _audioPlayer.setAsset(fileRecord.path);
      } else {
        await _audioPlayer.setUrl(fileRecord.path);
      }
    } catch (e) {
      Utilities.showToast(Utilities.curLang.value["Error"]);
    }
  }

  getUR() {
    return url;
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop
        ],
        systemActions: const {
          MediaAction.seek,
        },
        // androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  resetDuration() {
    initDuration = false;
  }

  _init() async {
    _audioPlayer = AudioPlayer();
    buttonNotifier.value = ButtonState.loading;
    try {
      if (url != "") {
        await _audioPlayer.setUrl(url!);
      }
    } catch (e) {
      Utilities.showToast(Utilities.curLang.value["Error"]);
    }
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) async {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });

    Utilities.isPlaying.addListener(() {
      if (_audioPlayer.playing) {
        _audioPlayer.stop();
        initNoti = false;
      }
    });
  }

  @override
  Future<void> play() async {
    Utilities.isPlaying.value = Utilities.isPlaying.value ? false : true;
    if (!initNoti) {
      _notifyAudioHandlerAboutPlaybackEvents();
      initNoti = true;
    }
    if (!initDuration) {
      _source = MediaItem(
          id: _indexPage.toString(),
          title: title,
          duration: progressNotifier.value.total,
          artUri: Uri.parse(Utilities.url + "tracks/get_logo"));
      mediaItem.add(_source);
      initDuration = true;
    }
    _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    _audioPlayer.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> stop() async {
    _audioPlayer.stop();
    initNoti = false;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
