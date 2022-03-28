import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moans/elements/endfeeditem.dart';
import 'package:moans/utils/utilities.dart';
import 'package:moans/utils/server.dart';
import 'elements/audioitem.dart';
import 'package:google_fonts/google_fonts.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() {
    return _FeedState();
  }
}

int curpage = 0;

class _FeedState extends State<Feed> with AutomaticKeepAliveClientMixin {
  late final PageController controller;
  final List<dynamic> pages = [];
  bool tracksEnd = false;
  bool refreshingFeed = false;
  bool forHintView = true;

  refreshFeed() async {
    if (!refreshingFeed) {
      refreshingFeed = true;
      await Server.refreshFeed();
      pages.clear();
      Utilities.handlers.removeRange(1, Utilities.handlers.length);
      setState(() {});
      loadTracks();
      refreshingFeed = false;
      tracksEnd = false;
    }
  }

  loadTracks() async {
    int counter = pages.length;
    for (int i = counter; i < counter + 10; i++) {
      pages.add(AudioItem(i));
    }
    if (controller.hasClients && refreshingFeed) {
      controller.jumpToPage(0);
    }

    Map<String, String> forTracksInfo = {
      "language_id":
          Languages.values.indexOf(Utilities.currentLanguage).toString(),
      "voice": (Voices.values.indexOf(Utilities.curVoice)).toString(),
    };
    Map responceInfo = await Server.getTracks(forTracksInfo);
    if (responceInfo["status_code"] == 200) {
      var tracksInfo = responceInfo["tracks_info"];
      if (tracksInfo.length != 0) {
        int j = 0;
        for (int i = counter; i < counter + tracksInfo.length; i++) {
          List<String> tags = tracksInfo[j]["tags"].toString().split(" ");
          bool liked = tracksInfo[j]["liked"] != null ? true : false;
          pages[i].addInfo(tracksInfo[j]["name"], tracksInfo[j]["description"],
              tags, tracksInfo[j]["likes"], tracksInfo[j]["id"], liked);
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
    } else {
      Utilities.showToast(Utilities.curLang.value["ServerError"]);
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

  animateHint() {
    forHintView = false;
    Timer(const Duration(milliseconds: 600), () {
      Utilities.helpNotificationViewied();
    });
  }

  Widget getHint() {
    return AnimatedOpacity(
        opacity: forHintView ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Align(
            alignment: const Alignment(0, 0.67),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                  height: Utilities.deviceSizeMultiply / 14,
                  width: Utilities.deviceSizeMultiply / 14,
                  child: Image.asset("assets/items/hint.png")),
              SizedBox(height: Utilities.deviceSizeMultiply / 40),
              SizedBox(
                  width: Utilities.deviceSizeMultiply / 3,
                  child: Text(Utilities.curLang.value["HintFeed"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: Utilities.deviceSizeMultiply / 30,
                          fontWeight: FontWeight.bold)))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
            child: Stack(children: [
              Utilities.showHelpNotification ? getHint() : const SizedBox(),
              PageView.builder(
                itemCount: pages.length,
                itemBuilder: (context, position) {
                  return pages[position];
                },
                controller: controller,
                scrollDirection: Axis.vertical,
                onPageChanged: (value) async {
                  setState(() {
                    if (Utilities.showHelpNotification) {
                      animateHint();
                    }
                  });
                  Utilities.curPage.value = value;
                  if (value == pages.length - 1 && !tracksEnd) {
                    await loadTracks();
                  }
                },
              ),
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}
