import 'package:flutter/material.dart';
import 'mainscreen.dart';
import 'res.dart';
import 'elements/dropbutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConfirmEmail extends StatefulWidget {
  final String email;
  final String pass;
  const ConfirmEmail(this.email, this.pass, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ConfirmEmailState();
  }
}

class ConfirmEmailState extends State<ConfirmEmail> {
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
                              child: const MyDropButton()),
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
                                      onPressed: () async {
                                        // Проверка email на подтверждение, потом далее
                                        if (true) {
                                          var _passbyte =
                                              utf8.encode(widget.pass);
                                          var _passhash =
                                              sha256.convert(_passbyte);
                                          var _user = {
                                            "email": widget.email,
                                            "password": _passhash.toString()
                                          };
                                          var _responce = await http.post(
                                              Uri.parse(
                                                  "https://75db-92-101-232-21.ngrok.io/auth/"),
                                              body: jsonEncode(_user),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              });
                                          print(_responce.statusCode);
                                          if (_responce.statusCode == 200) {
                                            Map userInfo =
                                                jsonDecode(_responce.body);
                                            Utilities.authToken =
                                                userInfo["access_token"];
                                            print(userInfo["access_token"]);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainScreen()));
                                          } else {
                                            print(_responce.body);
                                          }
                                        }
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
