import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/shimmer.dart';
import '../res.dart';
import 'audiomanager.dart';
import 'tag.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helprefresher.dart';

class AudioItem extends StatefulWidget {
  AudioItem(this._indexPage, {Key? key}) : super(key: key);
  late final AudioManager audioManager = AudioManager(
      "https://0fa8-92-101-232-21.ngrok.io/tracks/get_audio?track_id=3",
      _trackName,
      _indexPage + 1);
  final int _indexPage;
  String _trackName = "123456789ghfjtufhgjfthgjfhdrjghtjghqertyuiof";
  String _trackDisk =
      "Привет. К чему-то пришёл В общем. Одним запросом выдавать и инфу, и трек - не вариант. А если необходимо загрузить несколько треков, то тем более.";
  late final _tags;
  @override
  State<AudioItem> createState() {
    return _AudioItemState();
  }
}

class _AudioItemState extends State<AudioItem>
    with AutomaticKeepAliveClientMixin {
  bool liked = false;
  bool live = true;
  String likes = "12k";
  final TextStyle _textStyleTime =
      GoogleFonts.inter(color: const Color(0xff878789));
  final TextStyle _textStyleLS =
      GoogleFonts.inter(color: Colors.white, fontSize: 12);
  late ValueNotifier<double> notifierforLikeSize;
  final ValueNotifier<bool> _isloading = ValueNotifier<bool>(true);

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

  _getInfo() async {
    try {
      var _response = await http.get(Uri.parse(
          "https://0fa8-92-101-232-21.ngrok.io/tracks/one?track_id=3"));
      Map info = jsonDecode(_response.body);
      setState(() {
        widget._trackName = info["name"];
        widget._trackDisk = info["description"];
      });
    } catch (e) {
      // Ошибка подключения
    }
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
    HelpRefresh.toUpdateFeed = refresh;
    notifierforLikeSize = ValueNotifier<double>(32);
    Timer(Duration(seconds: 1), () {
      widget._tags = [
        "Всееем привеееееееееееет",
        "tag1",
        "taываывg1",
        "tag1",
        "tag1",
        "tag1",
        "tag1",
        "tag1",
        "taываывg1",
        "tag1",
        "tag1",
        "tag1",
        "tag1",
        "tag1",
        "taываывg1",
        "tag1",
        "tag1",
        "tag1",
      ];
      _isloading.value = false;
    });
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
        child: Shimmer(
            linearGradient: shimmerGradient,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isloading,
                  builder: (_, isloading, __) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      padding: EdgeInsets.zero,
                      children: [
                        isloading
                            ? ShimmerLoading(
                                isLoading: isloading,
                                child: Column(children: [
                                  Container(
                                    width: 250,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.withAlpha(50),
                                    ),
                                  ),
                                  SizedBox(height: height / 15),
                                  Container(
                                    height: 20,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.withAlpha(50),
                                    ),
                                  ),
                                  SizedBox(height: height / 60),
                                  Container(
                                      height: 20,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey.withAlpha(50))),
                                  SizedBox(height: height / 20),
                                  Container(
                                      height: 35,
                                      width: width - 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withAlpha(50),
                                          borderRadius:
                                              BorderRadius.circular(25))),
                                  SizedBox(height: height / 20),
                                ]))
                            : Column(
                                children: [
                                  SizedBox(
                                      width: width - 50,
                                      child: Text(widget._trackName,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: height / 27,
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(height: height / 25),
                                  SizedBox(
                                      width: width - 40,
                                      child: Text(widget._trackDisk,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffcfcfd0),
                                              fontSize: height / 40))),
                                  TagItem(widget._tags, widget._indexPage),
                                ],
                              ),
                      ],
                    );
                  },
                ),
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
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: const CircularProgressIndicator(
                                    color: Colors.black,
                                  ));
                            case ButtonState.paused:
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 17, 17, 17),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0))),
                                child: Image.asset("assets/items/play.png"),
                                onPressed: () {
                                  try {
                                    Utilities.audioHandler
                                        .switchToHandler(widget._indexPage + 1);
                                    Utilities.audioHandler.play();
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
                                        borderRadius:
                                            BorderRadius.circular(50.0))),
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
                                      : Image.asset(
                                          'assets/items/likeoff.png')));
                        },
                      ),
                      const SizedBox(height: 5),
                      ValueListenableBuilder<bool>(
                          valueListenable: _isloading,
                          builder: (_, isloading, __) {
                            return isloading
                                ? SizedBox(
                                    height: 15,
                                    width: 23,
                                    child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: [
                                          ShimmerLoading(
                                              isLoading: isloading,
                                              child: Container(
                                                  height: 15,
                                                  width: 23,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withAlpha(50),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15))))
                                        ]))
                                : Text(likes, style: _textStyleLS);
                          }),
                      SizedBox(height: height / 25),
                      SizedBox(
                          height: 32,
                          width: 32,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  primary: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onPressed: () {},
                              child: Image.asset('assets/items/share.png'))),
                      const SizedBox(height: 3),
                      SizedBox(
                          width: 71,
                          child: ValueListenableBuilder<String>(
                            valueListenable: Utilities.forShare,
                            builder: (_, value, __) {
                              return Text(Utilities.curLang["Share"],
                                  textAlign: TextAlign.center,
                                  style: _textStyleLS);
                            },
                          )),
                      SizedBox(height: height / 70)
                    ]),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
