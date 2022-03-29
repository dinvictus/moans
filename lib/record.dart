import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/postitem.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'elements/audiomanager.dart';
import 'elements/audiorecorder.dart';
import 'package:file_picker/file_picker.dart';

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecordState();
  }
}

late double _height;
late double _width;
late final AudioRecorder _audioRecorder = AudioRecorder();

final TextStyle _textStyleTime = GoogleFonts.inter(
    color: const Color(0xff878789),
    fontSize: Utilities.deviceSizeMultiply / 40);

class MainRecordItem extends StatefulWidget {
  const MainRecordItem({Key? key}) : super(key: key);

  @override
  State<MainRecordItem> createState() {
    return _MainRecordItemState();
  }
}

class _MainRecordItemState extends State<MainRecordItem> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  lang["Record"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: Utilities.deviceSizeMultiply / 30),
                ),
              ),
              body: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(bottom: _height / 20),
                      child: Text(
                        lang["TapToRecord"],
                        style: GoogleFonts.inter(
                            color: const Color(0xffcfcfd0),
                            fontSize: Utilities.deviceSizeMultiply / 30),
                      ),
                    ),
                    SizedBox(
                        height: Utilities.deviceSizeMultiply / 4,
                        width: Utilities.deviceSizeMultiply / 4,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(35),
                                primary: MColors.mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(100.0))),
                            onPressed: () {
                              if (!_audioRecorder.isRecording) {
                                _audioRecorder.toggleRecording();
                              }
                            },
                            child: Image.asset('assets/items/recordbut.png'))),
                    Container(
                        margin: EdgeInsets.only(top: _height / 20),
                        height: Utilities.deviceSizeMultiply / 13,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                primary: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide.lerp(
                                        const BorderSide(
                                            width: 1, color: MColors.mainColor),
                                        const BorderSide(
                                            width: 1, color: MColors.mainColor),
                                        2),
                                    borderRadius: BorderRadius.circular(50.0))),
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['mp3']);
                              if (result != null) {
                                _audioRecorder
                                    .loadFile(result.files.single.path!);
                              }
                            },
                            child: Text(
                              lang["PickLib"],
                              style: GoogleFonts.inter(
                                  color: MColors.mainColor,
                                  fontSize: Utilities.deviceSizeMultiply / 35),
                            ))),
                    const Spacer()
                  ],
                ),
              ));
        });
  }
}

class RecordRecordItem extends StatefulWidget {
  const RecordRecordItem({Key? key}) : super(key: key);

  @override
  State<RecordRecordItem> createState() {
    return _RecordRecordItemState();
  }
}

class _RecordRecordItemState extends State<RecordRecordItem> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              backgroundColor: const Color(0xff0f0f14),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  lang["Record"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: Utilities.deviceSizeMultiply / 30),
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(top: _height / 4),
                margin: EdgeInsets.only(bottom: _height / 9),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/back/backrecord.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<TimeRecordState>(
                      valueListenable: _audioRecorder.timeNotifier,
                      builder: (_, value, __) {
                        return Text(
                          value.curtime.toString().substring(2, 7),
                          style: GoogleFonts.inter(
                              color: const Color(0xffcfcfd0),
                              fontSize: Utilities.deviceSizeMultiply / 8,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    const Spacer(),
                    SizedBox(height: _height / 7),
                    Text(
                      lang["StopRec"],
                      style: GoogleFonts.inter(
                          color: const Color(0xffcfcfd0),
                          fontWeight: FontWeight.w400,
                          fontSize: Utilities.deviceSizeMultiply / 30),
                    ),
                    SizedBox(height: _height / 30),
                    SizedBox(
                        width: Utilities.deviceSizeMultiply / 7,
                        height: Utilities.deviceSizeMultiply / 7,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: MColors.mainColor,
                                padding: EdgeInsets.all(
                                    Utilities.deviceSizeMultiply / 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(100.0))),
                            onPressed: () {
                              if (_audioRecorder.isRecording) {
                                _audioRecorder.toggleRecording();
                              }
                            },
                            child: Container(
                              color: Colors.white,
                            ))),
                    const Spacer()
                  ],
                ),
              ));
        });
  }
}

class PlayRecordItem extends StatefulWidget {
  const PlayRecordItem({Key? key}) : super(key: key);

  @override
  State<PlayRecordItem> createState() {
    return _PlayRecordItemState();
  }
}

