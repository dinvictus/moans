import 'package:flutter/material.dart';
import 'package:moans/elements/helprefresher.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeLanguage extends StatefulWidget {
  final List<String> _listLanguagesString;
  final Function() toRefreshParent;
  final bool updateFeed;
  final bool saveTrack;
  const ChangeLanguage(this._listLanguagesString, this.toRefreshParent,
      this.updateFeed, this.saveTrack,
      {Key? key})
      : super(key: key);

  @override
  State<ChangeLanguage> createState() {
    return ChangeLanguageState();
  }
}

class ChangeLanguageState extends State<ChangeLanguage> {
  final List<Container> _listLanguagesButtons = [];

  _init() {
    for (int i = 0; i < widget._listLanguagesString.length; i++) {
      setState(() {
        _listLanguagesButtons.add(_langButton(
            widget._listLanguagesString[i],
            (widget.saveTrack
                        ? Utilities.langForSaveTrack
                        : Utilities.currentLanguage) ==
                    widget._listLanguagesString[i]
                ? true
                : false));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Container _langButton(String language, bool active) {
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
                      Text(language),
                      Image.asset("assets/items/checkmark.png", scale: 3)
                    ],
                  )
                : SizedBox(width: double.infinity, child: Text(language))));
  }

  _changeLanguage(String language) {
    widget.saveTrack
        ? Utilities.langForSaveTrack = language
        : Utilities.changeLanguage(language);
    widget.toRefreshParent();
    _listLanguagesButtons.clear();
    _init();
    if (widget.updateFeed) {
      HelpRefresh.toUpdateFeed;
    }
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
                    Text(
                      Utilities.curLang["Back"],
                      style: GoogleFonts.inter(),
                    )
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
