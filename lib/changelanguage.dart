import 'package:flutter/material.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeLanguage extends StatefulWidget {
  final Function? changeSaveTrackLanguage;
  final Languages curLanguage;
  final bool saveTrack;
  const ChangeLanguage(
      this.curLanguage, this.saveTrack, this.changeSaveTrackLanguage,
      {Key? key})
      : super(key: key);

  @override
  State<ChangeLanguage> createState() {
    return _ChangeLanguageState();
  }
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  final List<Container> _listLanguagesButtons = [];
  late Languages curLanguage = widget.curLanguage;

  _init() {
    for (int i = 0; i < Languages.values.length; i++) {
      setState(() {
        _listLanguagesButtons.add(_langButton(
            Languages.values[i], curLanguage == Languages.values[i]));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Container _langButton(Languages language, bool active) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                side: BorderSide(color: Colors.white, width: active ? 2 : 1)),
            onPressed: () {
              !active ? _changeLanguage(language) : null;
            },
            child: active
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language == Languages.english
                          ? "English"
                          : "Русский"),
                      Image.asset("assets/items/checkmark.png", scale: 3)
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Text(language == Languages.english
                        ? "English"
                        : "Русский"))));
  }

  _changeLanguage(Languages language) {
    curLanguage = language;
    widget.saveTrack
        ? widget.changeSaveTrackLanguage!(language)
        : Utilities.changeLanguage(language);

    _listLanguagesButtons.clear();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        leading: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    primary: Colors.transparent),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset("assets/items/backbut.png", scale: 3),
                    const SizedBox(
                      width: 15,
                    ),
                    ValueListenableBuilder<Map>(
                        valueListenable: Utilities.curLang,
                        builder: (_, lang, __) {
                          return Text(
                            lang["Back"],
                            style: GoogleFonts.inter(),
                          );
                        })
                  ],
                ))),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back/back.png"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _listLanguagesButtons,
        ),
      ),
    );
  }
}
