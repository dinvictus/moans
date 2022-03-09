import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moans/changepass.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/elements/shimmer.dart';
import 'package:moans/elements/trackelement.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final Function() _toUpdate;
  const Profile(this._toUpdate, {Key? key}) : super(key: key);
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

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      isLoading.value = false;
      setState(() {});
    });
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

  final List<String> trackNames = [
    "Track 12345678",
    "hellothisismytracknameand",
    "Всем привет это моё название трека и он должен быть 50 символ",
    "Всем привет это моё название трека и он должен быть 50 символ",
    "Всем привет это моё название трека и он должен быть 50 символ"
  ];
  final List<String> trackLikes = ["45k", "345", "1k", "4k", "115k"];
  final List<int> trackIds = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: const Color(0xff000014),
              appBar: AppBar(
                actions: [
                  MyDropButton(notifyParent: widget._toUpdate, updateFeed: true)
                ],
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
                  child: SingleChildScrollView(
                    physics: isLoading.value
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
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
                                    border: Border.all(color: Colors.white)),
                                child: Checkbox(
                                  activeColor: Colors.transparent,
                                  value: she,
                                  tristate: false,
                                  onChanged: (value) {
                                    if (!isLoading.value) {
                                      setState(() {
                                        !he && !they ? null : she = value!;
                                      });
                                    }
                                  },
                                )),
                            Text(lang["she/her"],
                                style: GoogleFonts.inter(color: Colors.white)),
                            const Spacer(),
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Checkbox(
                                  activeColor: Colors.transparent,
                                  value: he,
                                  tristate: false,
                                  onChanged: (value) {
                                    if (!isLoading.value) {
                                      setState(() {
                                        !she && !they ? null : he = value!;
                                      });
                                    }
                                  },
                                )),
                            Text(lang["he/him"],
                                style: GoogleFonts.inter(color: Colors.white)),
                            const Spacer(),
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Checkbox(
                                  activeColor: Colors.transparent,
                                  value: they,
                                  tristate: false,
                                  onChanged: (value) {
                                    if (!isLoading.value) {
                                      setState(() {
                                        !he && !she ? null : they = value!;
                                      });
                                    }
                                  },
                                )),
                            Text(lang["they/them"],
                                style: GoogleFonts.inter(color: Colors.white)),
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
                                      trackIds: trackIds);
                            })
                      ],
                    ),
                  )));
        });
  }

  @override
  bool get wantKeepAlive => false;
}
