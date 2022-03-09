import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'res.dart';
import 'elements/dropbutton.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ConfirmEmailState();
  }
}

class ConfirmEmailState extends State<ConfirmEmail> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(16, 35, 16, 16),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/back/back.png'),
                    fit: BoxFit.fill)),
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ValueListenableBuilder<Map>(
                    valueListenable: Utilities.curLang,
                    builder: (_, lang, __) {
                      return Column(
                        children: [
                          Container(
                              alignment: Alignment.topRight,
                              child: MyDropButton(
                                  notifyParent: refresh, updateFeed: false)),
                          Container(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        lang["Thank"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: height / 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(height: height / 20),
                                  RichText(
                                      text: TextSpan(
                                          text: lang["ConfEmail"],
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: height / 50),
                                          children: [
                                            TextSpan(
                                                text: Utilities.email + "\n\n",
                                                style: const TextStyle(
                                                  color: MColors.mainColor,
                                                )),
                                            TextSpan(text: lang["ToConfEmail"]),
                                            TextSpan(
                                                text: lang["OurEmail"],
                                                style: const TextStyle(
                                                    color: MColors.mainColor,
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ]),
                                      textAlign: TextAlign.left),
                                  Container(height: height / 13),
                                  SizedBox(
                                    width: double.infinity,
                                    height: height / 15,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: MColors.mainColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                      ),
                                      child: Text(
                                        lang["Update"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: height / 50),
                                      ),
                                      onPressed: () {
                                        // Проверка email на подтверждение, потом далее
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainScreen()));
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      );
                    }))));
  }
}
