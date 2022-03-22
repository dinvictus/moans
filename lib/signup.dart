import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/login.dart';
import 'res.dart';
import 'elements/dropbutton.dart';
import 'confirmemail.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final controllerEmail = TextEditingController();
  final controllerPass = TextEditingController();
  bool submitter = false;
  submit() async {
    setState(() {
      submitter = true;
    });
    if (errorTextEmail == null && errorTextPass == null) {
      int statusCodeSignup = await Server.signUp(
          controllerEmail.value.text, controllerPass.value.text, context);
      switch (statusCodeSignup) {
        case 200:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConfirmEmail(controllerEmail.text, controllerPass.text)));
          break;
        case 404:
          // Ошибка подключения к серверу
          break;
        default:
          // Ошибка
          break;
      }
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPass.dispose();
    super.dispose();
  }

  String? get errorTextEmail {
    final text = controllerEmail.value.text.toString();
    if (!text.contains("@") || !text.contains(".")) {
      return Utilities.curLang.value["EmailNotCorrect"];
    }
    return null;
  }

  String? get errorTextPass {
    final text = controllerPass.value.text.toString();
    if (text.length <= 8) {
      return Utilities.curLang.value["ShortPass"];
    }
    return null;
  }

  Color getColorErrorEmail() {
    return submitter && errorTextEmail != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  Color getColorPassword() {
    return submitter && errorTextPass != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back/back.png'), fit: BoxFit.fill)),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              actions: const [MyDropButton()]),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              physics: MediaQuery.of(context).viewInsets.bottom == 0
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: ValueListenableBuilder<Map>(
                  valueListenable: Utilities.curLang,
                  builder: (_, lang, __) {
                    return Column(
                      children: [
                        SizedBox(height: height / 7),
                        Container(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 40, 20, 20),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      lang["SignUp"],
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: height / 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(height: height / 27),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              lang["Email"],
                                              style: GoogleFonts.inter(
                                                  color: getColorErrorEmail(),
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              submitter &&
                                                      errorTextEmail != null
                                                  ? errorTextEmail!
                                                  : "",
                                              style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xffa72627),
                                                  fontSize: 12),
                                            ),
                                          ])),
                                  TextField(
                                    controller: controllerEmail,
                                    style:
                                        TextStyle(color: getColorErrorEmail()),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff878789)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      hintText: "example@example.com",
                                      hintStyle: const TextStyle(
                                          color: Color(0xff878789)),
                                      errorText:
                                          submitter ? errorTextEmail : null,
                                      errorStyle: const TextStyle(
                                          fontSize: 0, height: 0),
                                    ),
                                    onChanged: (_) => setState(() {
                                      submitter = false;
                                    }),
                                  ),
                                  Container(
                                      height: height / 21,
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(lang["CreatePass"],
                                                style: GoogleFonts.inter(
                                                    color: getColorPassword(),
                                                    fontSize: 12)),
                                            Text(
                                              submitter && errorTextPass != null
                                                  ? errorTextPass!
                                                  : "",
                                              style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xffa72627),
                                                  fontSize: 12),
                                            ),
                                          ])),
                                  TextField(
                                    controller: controllerPass,
                                    obscureText: true,
                                    style: TextStyle(color: getColorPassword()),
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff878789)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      errorText:
                                          submitter ? errorTextPass : null,
                                      errorStyle: const TextStyle(
                                          fontSize: 0, height: 0),
                                    ),
                                    onChanged: (_) => setState(() {
                                      submitter = false;
                                    }),
                                  ),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, height / 25, 0, 0),
                                      child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                color: const Color(0xff878789),
                                                fontSize: height / 50,
                                              ),
                                              text: lang["SignText1"],
                                              children: [
                                            TextSpan(
                                                text: lang["SignText2"],
                                                style: GoogleFonts.inter(
                                                    color: MColors.mainColor,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {}),
                                            TextSpan(text: lang["SignText3"]),
                                            TextSpan(
                                                text: lang["SignText4"],
                                                style: GoogleFonts.inter(
                                                    color: MColors.mainColor,
                                                    decoration: TextDecoration
                                                        .underline),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {}),
                                            TextSpan(text: lang["SignText5"]),
                                          ]))),
                                  Container(height: height / 13),
                                  SizedBox(
                                    width: double.infinity,
                                    height: height / 15,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        onSurface: Colors.white,
                                        primary: MColors.mainColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                      ),
                                      child: Text(
                                        lang["SignUp"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: height / 50),
                                      ),
                                      onPressed: controllerEmail
                                                  .value.text.isNotEmpty &&
                                              controllerPass
                                                  .value.text.isNotEmpty
                                          ? submit
                                          : null,
                                    ),
                                  ),
                                  Container(
                                      height: height / 8,
                                      alignment: Alignment.center,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              lang["HaveAcc"],
                                              style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xffcfcfd0),
                                                  fontSize: height / 50),
                                            ),
                                            Container(width: 10),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LogIn()));
                                                },
                                                child: Text(
                                                  lang["login"],
                                                  style: GoogleFonts.inter(
                                                      color: MColors.mainColor,
                                                      fontSize: height / 50,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ))
                                          ])),
                                ],
                              ),
                            )),
                      ],
                    );
                  })),
        ));
  }
}
