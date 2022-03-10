import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:moans/res.dart';
import 'elements/audioitem.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FeedState();
  }
}

int curpage = 0;

class FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  int prepage = 1;
  late PageController _controller;
  final List<AudioItem> pages = [];
  final List<AudioManager> handlers = [];
  bool toastViewed = Utilities.showHelpNotification;
  refresh() {
    setState(() {});
  }

  loadTracks() async {
    int count = pages.length + 10;
    for (int i = pages.length; i < count; i++) {
      pages.add(AudioItem(i));
    }
    String trackInfoStr = "";
    await Future.delayed(Duration(seconds: 5), () {
      // Запрос к сереру на получение оффсета
      trackInfoStr =
          '[ { "id": 1, "name": "Turn back", "likes": 0, "description": "Rock-Opera Orfey", "path": "tracks/user_1/2022-03-10 21:15:07.605295.mp3", "tags": "orfey song"  }, { "id": 2, "name": "Step to the Darkness", "likes": 0, "description": "Rock-Opera Orfey", "path": "tracks/user_1/2022-03-10 21:16:23.436729.mp3", "tags": "orfey song"  }, { "id": 3, "name": "Witchers Doll", "likes": 0, "description": "King and Chester", "path": "tracks/user_1/2022-03-10 21:17:26.009230.mp3", "tags": "KaCh song"  } ]';
    });
    var trackInfo = jsonDecode(trackInfoStr);
    if (trackInfo.length < 10) {
      for (int i = count - 1; i > count - 11 + trackInfo.length; i--) {
        pages.removeAt(i);
      }
    }
    int j = 0;
    for (int i = count - 10; i < count - 10 + trackInfo.length; i++) {
      List<String> tags = trackInfo[j]["tags"].toString().split(" ");
      pages[i].addInfo(trackInfo[j]["name"], trackInfo[j]["description"], tags,
          trackInfo[j]["likes"], trackInfo[j]["id"]);
      handlers.add(pages[i].audioManager);
      j++;
    }
  }

  initFirst() async {
    Utilities.managerForRecord = AudioManager("", "Record", 0);
    handlers.add(Utilities.managerForRecord);
    Utilities.audioHandler = await AudioService.init(
        builder: () => AudioSwitchHandler(handlers),
        config: const AudioServiceConfig(
            androidNotificationIcon: "drawable/noti",
            androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
            androidNotificationChannelName: 'Audio playback',
            androidNotificationOngoing: true));
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: curpage, keepPage: true);
    loadTracks();
    initFirst();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomSheet: !toastViewed
            ? BottomSheet(
                enableDrag: false,
                backgroundColor: Colors.transparent,
                onClosing: () {},
                builder: (BuildContext context) {
                  return Container(
                      height: height / 10,
                      margin: EdgeInsets.only(bottom: height / 20),
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            _controller.animateToPage(1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          child: Image.asset("assets/items/toast.png")));
                },
              )
            : null,
        primary: true,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff000014),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/back/backfeed.png'),
                  fit: BoxFit.fill)),
          child: PageView.builder(
            itemCount: pages.length,
            itemBuilder: (context, position) {
              return pages[position];
            },
            controller: _controller,
            scrollDirection: Axis.vertical,
            onPageChanged: (value) async {
              setState(() {
                toastViewed = true;
                Utilities.helpNotificationViewied();
              });
              Utilities.curPage.value = value;
              if (value == pages.length - 1) {
                loadTracks();
              }
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
