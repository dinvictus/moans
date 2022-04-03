import 'package:flutter/material.dart';
import 'package:moans/elements/appbarleading.dart';
import 'package:moans/utils/utilities.dart';
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
  final List<Container> listLanguagesButtons = [];
  late Languages curLanguage = widget.curLanguage;

  init() {
    for (int i = 0; i < Languages.values.length; i++) {
      setState(() {
        listLanguagesButtons.add(langButton(
            Languages.values[i], curLanguage == Languages.values[i]));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  back() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context, rootNavigator: true).pop();
  }

  Container langButton(Languages language, bool active) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.fromLTRB(
                    30,
                    Utilities.deviceSizeMultiply / 30,
                    20,
                    Utilities.deviceSizeMultiply / 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                side: BorderSide(color: Colors.white, width: active ? 2 : 1)),
            onPressed: () {
              !active ? changeLanguage(language) : null;
            },
            child: active
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          language == Languages.english ? "English" : "Русский",
                          style: GoogleFonts.inter(
                              fontSize: Utilities.deviceSizeMultiply / 30,
                              fontWeight: FontWeight.bold)),
                      Image.asset("assets/items/checkmark.png",
                          scale: 1500 / Utilities.deviceSizeMultiply)
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Text(
                        language == Languages.english ? "English" : "Русский",
                        style: GoogleFonts.inter(
                            fontSize: Utilities.deviceSizeMultiply / 30)))));
  }

  changeLanguage(Languages language) {
    curLanguage = language;
    widget.saveTrack
        ? widget.changeSaveTrackLanguage!(language)
        : Utilities.changeLanguage(language);

    listLanguagesButtons.clear();
    init();
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
          leading: AppBarLeading(back: back)),
      body: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back/back.png"), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: listLanguagesButtons,
        ),
      ),
    );
  }
}
