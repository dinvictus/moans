import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/login.dart';
import 'package:moans/utils/server.dart';
import 'package:moans/utils/utilities.dart';
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
  String? errorPassText;
  String? errorEmailText;
  bool submitter = false;
  submit() async {
    setState(() {
      submitter = true;
      errorTextEmail();
      errorTextPass();
    });
    if (errorEmailText == null && errorPassText == null) {
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
        case 306:
          setState(() {
            errorEmailText = Utilities.curLang.value["UserAlreadyExists"];
          });
          break;
        case 404:
          Utilities.showToast(Utilities.curLang.value["ServerError"]);
          break;
        default:
          Utilities.showToast(Utilities.curLang.value["Error"]);
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

  errorTextEmail() {
    final text = controllerEmail.value.text.toString();
    if (!text.contains("@") || !text.contains(".")) {
      errorEmailText = Utilities.curLang.value["EmailNotCorrect"];
    } else {
      errorEmailText = null;
    }
  }

  errorTextPass() {
    final text = controllerPass.value.text.toString();
    if (text.length < 8) {
      errorPassText = Utilities.curLang.value["ShortPass"];
    } else {
      errorPassText = null;
    }
  }

  Color getColorErrorEmail() {
    return submitter && errorEmailText != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  Color getColorPassword() {
    return submitter && errorPassText != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                        SizedBox(height: height / 10),
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
                                          fontSize:
                                              Utilities.deviceSizeMultiply / 18,
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
                                                  fontSize: Utilities
                                                          .deviceSizeMultiply /
                                                      40),
                                            ),
                                            Text(
                                              submitter &&
                                                      errorEmailText != null
                                                  ? errorEmailText!
                                                  : "",
                                              style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xffa72627),
                                                  fontSize: Utilities
                                                          .deviceSizeMultiply /
                                                      40),
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
                                          submitter ? errorEmailText : null,
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
                                                    fontSize: Utilities
                                                            .deviceSizeMultiply /
                                                        40)),
                                            Text(
                                              submitter && errorPassText != null
                                                  ? errorPassText!
                                                  : "",
                                              style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xffa72627),
                                                  fontSize: Utilities
                                                          .deviceSizeMultiply /
                                                      40),
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
                                          submitter ? errorPassText : null,
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
                                                  color:
                                                      const Color(0xff878789),
                                                  fontSize: Utilities
                                                          .deviceSizeMultiply /
                                                      40,
                                                  height: Utilities
                                                          .deviceSizeMultiply /
                                                      350),
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
                                    height: height / 16,
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
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    30),
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
                                                  fontSize: Utilities
                                                          .deviceSizeMultiply /
                                                      35),
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
                                                      fontSize: Utilities
                                                              .deviceSizeMultiply /
                                                          35,
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