class _PlayRecordItemState extends State<PlayRecordItem> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  lang["Record"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: Utilities.deviceSizeMultiply / 30),
                ),
              ),
              body: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, _height / 4, 0, 0),
                child: Column(
                  children: [
                    ValueListenableBuilder<TimeRecordState>(
                      valueListenable: _audioRecorder.timeNotifier,
                      builder: (_, value, __) {
                        return Text(
                          value.curtime.toString().substring(2, 7),
                          style: GoogleFonts.inter(
                              color: const Color(0xffcfcfd0),
                              fontSize: Utilities.deviceSizeMultiply / 9,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          _width / 13, _height / 35, _width / 13, _height / 27),
                      height: _height / 60,
                      child: ValueListenableBuilder<ProgressBarState>(
                        valueListenable:
                            Utilities.managerForRecord.progressNotifier,
                        builder: (_, value, __) {
                          return ProgressBar(
                            thumbColor: Colors.white,
                            thumbGlowRadius: Utilities.deviceSizeMultiply / 40,
                            thumbRadius: Utilities.deviceSizeMultiply / 85,
                            timeLabelPadding: Utilities.deviceSizeMultiply / 40,
                            timeLabelTextStyle: _textStyleTime,
                            barHeight: Utilities.deviceSizeMultiply / 100,
                            bufferedBarColor: const Color(0xff898994),
                            progressBarColor: Colors.white,
                            baseBarColor: const Color(0xff4b4b4f),
                            progress: value.current,
                            buffered: value.buffered,
                            total: value.total,
                            onSeek: Utilities.managerForRecord.seek,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, _height / 9),
                      height: Utilities.deviceSizeMultiply / 9,
                      width: Utilities.deviceSizeMultiply / 9,
                      child: ValueListenableBuilder<ButtonState>(
                        valueListenable:
                            Utilities.managerForRecord.buttonNotifier,
                        builder: (_, value, __) {
                          switch (value) {
                            case ButtonState.loading:
                              return Container(
                                  height: Utilities.deviceSizeMultiply / 9,
                                  width: Utilities.deviceSizeMultiply / 9,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: CircularProgressIndicator(
                                    strokeWidth:
                                        Utilities.deviceSizeMultiply / 150,
                                    color: Colors.black,
                                  ));
                            case ButtonState.paused:
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: EdgeInsets.fromLTRB(
                                        Utilities.deviceSizeMultiply / 30,
                                        Utilities.deviceSizeMultiply / 35,
                                        Utilities.deviceSizeMultiply / 35,
                                        Utilities.deviceSizeMultiply / 35),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0))),
                                child: Image.asset("assets/items/play.png"),
                                onPressed: () {
                                  Utilities.audioHandler.switchToHandler(0);
                                  Utilities.audioHandler.play();
                                },
                              );
                            case ButtonState.playing:
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: EdgeInsets.all(
                                        Utilities.deviceSizeMultiply / 30),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0))),
                                child: Image.asset("assets/items/pause.png"),
                                onPressed: Utilities.managerForRecord.pause,
                              );
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: _width / 3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        Utilities.deviceSizeMultiply / 40,
                                        0,
                                        Utilities.deviceSizeMultiply / 40),
                                    primary: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        side: const BorderSide(
                                            color: MColors.mainColor))),
                                onPressed: () {
                                  _audioRecorder.back();
                                },
                                child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      lang["Again"],
                                      style: GoogleFonts.inter(
                                          color: MColors.mainColor,
                                          fontSize:
                                              Utilities.deviceSizeMultiply /
                                                  38),
                                    )))),
                        SizedBox(
                            width: _width / 3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: MColors.mainColor,
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        Utilities.deviceSizeMultiply / 40,
                                        0,
                                        Utilities.deviceSizeMultiply / 40),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0))),
                                onPressed: () {
                                  _audioRecorder.save();
                                },
                                child: FittedBox(
                                    child: Text(lang["Save"],
                                        style: GoogleFonts.inter(
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    38))))),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}

class _RecordState extends State<Record> with AutomaticKeepAliveClientMixin {
  final PageController scrollController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _audioRecorder.back();
  }

  animate(index) {
    if (scrollController.hasClients) {
      scrollController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        switch (pageAudioRecordNotifier.value) {
          case AudioRecordState.main:
            return false;
          case AudioRecordState.playrecord:
            _audioRecorder.back();
            return false;
          case AudioRecordState.record:
            _audioRecorder.back();
            return false;
          case AudioRecordState.saverecord:
            _audioRecorder.backSave();
            return false;
        }
      },
      child: ValueListenableBuilder<AudioRecordState>(
          valueListenable: pageAudioRecordNotifier,
          builder: (_, value, __) {
            switch (value) {
              case AudioRecordState.main:
                animate(0);
                break;
              case AudioRecordState.record:
                animate(1);
                break;
              case AudioRecordState.playrecord:
                animate(2);
                break;
              case AudioRecordState.saverecord:
                animate(3);
                break;
            }
            return PageView(
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                const MainRecordItem(),
                const RecordRecordItem(),
                const PlayRecordItem(),
                PostItem(
                    _audioRecorder.backSave, -1, _audioRecorder.pathToFile!),
              ],
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
