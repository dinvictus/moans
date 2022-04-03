import 'package:flutter/material.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/forgotpassword.dart';
import 'package:moans/mainscreen.dart';
import 'package:moans/signup.dart';
import 'package:moans/utils/server.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';
import 'dart:io' show Platform;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() {
    return _LogInState();
  }
}

class _LogInState extends State<LogIn> {
  final controllerEmail = TextEditingController();
  final controllerPass = TextEditingController();
  bool submitter = false;
  String? errorPassText;
  String? errorEmailText;
  submit() async {
    setState(() {
      submitter = true;
      errorTextEmail();
      errorTextPass();
    });
    if (errorEmailText == null && errorPassText == null) {
      int statusCodeLogin = await Server.logIn(
          controllerEmail.value.text, controllerPass.value.text, context);
      switch (statusCodeLogin) {
        case 200:
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (route) => false);
          break;
        case 401:
          setState(() {
            errorEmailText = Utilities.curLang.value["InvalidUser"];
            errorPassText = Utilities.curLang.value["InvalidUser"];
          });
          break;
        case 404:
          Utilities.showToast(Utilities.curLang.value["ServerError"]);
          break;
        case 422:
          setState(() {
            errorEmailText = Utilities.curLang.value["EmailNotCorrect"];
          });
          break;
        default:
          Utilities.showToast(Utilities.curLang.value["Error"]);
          break;
      }
    }
  }

  back() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPass.dispose();
    super.dispose();
  }

  errorTextEmail() {
    final text = controllerEmail.value.text.toString();
    if (!text.contains("@") ||
        !text.contains(".") ||
        text.indexOf("@") == 0 ||
        text.indexOf(".") == text.length - 1) {
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

  googleAuth() async {
    int statusCodeGoogleSignUp = await Server.googleSignUp(context);
    if (statusCodeGoogleSignUp == 200) {
      Utilities.setGoogleSignUp();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      Utilities.showToast(Utilities.curLang.value["Error"]);
    }
  }

  Widget getAuthButtons(double height) {
    return Column(children: [
      SizedBox(
          child: Text(Utilities.curLang.value["Continue"],
              style: GoogleFonts.inter(
                  color: const Color(0xffcfcfd0),
                  fontSize: Utilities.deviceSizeMultiply / 35))),
      SizedBox(height: height / 50),
      SizedBox(
          height: 40,
          width: 110,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xfff7f7f7),
                  padding: const EdgeInsets.fromLTRB(10, 5, 15, 5)),
              onPressed: () => googleAuth(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/items/googlelogo.png"),
                  Text("Google", style: GoogleFonts.inter(color: Colors.black)),
                ],
              ))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back/back.png'), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: const [MyDropButton()],
          ),
          extendBodyBehindAppBar: true,
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
                        Container(
                          margin: EdgeInsets.only(top: height / 10),
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  lang["login"],
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(height: height / 30),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(lang["Email"],
                                            style: GoogleFonts.inter(
                                                color: getColorErrorEmail(),
                                                fontSize: Utilities
                                                        .deviceSizeMultiply /
                                                    40)),
                                        Text(
                                          submitter && errorEmailText != null
                                              ? errorEmailText!
                                              : "",
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffa72627),
                                              fontSize:
                                                  Utilities.deviceSizeMultiply /
                                                      40),
                                        ),
                                      ])),
                              TextField(
                                controller: controllerEmail,
                                style: TextStyle(color: getColorErrorEmail()),
                                autofocus: true,
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff878789)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  hintText: "example@example.com",
                                  hintStyle:
                                      const TextStyle(color: Color(0xff878789)),
                                  errorText: submitter ? errorEmailText : null,
                                  errorStyle:
                                      const TextStyle(fontSize: 0, height: 0),
                                ),
                                onChanged: (_) => setState(() {
                                  submitter = false;
                                }),
                              ),
                              Container(
                                  height: height / 20,
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(lang["Password"],
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
                                              color: const Color(0xffa72627),
                                              fontSize:
                                                  Utilities.deviceSizeMultiply /
                                                      40),
                                        ),
                                      ])),
                              TextField(
                                controller: controllerPass,
                                obscureText: true,
                                style: TextStyle(color: getColorPassword()),
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff878789)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  errorText: submitter ? errorPassText : null,
                                  errorStyle:
                                      const TextStyle(fontSize: 0, height: 0),
                                ),
                                onChanged: (_) => setState(() {
                                  submitter = false;
                                }),
                              ),
                              Container(height: height / 20),
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
                                    lang["login"],
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 34),
                                  ),
                                  onPressed: controllerEmail
                                              .value.text.isNotEmpty &&
                                          controllerPass.value.text.isNotEmpty
                                      ? submit
                                      : null,
                                ),
                              ),
                              Container(
                                  height: height / 12,
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                        Text(
                                          lang["LogQues"],
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffcfcfd0),
                                              fontSize:
                                                  Utilities.deviceSizeMultiply /
                                                      35),
                                        ),
                                        Container(width: 10),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignUp()));
                                            },
                                            child: Text(
                                              lang["Signup"],
                                              style: GoogleFonts.inter(
                                                  color: MColors.mainColor,
                                                  fontSize: Utilities
                                                          .deviceSizeMultiply /
                                                      35,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ))
                                      ]))),
                              Platform.isAndroid
                                  ? getAuthButtons(height)
                                  : const SizedBox(),
                              Container(
                                height: height / 10,
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      lang["Forgotpass"],
                                      style: GoogleFonts.inter(
                                        color: const Color(0xff878789),
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 35,
                                      ),
                                    ),
                                    Container(height: 5),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgotPassword(
                                                          back: back)));
                                        },
                                        child: Text(lang["Click"],
                                            style: GoogleFonts.inter(
                                                color: MColors.mainColor,
                                                fontSize: Utilities
                                                        .deviceSizeMultiply /
                                                    35,
                                                decoration:
                                                    TextDecoration.underline)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  })),
        ));
  }
}
