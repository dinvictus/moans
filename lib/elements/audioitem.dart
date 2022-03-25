import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/shimmer.dart';
import '../res.dart';
import 'audiomanager.dart';
import 'tag.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioItem extends StatefulWidget {
  AudioItem(this._indexPage, {Key? key}) : super(key: key);
  bool _liked = false;
  late final String _titleTrack;
  late final String _descriptionTrack;
  late final List<String> _listTags;
  late int _countLikes;
  late final AudioManager audioManager;
  late final int _trackId;
  final ValueNotifier<bool> _isloading = ValueNotifier<bool>(true);
  addInfo(String title, String description, List<String> tags, int likes,
      int idTrack, bool liked) {
    _titleTrack = title;
    _descriptionTrack = description;
    _listTags = tags;
    _countLikes = likes;
    _trackId = idTrack;
    audioManager = AudioManager(
        Utilities.url + "tracks/get_audio?track_id=" + idTrack.toString(),
        _titleTrack,
        _indexPage + 1);
    _isloading.value = false;
    _liked = liked;
  }

  final int _indexPage;

  @override
  State<AudioItem> createState() {
    return _AudioItemState();
  }
}

class _AudioItemState extends State<AudioItem>
    with AutomaticKeepAliveClientMixin {
  late ValueNotifier<double> notifierforLikeSize;
  TextStyle textStyleLS(double textSFactor) =>
      GoogleFonts.inter(color: Colors.white, fontSize: textSFactor * 12);
  TextStyle textStyleTime(double textSFactor) => GoogleFonts.inter(
      color: const Color(0xff878789), fontSize: textSFactor * 12);

  Widget loadingWidget(double devicePixelR) => Container(
      width: devicePixelR * 21,
      height: devicePixelR * 21,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
      child: const CircularProgressIndicator(
        color: Colors.black,
      ));

  animateLikeButton() {
    notifierforLikeSize.value = 42;
    Timer(const Duration(milliseconds: 100), () {
      notifierforLikeSize.value = 32;
    });
  }

  liked() async {
    if (!widget._isloading.value) {
      // Запрос к серверу на поставку лайка.
      widget._liked = true;
      animateLikeButton();
      Map<String, String> forLike = {
        "track_id": widget._trackId.toString(),
        "liked": "true"
      };
      Server.likeRequest(forLike);
      widget._countLikes++;
      setState(() {});
    }
  }

  unLiked() async {
    if (!widget._isloading.value) {
      // Запрос к серверу на удаление лайка.
      widget._liked = false;
      animateLikeButton();
      Map<String, String> forLike = {
        "track_id": widget._trackId.toString(),
        "liked": "false"
      };
      Server.likeRequest(forLike);
      widget._countLikes--;
      setState(() {});
    }
  }

  share() async {}

  @override
  void initState() {
    super.initState();
    notifierforLikeSize = ValueNotifier<double>(32);
  }

  Widget getRootElement(Widget? child, bool isloading) {
    return isloading
        ? Shimmer(linearGradient: shimmerGradient, child: child)
        : Container(child: child);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder<bool>(
            valueListenable: widget._isloading,
            builder: (_, isloading, __) {
              return getRootElement(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: widget._isloading,
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
                                          width: width / 1.3,
                                          height: devicePixelRatio * 10,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.withAlpha(50),
                                          ),
                                        ),
                                        SizedBox(height: height / 15),
                                        Container(
                                          height: devicePixelRatio * 7,
                                          width: width / 1.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.withAlpha(50),
                                          ),
                                        ),
                                        SizedBox(height: height / 75),
                                        Container(
                                            height: devicePixelRatio * 7,
                                            width: width / 1.5,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    Colors.grey.withAlpha(50))),
                                        SizedBox(height: height / 19),
                                        Container(
                                            height: 35,
                                            width: width / 1.1,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.grey.withAlpha(50),
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                        SizedBox(height: height / 14),
                                      ]))
                                  : Column(
                                      children: [
                                        SizedBox(
                                            width: width / 1.1,
                                            child: Text(widget._titleTrack,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize:
                                                        textScaleFactor * 30,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(height: height / 25),
                                        SizedBox(
                                            width: width / 1.1,
                                            child: Text(
                                                widget._descriptionTrack,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                    color:
                                                        const Color(0xffcfcfd0),
                                                    fontSize:
                                                        textScaleFactor * 20))),
                                        TagItem(widget._listTags,
                                            widget._indexPage),
                                      ],
                                    ),
                            ],
                          );
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                        height: height / 60,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: widget._isloading,
                            builder: (_, isloading, __) {
                              return isloading
                                  ? ProgressBar(
                                      thumbColor: Colors.white,
                                      thumbGlowRadius: devicePixelRatio * 5,
                                      thumbRadius: devicePixelRatio * 2,
                                      timeLabelPadding: devicePixelRatio * 4,
                                      timeLabelTextStyle:
                                          textStyleTime(textScaleFactor),
                                      bufferedBarColor: const Color(0xff898994),
                                      progressBarColor: Colors.white,
                                      baseBarColor: const Color(0xff4b4b4f),
                                      onSeek: null,
                                      progress: Duration.zero,
                                      total: Duration.zero,
                                    )
                                  : ValueListenableBuilder<ProgressBarState>(
                                      valueListenable:
                                          widget.audioManager.progressNotifier,
                                      builder: (_, value, __) {
                                        return ProgressBar(
                                          thumbColor: Colors.white,
                                          thumbGlowRadius: devicePixelRatio * 5,
                                          thumbRadius: devicePixelRatio * 2,
                                          timeLabelPadding:
                                              devicePixelRatio * 4,
                                          timeLabelTextStyle:
                                              textStyleTime(textScaleFactor),
                                          bufferedBarColor:
                                              const Color(0xff898994),
                                          progressBarColor: Colors.white,
                                          baseBarColor: const Color(0xff4b4b4f),
                                          progress: value.current,
                                          buffered: value.buffered,
                                          total: value.total,
                                          onSeek: widget.audioManager.seek,
                                        );
                                      },
                                    );
                            }),
                      ),
                      Stack(alignment: Alignment.center, children: [
                        Container(
                            height: devicePixelRatio * 21,
                            width: devicePixelRatio * 21,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, height / 5),
                            child: ValueListenableBuilder<bool>(
                                valueListenable: widget._isloading,
                                builder: (_, isloading, __) {
                                  return isloading
                                      ? loadingWidget(devicePixelRatio)
                                      : ValueListenableBuilder<ButtonState>(
                                          valueListenable: widget
                                              .audioManager.buttonNotifier,
                                          builder: (_, value, __) {
                                            switch (value) {
                                              case ButtonState.loading:
                                                return loadingWidget(
                                                    devicePixelRatio);
                                              case ButtonState.paused:
                                                return ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              devicePixelRatio *
                                                                  6,
                                                              devicePixelRatio *
                                                                  5,
                                                              devicePixelRatio *
                                                                  5,
                                                              devicePixelRatio *
                                                                  5),
                                                      primary: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0))),
                                                  child: Image.asset(
                                                      "assets/items/play.png"),
                                                  onPressed: () {
                                                    try {
                                                      Utilities.audioHandler
                                                          .switchToHandler(
                                                              widget._indexPage +
                                                                  1);
                                                      Utilities.audioHandler
                                                          .play();
                                                    } catch (e) {
                                                      print("error");
                                                    }
                                                  },
                                                );
                                              case ButtonState.playing:
                                                return ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      padding: EdgeInsets.all(
                                                          devicePixelRatio * 5),
                                                      primary: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0))),
                                                  child: Image.asset(
                                                      "assets/items/pause.png"),
                                                  onPressed:
                                                      widget.audioManager.pause,
                                                );
                                            }
                                          },
                                        );
                                })),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(children: [
                                ValueListenableBuilder<double>(
                                  valueListenable: notifierforLikeSize,
                                  builder: (_, value, __) {
                                    return AnimatedContainer(
                                        width: value,
                                        height: devicePixelRatio * 11,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                primary: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0))),
                                            onPressed: () {
                                              !widget._liked
                                                  ? liked()
                                                  : unLiked();
                                            },
                                            child: widget._liked
                                                ? Image.asset(
                                                    'assets/items/likeon.png')
                                                : Image.asset(
                                                    'assets/items/likeoff.png')));
                                  },
                                ),
                                SizedBox(height: devicePixelRatio * 2),
                                ValueListenableBuilder<bool>(
                                    valueListenable: widget._isloading,
                                    builder: (_, isloading, __) {
                                      return isloading
                                          ? SizedBox(
                                              height: devicePixelRatio * 5,
                                              width: devicePixelRatio * 7.5,
                                              child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    ShimmerLoading(
                                                        isLoading: isloading,
                                                        child: Container(
                                                            height:
                                                                devicePixelRatio *
                                                                    5,
                                                            width:
                                                                devicePixelRatio *
                                                                    7.5,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withAlpha(
                                                                        50),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15))))
                                                  ]))
                                          : Text(widget._countLikes.toString(),
                                              style:
                                                  textStyleLS(textScaleFactor));
                                    }),
                                SizedBox(height: height / 25),
                                SizedBox(
                                    height: devicePixelRatio * 11,
                                    width: devicePixelRatio * 11,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(0),
                                            primary: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50.0))),
                                        onPressed: share,
                                        child: Image.asset(
                                            'assets/items/share.png'))),
                                SizedBox(height: devicePixelRatio),
                                SizedBox(
                                    width: 71,
                                    child: ValueListenableBuilder<Map>(
                                        valueListenable: Utilities.curLang,
                                        builder: (_, lang, __) {
                                          return Text(lang["Share"],
                                              textAlign: TextAlign.center,
                                              style:
                                                  textStyleLS(textScaleFactor));
                                        })),
                                SizedBox(height: devicePixelRatio * 4)
                              ]),
                              SizedBox(width: devicePixelRatio * 3.4)
                            ]),
                      ]),
                    ],
                  ),
                  isloading);
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
