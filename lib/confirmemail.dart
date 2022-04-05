import 'package:flutter/material.dart';
import 'package:moans/utils/server.dart';
import 'mainscreen.dart';
import 'package:moans/utils/utilities.dart';
import 'elements/dropbutton.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmEmail extends StatelessWidget {
  final String email;
  final String pass;
  const ConfirmEmail(this.email, this.pass, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back/back.png'), fit: BoxFit.fill)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                actions: const [MyDropButton()]),
            body: ValueListenableBuilder<Map>(
                valueListenable: Utilities.curLang,
                builder: (_, lang, __) {
                  return Column(
                    children: [
                      SizedBox(height: height / 7),
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
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(height: height / 20),
                              RichText(
                                  text: TextSpan(
                                      text: lang["ConfEmail"],
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize:
                                              Utilities.deviceSizeMultiply /
                                                  35),
                                      children: [
                                        TextSpan(
                                            text: email + "\n\n",
                                            style: const TextStyle(
                                              color: MColors.mainColor,
                                            )),
                                        TextSpan(text: lang["ToConfEmail"]),
                                        TextSpan(
                                            text: lang["OurEmail"],
                                            style: const TextStyle(
                                                color: MColors.mainColor,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ]),
                                  textAlign: TextAlign.left),
                              Container(height: height / 13),
                              SizedBox(
                                width: double.infinity,
                                height: height / 16,
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
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 30),
                                  ),
                                  onPressed: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    int statusCodeLogin = await Server.logIn(
                                        email, pass, context);
                                    switch (statusCodeLogin) {
                                      case 200:
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MainScreen()),
                                            (route) => false);
                                        break;
                                      case 404:
                                        Utilities.showToast(Utilities
                                            .curLang.value["ServerError"]);
                                        break;
                                      case 401:
                                        break;
                                      case 426:
                                        Utilities.showToast(Utilities
                                            .curLang.value["EmailNotConfirm"]);
                                        break;
                                      default:
                                        Utilities.showToast(
                                            Utilities.curLang.value["Error"]);
                                        break;
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  );
                })));
  }
}
