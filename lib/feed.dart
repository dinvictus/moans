import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:moans/elements/audiomanager.dart';
import 'package:moans/elements/helprefresher.dart';
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
  final List<AudioItem> _pages = [];
  final List<AudioManager> _handlers = [];
  bool toastViewed = Strings.showHelpNotification;
  refresh() {
    setState(() {});
  }

  _initFirst() async {
    _pages.add(AudioItem("Track name11",
        "The description will be displayed here, or it will be not.", 0));
    _pages.add(AudioItem("Track name2",
        "The description will be displayed here, or it will be not.", 1));
    _pages.add(AudioItem("Track name3",
        "The description will be displayed here, or it will be not.", 2));
    Strings.managerForRecord = AudioManager("", "Record", 0);
    _handlers.add(Strings.managerForRecord);
    _handlers.add(_pages[0].audioManager);
    _handlers.add(_pages[1].audioManager);
    _handlers.add(_pages[2].audioManager);
    Strings.audioHandler = await AudioService.init(
        builder: () => AudioSwitchHandler(_handlers),
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
    HelpRefresh.toUpdateFeed2 = refresh;
    _initFirst();
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  items: [],
                  onChanged: (value) {
                    value = value;
                  },
                  underline: Container(color: Colors.transparent),
                  icon: Image.asset(
                    'assets/items/menu.png',
                    scale: 3,
                  ),
                ))
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/back/backfeed.png'),
                  fit: BoxFit.fill)),
          child: PageView.builder(
            itemBuilder: (context, position) {
              return _pages[position];
            },
            controller: _controller,
            scrollDirection: Axis.vertical,
            onPageChanged: (value) async {
              setState(() {
                toastViewed = true;
                Strings.helpNotificationViewied();
              });
              Strings.curPage.value = value;
              if (value > prepage) {
                prepage = value;
                _pages.add(AudioItem(
                    "Track name Added fsdfsdf sdfsd ? sfsdfsd! ffsdfds",
                    "The description will be displayed here, or it will be not.",
                    value + 1));
                _handlers.add(_pages[value + 1].audioManager);
              }
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
