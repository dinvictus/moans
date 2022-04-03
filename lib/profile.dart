import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moans/changepass.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/elements/shimmer.dart';
import 'package:moans/elements/trackelement.dart';
import 'package:moans/login.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/utils/server.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  bool she = true;
  bool he = true;
  bool they = true;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final List<String> trackNames = [];
  final List<String> trackLikes = [];
  final List<int> trackIds = [];
  final List<int> trackStatuses = [];
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    loadingTracks();
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

  initVoice() {
    setState(() {
      if (Utilities.curVoice == Voices.sheHeThey) {
        she = true;
        he = true;
        they = true;
        return;
      }
      she = (Utilities.curVoice == Voices.she ||
          Utilities.curVoice == Voices.sheHe ||
          Utilities.curVoice == Voices.sheThey);
      he = (Utilities.curVoice == Voices.he ||
          Utilities.curVoice == Voices.sheHe ||
          Utilities.curVoice == Voices.heThey);
      they = (Utilities.curVoice == Voices.they ||
          Utilities.curVoice == Voices.heThey ||
          Utilities.curVoice == Voices.sheThey);
    });
  }

  changeVoice() {
    Utilities.changeVoice((she ? 1 : 0) * 1 +
        (he ? 1 : 0) * 2 +
        (they ? 1 : 0) * 3 +
        ((she ^ he ^ they) && !(she && he && they) ? 0 : 1) -
        1);
  }

  loadingTracks() async {
    setState(() {
      isLoading.value = true;
    });
    trackNames.clear();
    trackIds.clear();
    trackStatuses.clear();
    trackLikes.clear();
    Map<String, String> forProfileTracks = {"limit": "5", "skip": "0"};
    Map profileTracksInfo = await Server.getProfileTracks(forProfileTracks);
    switch (profileTracksInfo["status_code"]) {
      case 200:
        var myTracksInfo = profileTracksInfo["tracks_info"];
        for (int i = 0; i < myTracksInfo.length; i++) {
          trackNames.add(myTracksInfo[i]["name"]);
          trackIds.add(myTracksInfo[i]["id"]);
          trackStatuses.add(int.parse(myTracksInfo[i]["status"]));
          trackLikes.add(getLikeString(myTracksInfo[i]["likes"]));
        }
        setState(() {
          isLoading.value = false;
          initVoice();
        });
        break;
      case 403:
        await Server.logIn(Utilities.email, Utilities.password, null);
        loadingTracks();
        break;
      default:
        Utilities.showToast(Utilities.curLang.value["ServerError"]);
        Timer(const Duration(seconds: 15), () {
          loadingTracks();
        });
        break;
    }
  }

  Widget forLoadingShimmer() => Container(
        margin: EdgeInsets.only(bottom: height / 70),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff4b4b4f)))),
        height: height / 15,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              height: Utilities.deviceSizeMultiply / 25,
              width: width / 2.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.withAlpha(50),
              )),
          Container(
              height: Utilities.deviceSizeMultiply / 25,
              width: width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.withAlpha(50),
              )),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: const Color(0xff000014),
              appBar: AppBar(
                actions: const [MyDropButton()],
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  lang["Profile"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: Utilities.deviceSizeMultiply / 30),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.fromLTRB(20, height / 7, 20, height / 12),
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/back/back.png'),
                          fit: BoxFit.fill)),
                  child: RefreshIndicator(
                      displacement: 0,
                      backgroundColor: Colors.transparent,
                      color: MColors.mainColor,
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        await loadingTracks();
                      },
                      child: SizedBox(
                          height: height,
                          child: SingleChildScrollView(
                            physics: isLoading.value
                                ? const NeverScrollableScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Utilities.email,
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 22,
                                        fontWeight: FontWeight.bold)),
                                !Utilities.isGoogleSignUp
                                    ? SizedBox(height: height / 40)
                                    : const SizedBox(),
                                !Utilities.isGoogleSignUp
                                    ? GestureDetector(
                                        onTap: () {
                                          if (!isLoading.value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChangePassword()));
                                          }
                                        },
                                        child: Text(lang["ChangePas"],
                                            style: GoogleFonts.inter(
                                                color: MColors.mainColor,
                                                fontSize: Utilities
                                                        .deviceSizeMultiply /
                                                    38,
                                                decoration:
                                                    TextDecoration.underline)))
                                    : const SizedBox(),
                                SizedBox(height: height / 55),
                                GestureDetector(
                                    onTap: () {
                                      if (!isLoading.value) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const LogIn()),
                                            (route) => false);
                                        Utilities.logOut();
                                      }
                                    },
                                    child: Text(lang["Logout"],
                                        style: GoogleFonts.inter(
                                            color: MColors.mainColor,
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    38,
                                            decoration:
                                                TextDecoration.underline))),
                                SizedBox(height: height / 20),
                                Text(lang["Voice"],
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 29,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: height / 25),
                                Row(
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Checkbox(
                                          activeColor: Colors.transparent,
                                          value: she,
                                          tristate: false,
                                          onChanged: (value) {
                                            if (!isLoading.value) {
                                              setState(() {
                                                !he && !they
                                                    ? null
                                                    : she = value!;
                                                changeVoice();
                                              });
                                            }
                                          },
                                        )),
                                    Text(lang["she/her"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    41)),
                                    const Spacer(),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Checkbox(
                                          activeColor: Colors.transparent,
                                          value: he,
                                          tristate: false,
                                          onChanged: (value) {
                                            if (!isLoading.value) {
                                              setState(() {
                                                !she && !they
                                                    ? null
                                                    : he = value!;
                                                changeVoice();
                                              });
                                            }
                                          },
                                        )),
                                    Text(lang["he/him"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    41)),
                                    const Spacer(),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Checkbox(
                                          activeColor: Colors.transparent,
                                          value: they,
                                          tristate: false,
                                          onChanged: (value) {
                                            if (!isLoading.value) {
                                              setState(() {
                                                !he && !she
                                                    ? null
                                                    : they = value!;
                                                changeVoice();
                                              });
                                            }
                                          },
                                        )),
                                    Text(lang["they/them"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    41)),
                                  ],
                                ),
                                SizedBox(height: height / 12),
                                Text(lang["MyRec"],
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 23,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: height / 30),
                                ValueListenableBuilder<bool>(
                                    valueListenable: isLoading,
                                    builder: (_, isloading, child) {
                                      return isloading
                                          ? Shimmer(
                                              linearGradient: shimmerGradient,
                                              child: ListView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    ShimmerLoading(
                                                        isLoading: isloading,
                                                        child: Column(
                                                          children: [
                                                            forLoadingShimmer(),
                                                            forLoadingShimmer(),
                                                            forLoadingShimmer(),
                                                            forLoadingShimmer(),
                                                            forLoadingShimmer(),
                                                          ],
                                                        ))
                                                  ]),
                                            )
                                          : TrackElement(
                                              trackNames: trackNames,
                                              trackLikes: trackLikes,
                                              trackIds: trackIds,
                                              trackStatuses: trackStatuses,
                                              toUpdate: loadingTracks);
                                    })
                              ],
                            ),
                          )))));
        });
  }

  @override
  bool get wantKeepAlive => false;
}
