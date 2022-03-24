import 'package:flutter/material.dart';
import 'package:moans/changepass.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/elements/shimmer.dart';
import 'package:moans/elements/trackelement.dart';
import 'package:moans/login.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    loadingTracks();
    // Utilities.logout.addListener(() {
    //   dispose();
    // });
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
    Map<String, String> forProfileTracks = {"limit": "20", "skip": "0"};
    Map profileTracksInfo = await Server.getProfileTracks(forProfileTracks);
    if (profileTracksInfo["status_code"] == 200) {
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
    } else {
      // Ошибка подключения к серверу
    }
  }

  Widget forLoadingShimmer = Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.withAlpha(50),
            )),
        const SizedBox(height: 5),
        Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.withAlpha(50),
            )),
        const SizedBox(height: 10)
      ]),
      Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey.withAlpha(50),
          )),
    ]),
    Container(
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 10),
        height: 1,
        color: const Color(0xff4b4b4f))
  ]);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = MediaQuery.of(context).size.height;
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
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
                ),
              ),
              body: Container(
                  padding: EdgeInsets.fromLTRB(20, height / 7, 20, 0),
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
                      child: SingleChildScrollView(
                        physics: isLoading.value
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Utilities.email,
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: height / 25,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: height / 40),
                            GestureDetector(
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
                                        fontSize: height / 45,
                                        decoration: TextDecoration.underline))),
                            SizedBox(height: height / 45),
                            GestureDetector(
                                onTap: () {
                                  if (!isLoading.value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LogIn()));
                                    Utilities.logOut();
                                  }
                                },
                                child: Text(lang["Logout"],
                                    style: GoogleFonts.inter(
                                        color: MColors.mainColor,
                                        fontSize: height / 45,
                                        decoration: TextDecoration.underline))),
                            SizedBox(height: height / 20),
                            Text(lang["Voice"],
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: height / 35,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: height / 25),
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Checkbox(
                                      activeColor: Colors.transparent,
                                      value: she,
                                      tristate: false,
                                      onChanged: (value) {
                                        if (!isLoading.value) {
                                          setState(() {
                                            !he && !they ? null : she = value!;
                                            changeVoice();
                                          });
                                        }
                                      },
                                    )),
                                Text(lang["she/her"],
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                                const Spacer(),
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Checkbox(
                                      activeColor: Colors.transparent,
                                      value: he,
                                      tristate: false,
                                      onChanged: (value) {
                                        if (!isLoading.value) {
                                          setState(() {
                                            !she && !they ? null : he = value!;
                                            changeVoice();
                                          });
                                        }
                                      },
                                    )),
                                Text(lang["he/him"],
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                                const Spacer(),
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Checkbox(
                                      activeColor: Colors.transparent,
                                      value: they,
                                      tristate: false,
                                      onChanged: (value) {
                                        if (!isLoading.value) {
                                          setState(() {
                                            !he && !she ? null : they = value!;
                                            changeVoice();
                                          });
                                        }
                                      },
                                    )),
                                Text(lang["they/them"],
                                    style:
                                        GoogleFonts.inter(color: Colors.white)),
                              ],
                            ),
                            SizedBox(height: height / 12),
                            Text(lang["MyRec"],
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: height / 25,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: height / 30),
                            ValueListenableBuilder<bool>(
                                valueListenable: isLoading,
                                builder: (_, isloading, child) {
                                  return isloading
                                      ? Shimmer(
                                          linearGradient: shimmerGradient,
                                          child: ListView(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              children: [
                                                ShimmerLoading(
                                                    isLoading: isloading,
                                                    child: Column(
                                                      children: [
                                                        forLoadingShimmer,
                                                        forLoadingShimmer,
                                                        forLoadingShimmer,
                                                        forLoadingShimmer,
                                                        forLoadingShimmer,
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
                      ))));
        });
  }

  @override
  bool get wantKeepAlive => false;
}
