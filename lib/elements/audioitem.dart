import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/shimmer.dart';
import 'package:moans/utils/server.dart';
import 'package:moans/utils/utilities.dart';
import 'audiomanager.dart';
import 'tag.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class AudioItem extends StatefulWidget {
  AudioItem(this._indexPage, {Key? key}) : super(key: key);
  final ValueNotifier<bool> _isliked = ValueNotifier<bool>(false);
  late final String _titleTrack;
  late final String _descriptionTrack;
  late final List<String> _listTags;
  late final AudioManager audioManager;
  late final int _trackId;
  late final ValueNotifier<int> countLikesNotifier;
  final ValueNotifier<bool> _isloading = ValueNotifier<bool>(true);
  addInfo(String title, String description, List<String> tags, int likes,
      int idTrack, bool liked) {
    _titleTrack = title;
    _descriptionTrack = description;
    _listTags = tags;
    _trackId = idTrack;
    audioManager = AudioManager(
        Utilities.url + "tracks/get_audio?track_id=" + idTrack.toString(),
        _titleTrack,
        _indexPage + 1);
    _isliked.value = liked;
    countLikesNotifier = ValueNotifier<int>(likes);
    _isloading.value = false;
  }

  int get getTrackId => _trackId;

  final int _indexPage;

  @override
  State<AudioItem> createState() {
    return _AudioItemState();
  }
}

