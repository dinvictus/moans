import 'package:flutter/material.dart';
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
  late PageController controller;
  final List<dynamic> pages = [];
  bool toastViewed = Utilities.showHelpNotification;
  bool tracksEnd = false;

  refreshFeed() async {
    await Server.refreshFeed();
    pages.clear();
    Utilities.handlers.removeRange(1, Utilities.handlers.length);
    setState(() {});
    loadTracks();
  }

  loadTracks() async {
    int counter = pages.length;
    for (int i = counter; i < counter + 10; i++) {
      pages.add(AudioItem(i));
    }
    if (controller.hasClients) {
      controller.jumpToPage(0);
    }

    Map<String, String> forTracksInfo = {
      "language_id":
          Languages.values.indexOf(Utilities.currentLanguage).toString(),
      "voice": (Voices.values.indexOf(Utilities.curVoice)).toString(),
    };
    Map responceInfo = await Server.getTracks(forTracksInfo);
    switch (responceInfo["status_code"]) {
      case 200:
        var tracksInfo = responceInfo["tracks_info"];
        if (tracksInfo.length != 0) {
          int j = 0;
          for (int i = counter; i < counter + tracksInfo.length; i++) {
            List<String> tags = tracksInfo[j]["tags"].toString().split(" ");
            bool liked = tracksInfo[j]["liked"] != null ? true : false;
            pages[i].addInfo(
                tracksInfo[j]["name"],
                tracksInfo[j]["description"],
                tags,
                tracksInfo[j]["likes"],
                tracksInfo[j]["id"],
                liked);
            Utilities.handlers.add(pages[i].audioManager);
            j++;
          }
        }
        if (tracksInfo.length < 10) {
          tracksEnd = true;
          int voidPages = pages.length - 1 - (10 - tracksInfo.length) as int;
          for (int i = pages.length - 1; i > voidPages; i--) {
            pages.removeAt(i);
          }
          pages.add(EndFeedItem(refreshFeed));
          setState(() {});
          return;
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

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: curpage, keepPage: true);
    loadTracks();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
