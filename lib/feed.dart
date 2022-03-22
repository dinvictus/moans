import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:moans/elements/endfeeditem.dart';
import 'package:moans/res.dart';
import 'elements/audioitem.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() {
    return _FeedState();
  }
}

int curpage = 0;

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  int counterForViewedTracks = 0;
  late PageController controller;
  final List<dynamic> pages = [];
  final List<AudioManager> handlers = [];
  bool toastViewed = Utilities.showHelpNotification;
  bool tracksEnd = false;

  refreshFeed() {
    pages.clear();
    handlers.removeRange(1, handlers.length);
    setState(() {});
    loadTracks();
  }

  loadViewedTracs(int count) async {
    int countAddedTracks = 0;
    int counterPageFinal = pages.length - count;
    int counterPage = counterPageFinal;
    counterForViewedTracks += count;
    while (countAddedTracks != count) {
      Map<String, String> forTracksViewedInfo = {
        "language_id":
            Languages.values.indexOf(Utilities.currentLanguage).toString(),
        "voice": (Voices.values.indexOf(Utilities.curVoice)).toString(),
        "limit": count.toString(),
        "skip": counterForViewedTracks.toString()
      };
      Map responceInfo = await Server.getViewedTracks(forTracksViewedInfo);
      switch (responceInfo["status_code"]) {
        case 200:
          var trackInfoViewed = responceInfo["tracks_info"];
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
            tracksEnd = true;
            int voidPages = pages.length - 1 - (count - countAddedTracks);
            for (int i = pages.length - 1; i > voidPages; i--) {
              pages.removeAt(i);
            }
            pages.add(EndFeedItem(refreshFeed));
            setState(() {});
            return;
          }
          break;
        case 404:
          // Ошибка подключения
          return;
        default:
          // Ошибка
          return;
      }
    }
  }

  loadTracks() async {
    int counter = pages.length;
    for (int i = counter; i < counter + 10; i++) {
      pages.add(AudioItem(i));
    }

    Map<String, String> forTracksNotViewedInfo = {
      "language_id":
          Languages.values.indexOf(Utilities.currentLanguage).toString(),
      "voice": (Voices.values.indexOf(Utilities.curVoice)).toString(),
      "limit": "10",
      "skip": "0"
    };
    Map responceInfo = await Server.getUnViewedTracks(forTracksNotViewedInfo);
    switch (responceInfo["status_code"]) {
      case 200:
        var trackInfoNotViewed = responceInfo["tracks_info"];
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
        break;
      case 404:
        // Ошибка подключения к серверу
        break;
      default:
        // Ошибка
        break;
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
    controller = PageController(initialPage: curpage, keepPage: true);
    initFirst();
    loadTracks();
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
                            controller.animateToPage(1,
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
            controller: controller,
            scrollDirection: Axis.vertical,
            onPageChanged: (value) async {
              setState(() {
                toastViewed = true;
                Utilities.helpNotificationViewied();
              });
              Utilities.curPage.value = value;
              if (value == pages.length - 1 && !tracksEnd) {
                await loadTracks();
              }
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