class _AudioItemState extends State<AudioItem>
    with AutomaticKeepAliveClientMixin {
  late ValueNotifier<double> notifierforLikeSize;
  final TextStyle textStyleLS = GoogleFonts.inter(
      color: Colors.white, fontSize: Utilities.deviceSizeMultiply / 50);
  final TextStyle textStyleTime = GoogleFonts.inter(
      color: const Color(0xff878789),
      fontSize: Utilities.deviceSizeMultiply / 40);
  final Widget loadingWidget = Container(
      width: Utilities.deviceSizeMultiply / 9,
      height: Utilities.deviceSizeMultiply / 9,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50.0)),
      child: CircularProgressIndicator(
        strokeWidth: Utilities.deviceSizeMultiply / 150,
        color: Colors.black,
      ));

  animateLikeButton() {
    notifierforLikeSize.value = Utilities.deviceSizeMultiply / 13;
    Timer(const Duration(milliseconds: 100), () {
      notifierforLikeSize.value = Utilities.deviceSizeMultiply / 17;
    });
  }

  liked() async {
    if (!widget._isloading.value) {
      widget.countLikesNotifier.value++;
      widget._isliked.value = true;
      animateLikeButton();
      Map<String, String> forLike = {
        "track_id": widget._trackId.toString(),
        "liked": "true"
      };
      int statusCodeLike = await Server.likeRequest(forLike);
      if (statusCodeLike == 403) {
        await Server.logIn(Utilities.email, Utilities.password, null);
        Server.likeRequest(forLike);
      }
    }
  }

  unLiked() async {
    if (!widget._isloading.value) {
      widget.countLikesNotifier.value--;
      widget._isliked.value = false;
      animateLikeButton();
      Map<String, String> forLike = {
        "track_id": widget._trackId.toString(),
        "liked": "false"
      };
      int statusCodeLike = await Server.likeRequest(forLike);
      if (statusCodeLike == 403) {
        await Server.logIn(Utilities.email, Utilities.password, null);
        Server.likeRequest(forLike);
      }
    }
  }

  String getLikeString(int countLikes) {
    if (countLikes > 1000000) {
      return (countLikes ~/ 1000000).toString() + "M";
    }
    if (countLikes > 1000) {
      return (countLikes ~/ 1000).toString() + "k";
    }
    return countLikes.toString();
  }

  share() async {
    if (!widget._isloading.value) {
      Share.share(Utilities.curLang.value["ShareMsg"] +
          "\n" +
          widget._titleTrack +
          "\n"
              "http://moans.com/track_" +
          widget._trackId.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    notifierforLikeSize =
        ValueNotifier<double>(Utilities.deviceSizeMultiply / 17);
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
                                          height:
                                              Utilities.deviceSizeMultiply / 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.withAlpha(50),
                                          ),
                                        ),
                                        SizedBox(height: height / 15),
                                        Container(
                                          height:
                                              Utilities.deviceSizeMultiply / 32,
                                          width: width / 1.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.grey.withAlpha(50),
                                          ),
                                        ),
                                        SizedBox(height: height / 75),
                                        Container(
                                            height:
                                                Utilities.deviceSizeMultiply /
                                                    32,
                                            width: width / 1.5,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    Colors.grey.withAlpha(50))),
                                        SizedBox(height: height / 19),
                                        Container(
                                            height:
                                                Utilities.deviceSizeMultiply /
                                                    15,
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
                                                    fontSize: Utilities
                                                            .deviceSizeMultiply /
                                                        25,
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
                                                    fontSize: Utilities
                                                            .deviceSizeMultiply /
                                                        30))),
                                        TagItem(widget._listTags,
                                            widget._indexPage),
                                      ],
                                    ),
                            ],
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            width / 13, 0, width / 13, height / 25),
                        height: height / 60,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: widget._isloading,
                            builder: (_, isloading, __) {
                              return isloading
                                  ? ProgressBar(
                                      thumbColor: Colors.white,
                                      thumbGlowRadius:
                                          Utilities.deviceSizeMultiply / 40,
                                      thumbRadius:
                                          Utilities.deviceSizeMultiply / 85,
                                      timeLabelPadding:
                                          Utilities.deviceSizeMultiply / 40,
                                      timeLabelTextStyle: textStyleTime,
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
                                          thumbGlowRadius:
                                              Utilities.deviceSizeMultiply / 40,
                                          thumbRadius:
                                              Utilities.deviceSizeMultiply / 85,
                                          timeLabelPadding:
                                              Utilities.deviceSizeMultiply / 40,
                                          timeLabelTextStyle: textStyleTime,
                                          barHeight:
                                              Utilities.deviceSizeMultiply /
                                                  100,
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
                            height: Utilities.deviceSizeMultiply / 9,
                            width: Utilities.deviceSizeMultiply / 9,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, height / 4),
                            child: ValueListenableBuilder<bool>(
                                valueListenable: widget._isloading,
                                builder: (_, isloading, __) {
                                  return isloading
                                      ? loadingWidget
                                      : ValueListenableBuilder<ButtonState>(
                                          valueListenable: widget
                                              .audioManager.buttonNotifier,
                                          builder: (_, value, __) {
                                            switch (value) {
                                              case ButtonState.loading:
                                                return loadingWidget;
                                              case ButtonState.paused:
                                                return ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      padding: EdgeInsets.fromLTRB(
                                                          Utilities
                                                                  .deviceSizeMultiply /
                                                              30,
                                                          Utilities
                                                                  .deviceSizeMultiply /
                                                              35,
                                                          Utilities
                                                                  .deviceSizeMultiply /
                                                              35,
                                                          Utilities
                                                                  .deviceSizeMultiply /
                                                              35),
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
                                                      Utilities.showToast(
                                                          Utilities.curLang
                                                              .value["Error"]);
                                                    }
                                                  },
                                                );
                                              case ButtonState.playing:
                                                return ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      padding: EdgeInsets.all(
                                                          Utilities
                                                                  .deviceSizeMultiply /
                                                              30),
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
                                        height:
                                            Utilities.deviceSizeMultiply / 17,
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
                                              !widget._isliked.value
                                                  ? liked()
                                                  : unLiked();
                                            },
                                            child: widget._isliked.value
                                                ? Image.asset(
                                                    'assets/items/likeon.png')
                                                : Image.asset(
                                                    'assets/items/likeoff.png')));
                                  },
                                ),
                                SizedBox(height: height / 100),
                                ValueListenableBuilder<bool>(
                                    valueListenable: widget._isloading,
                                    builder: (_, isloading, __) {
                                      return isloading
                                          ? SizedBox(
                                              height:
                                                  Utilities.deviceSizeMultiply /
                                                      40,
                                              width:
                                                  Utilities.deviceSizeMultiply /
                                                      20,
                                              child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    ShimmerLoading(
                                                        isLoading: isloading,
                                                        child: Container(
                                                            height: Utilities
                                                                    .deviceSizeMultiply /
                                                                40,
                                                            width: Utilities
                                                                    .deviceSizeMultiply /
                                                                20,
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
                                          : ValueListenableBuilder<int>(
                                              valueListenable:
                                                  widget.countLikesNotifier,
                                              builder: (_, likesCount, __) {
                                                return Text(
                                                    getLikeString(likesCount),
                                                    style: textStyleLS);
                                              });
                                    }),
                                SizedBox(height: height / 25),
                                SizedBox(
                                    height: Utilities.deviceSizeMultiply / 17,
                                    width: Utilities.deviceSizeMultiply / 17,
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
                                const SizedBox(height: 2),
                                SizedBox(
                                    width: width / 4.5,
                                    child: ValueListenableBuilder<Map>(
                                        valueListenable: Utilities.curLang,
                                        builder: (_, lang, __) {
                                          return Text(lang["Share"],
                                              textAlign: TextAlign.center,
                                              style: textStyleLS);
                                        })),
                                SizedBox(height: height / 50)
                              ]),
                            ]),
                      ]),
                      SizedBox(height: height / 16.5)
                    ],
                  ),
                  isloading);
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
