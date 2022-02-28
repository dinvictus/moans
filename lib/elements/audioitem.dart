import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import '../res.dart';
import 'audiomanager.dart';
import 'tag.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helprefresher.dart';

class AudioItem extends StatefulWidget {
  AudioItem(this._trackName, this._trackDisk, this._indexPage, {Key? key})
      : super(key: key);
  late final AudioManager audioManager =
      AudioManager(Strings.url + "audio", _trackName, _indexPage + 1);
  final int _indexPage;
  final String _trackName;
  final String _trackDisk;
  final _tags = [
    "taggggggggппп32П", // Пока что максимум по 16 символов в каждом тэге
    "taggggggg2пппПы3",
    "taggg333g3пппFS-",
    "tag",
    "tag",
    "tagggggggппппппппппппппппппппп",
    "tagggggggg",
    "taggg",
    "tag"
  ];
  @override
  State<AudioItem> createState() {
    return AudioItemState();
  }
}

class AudioItemState extends State<AudioItem>
    with AutomaticKeepAliveClientMixin {
  bool liked = false;
  bool live = true;
  String likes = "12k";
  final TextStyle _textStyleTime =
      GoogleFonts.inter(color: const Color(0xff878789));
  final TextStyle _textStyleLS =
      GoogleFonts.inter(color: Colors.white, fontSize: 12);
  late ValueNotifier<double> notifierforLikeSize;

  refresh() {
    setState(() {});
  }

  _liked() {
    // Запрос к серверу на поставку лайка.
    liked = true;
    notifierforLikeSize.value = 42;
    Timer(const Duration(milliseconds: 100), () {
      notifierforLikeSize.value = 32;
    });
  }

  _unLiked() {
    // Запрос к серверу на удаление лайка.
    liked = false;
    notifierforLikeSize.value = 42;
    Timer(const Duration(milliseconds: 100), () {
      notifierforLikeSize.value = 32;
    });
  }

  @override
  void initState() {
    super.initState();
    HelpRefresh.toUpdateFeed = refresh;
    notifierforLikeSize = ValueNotifier<double>(32);
  }

  @override
  void dispose() {
    widget.audioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(widget._trackName,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: height / 27,
                    fontWeight: FontWeight.bold)),
            Container(height: height / 30),
            SizedBox(
                width: 200,
                child: Text(widget._trackDisk,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: const Color(0xffcfcfd0),
                        fontSize: height / 40))),
            TagItem(widget._tags, widget._indexPage),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              height: height / 60,
              child: ValueListenableBuilder<ProgressBarState>(
                valueListenable: widget.audioManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    thumbColor: Colors.white,
                    thumbGlowRadius: 20,
                    thumbRadius: 7,
                    timeLabelPadding: 10,
                    timeLabelTextStyle: _textStyleTime,
                    bufferedBarColor: const Color(0xff898994),
                    progressBarColor: Colors.white,
                    baseBarColor: const Color(0xff4b4b4f),
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: widget.audioManager.seek,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                      0, 0, width / 2 - 10 - 34 - 71, height / 5),
                  height: 68,
                  width: 68,
                  child: ValueListenableBuilder<ButtonState>(
                    valueListenable: widget.audioManager.buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case ButtonState.loading:
                          return Container(
                              width: 68,
                              height: 68,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ));
                        case ButtonState.paused:
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.all(17),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            child: Image.asset("assets/items/play.png"),
                            onPressed: () {
                              try {
                                Strings.audioHandler
                                    .switchToHandler(widget._indexPage + 1);
                                Strings.audioHandler.play();
                              } catch (e) {
                                print("error");
                              }
                            },
                          );
                        case ButtonState.playing:
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.all(17),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            child: Image.asset("assets/items/pause.png"),
                            onPressed: widget.audioManager.pause,
                          );
                      }
                    },
                  ),
                ),
                Column(children: [
                  ValueListenableBuilder<double>(
                    valueListenable: notifierforLikeSize,
                    builder: (_, value, __) {
                      return AnimatedContainer(
                          width: value,
                          height: 32,
                          duration: const Duration(milliseconds: 100),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  primary: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onPressed: () {
                                !liked ? _liked() : _unLiked();
                              },
                              child: liked
                                  ? Image.asset('assets/items/likeon.png')
                                  : Image.asset('assets/items/likeoff.png')));
                    },
                  ),
                  const SizedBox(height: 3),
                  Text(likes, style: _textStyleLS),
                  SizedBox(height: height / 25),
                  SizedBox(
                      height: 32,
                      width: 32,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              primary: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          onPressed: () {},
                          child: Image.asset('assets/items/share.png'))),
                  const SizedBox(height: 3),
                  SizedBox(
                      width: 71,
                      child: ValueListenableBuilder<String>(
                        valueListenable: Strings.forShare,
                        builder: (_, value, __) {
                          return Text(Strings.curLang["Share"],
                              textAlign: TextAlign.center, style: _textStyleLS);
                        },
                      )),
                  SizedBox(height: height / 70)
                ]),
                const SizedBox(width: 15),
              ],
            )
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
