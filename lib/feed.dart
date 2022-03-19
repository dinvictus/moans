import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:moans/res.dart';
import 'elements/audioitem.dart';
import 'package:http/http.dart' as http;

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

int curpage = 0;

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  int prepage = 1;
  int counterForViewedTracks = 0;
  late PageController _controller;
  final List<AudioItem> pages = [];
  final List<AudioManager> handlers = [];
  bool toastViewed = Utilities.showHelpNotification;

  loadViewedTracs(int count) async {
    int countAddedTracks = 0;
    int counterPageFinal = pages.length - count;
    int counterPage = counterPageFinal;
    counterForViewedTracks += count;
    while (countAddedTracks != count) {
      final uri = Uri.parse(Utilities.url +
          "tracks/track_seen" +
          "?language_id=" +
          Languages.values.indexOf(Utilities.currentLanguage).toString() +
          "&voice=5&limit=" +
          count.toString() +
          "&skip=" +
          counterForViewedTracks.toString());
      try {
        var responce = await http.get(uri, headers: {
          "Authorization": "Bearer " + Utilities.authToken,
          "Content-Type": "application/json"
        });
        var trackInfoViewed = jsonDecode(responce.body);
        if (responce.statusCode == 200) {
          int j = 0;
          for (int i = counterPage;
              i < counterPage + trackInfoViewed.length;
              i++) {
            List<String> tags =
                trackInfoViewed[j]["tags"].toString().split(" ");
            pages[i].addInfo(
                trackInfoViewed[j]["name"],
                trackInfoViewed[j]["description"],
                tags,
                trackInfoViewed[j]["likes"],
                trackInfoViewed[j]["id"]);
            handlers.add(pages[i].audioManager);
            j++;
            countAddedTracks++;
          }
          if (countAddedTracks < count) {
            counterForViewedTracks = 0;
            counterPage = counterPageFinal + countAddedTracks;
          }
        } else {
          print(responce.body);
          break;
        }
      } catch (e) {
        print(e);
      }
    }
  }

  loadTracks() async {
    int counter = pages.length;
    for (int i = counter; i < counter + 10; i++) {
      pages.add(AudioItem(i));
    }

    final uri = Uri.parse(Utilities.url +
        "tracks/track_feed" +
        "?language_id=" +
        Languages.values.indexOf(Utilities.currentLanguage).toString() +
        "&voice=5&limit=10&skip=0");
    try {
      var responce = await http.get(uri, headers: {
        "Authorization": "Bearer " + Utilities.authToken,
        "Content-Type": "application/json"
      });

      if (responce.statusCode == 200) {
        var trackInfoNotViewed = jsonDecode(responce.body);
        if (trackInfoNotViewed.length != 0) {
          int j = 0;
          for (int i = counter; i < counter + trackInfoNotViewed.length; i++) {
            List<String> tags =
                trackInfoNotViewed[j]["tags"].toString().split(" ");
            pages[i].addInfo(
                trackInfoNotViewed[j]["name"],
                trackInfoNotViewed[j]["description"],
                tags,
                trackInfoNotViewed[j]["likes"],
                trackInfoNotViewed[j]["id"]);
            handlers.add(pages[i].audioManager);
            j++;
          }
        }

        if (trackInfoNotViewed.length < 10) {
          await loadViewedTracs(10 - trackInfoNotViewed.length as int);
        }
      } else {
        print(responce.body);
      }
    } catch (e) {
      print(e);
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
                await loadTracks();
              }
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
