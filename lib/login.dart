import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/mainscreen.dart';
import 'package:moans/signup.dart';
import 'res.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';

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
  bool _submitter = false;
  submit() async {
    setState(() {
      _submitter = true;
    });
    if (Utilities.isConnectedToServer) {
      if (errorTextEmail == null && errorTextPass == null) {
        int statusCodeLogin = await Server.logIn(
            controllerEmail.value.text, controllerPass.value.text, context);
        switch (statusCodeLogin) {
          case 200:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
            break;
          case 404:
            // Ошибка подключения к серверу
            break;
          default:
            // Ошибка
            break;
        }
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
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
    return _submitter && errorTextEmail != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  Color getColorPassword() {
    return _submitter && errorTextPass != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  googleAuth() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    await _googleSignIn.disconnect();
    try {
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser!.email.toString());
      final GoogleSignInAuthentication googleAuth =
          await _googleSignIn.currentUser!.authentication;
      print(googleAuth.idToken);
      // Переход дальше
    } catch (error) {
      // Окошко с ошибкой
      print(error);
    }
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
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  lang["login"],
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: height / 20,
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
                                                fontSize: 12)),
                                        Text(
                                          _submitter && errorTextEmail != null
                                              ? errorTextEmail!
                                              : "",
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffa72627),
                                              fontSize: 12),
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
                                  errorText: _submitter ? errorTextEmail : null,
                                  errorStyle:
                                      const TextStyle(fontSize: 0, height: 0),
                                ),
                                onChanged: (_) => setState(() {
                                  _submitter = false;
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
                                                fontSize: 12)),
                                        Text(
                                          _submitter && errorTextPass != null
                                              ? errorTextPass!
                                              : "",
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffa72627),
                                              fontSize: 12),
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
                                  errorText: _submitter ? errorTextPass : null,
                                  errorStyle:
                                      const TextStyle(fontSize: 0, height: 0),
                                ),
                                onChanged: (_) => setState(() {
                                  _submitter = false;
                                }),
                              ),
                              Container(height: height / 20),
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
                                    lang["login"],
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: height / 50),
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
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          lang["LogQues"],
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffcfcfd0),
                                              fontSize: height / 50),
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
                                                  fontSize: height / 50,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ))
                                      ])),
                              SizedBox(
                                  height: 30,
                                  child: Text(
                                    lang["Continue"],
                                    style: GoogleFonts.inter(
                                        color: const Color(0xffcfcfd0)),
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      width: 110,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: const Color(0xfff7f7f7),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 15, 5)),
                                          onPressed: () => googleAuth(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                  "assets/items/googlelogo.png"),
                                              Text("Google",
                                                  style: GoogleFonts.inter(
                                                      color: Colors.black)),
                                            ],
                                          ))),
                                ],
                              ),
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
                                        fontSize: height / 50,
                                      ),
                                    ),
                                    Container(height: 5),
                                    Text(lang["Click"],
                                        style: GoogleFonts.inter(
                                            color: MColors.mainColor,
                                            fontSize: height / 50,
                                            decoration:
                                                TextDecoration.underline))
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
