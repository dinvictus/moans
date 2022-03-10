import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/mainscreen.dart';
import 'package:moans/signup.dart';
import 'res.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'signup.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LogInState();
  }
}

class LogInState extends State<LogIn> {
  final _controllerEmail = TextEditingController();
  final _controllerPass = TextEditingController();
  final _scrollController = ScrollController();
  bool _submitter = false;
  refresh() {
    setState(() {});
  }

  Future<void> _submit() async {
    setState(() {
      _submitter = true;
    });
    if (_errorTextEmail == null && _errorTextPass == null) {
      var _passbyte = utf8.encode(_controllerPass.value.text);
      var _passhash = sha256.convert(_passbyte);
      var _user = {
        "email": _controllerEmail.value.text.toString(),
        "password": _passhash.toString()
      };
      var _responce = await http.post(
          Uri.parse("https://75db-92-101-232-21.ngrok.io/auth/"),
          body: jsonEncode(_user),
          headers: {"Content-Type": "application/json"});
      print(_responce.statusCode);
      if (_responce.statusCode == 200) {
        Map userInfo = jsonDecode(_responce.body);
        Utilities.authToken = userInfo["access_token"];
        print(userInfo["access_token"]);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        print(_responce.body);
      }
    }
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }

  String? get _errorTextEmail {
    final text = _controllerEmail.value.text.toString();
    if (!text.contains("@") || !text.contains(".")) {
      return Utilities.curLang.value["EmailNotCorrect"];
    }
    return null;
  }

  String? get _errorTextPass {
    final text = _controllerPass.value.text.toString();
    if (text.length <= 8) {
      return Utilities.curLang.value["ShortPass"];
    }
    return null;
  }

  Color _getColorErrorEmail() {
    return _submitter && _errorTextEmail != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  Color _getColorPassword() {
    return _submitter && _errorTextPass != null
        ? const Color(0xffa72627)
        : Colors.white;
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
            actions: [const MyDropButton()],
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
                                                color: _getColorErrorEmail(),
                                                fontSize: 12)),
                                        Text(
                                          _submitter && _errorTextEmail != null
                                              ? _errorTextEmail!
                                              : "",
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffa72627),
                                              fontSize: 12),
                                        ),
                                      ])),
                              TextField(
                                controller: _controllerEmail,
                                style: TextStyle(color: _getColorErrorEmail()),
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
                                  errorText:
                                      _submitter ? _errorTextEmail : null,
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
                                                color: _getColorPassword(),
                                                fontSize: 12)),
                                        Text(
                                          _submitter && _errorTextPass != null
                                              ? _errorTextPass!
                                              : "",
                                          style: GoogleFonts.inter(
                                              color: const Color(0xffa72627),
                                              fontSize: 12),
                                        ),
                                      ])),
                              TextField(
                                controller: _controllerPass,
                                obscureText: true,
                                style: TextStyle(color: _getColorPassword()),
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff878789)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  errorText: _submitter ? _errorTextPass : null,
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
                                  onPressed: _controllerEmail
                                              .value.text.isNotEmpty &&
                                          _controllerPass.value.text.isNotEmpty
                                      ? _submit
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
                                          onPressed: () async {
                                            GoogleSignIn _googleSignIn =
                                                GoogleSignIn(
                                              scopes: [
                                                'email',
                                                'https://www.googleapis.com/auth/contacts.readonly',
                                              ],
                                            );
                                            try {
                                              await _googleSignIn.signIn();
                                            } catch (error) {
                                              print(error);
                                            }
                                          },
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
                                  SizedBox(
                                    height: 40,
                                    width: 110,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          primary: const Color(0xff395693)),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                              "assets/items/facebooklogo.png"),
                                          Text(
                                            "Facebook",
                                            style: GoogleFonts.inter(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
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
