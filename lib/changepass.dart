import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moans/actionconfirm.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/utils/server.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController controllerOldPassword = TextEditingController();
  final TextEditingController controllerNewPassword = TextEditingController();
  String? erTextOldPass;
  String? erTextNewPass;
  bool _submitter = false;

  Future<void> _submit() async {
    errorTextOldPassword();
    setState(() {
      _submitter = true;
      errorTextNewPassword();
      errorTextOldPassword();
    });
    if (erTextNewPass == null && erTextOldPass == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActionConfirm(confirmtrue: changePass)));
    }
  }

  changePass() async {
    Map<String, String> userPasss = {
      "email": Utilities.email,
      "password": controllerOldPassword.text,
      "new_password": controllerNewPassword.text
    };
    int statusCodePass = await Server.changePassword(userPasss, context);
    switch (statusCodePass) {
      case 200:
        Utilities.showToast(Utilities.curLang.value["ToastChangePass"]);
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context, rootNavigator: true).pop();
        break;
      case 403:
        setState(() {
          erTextOldPass = Utilities.curLang.value["OldPassMatch"];
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

  @override
  void dispose() {
    controllerOldPassword.dispose();
    controllerNewPassword.dispose();
    super.dispose();
  }

  errorTextOldPassword() {
    final text = controllerOldPassword.value.text.toString();
    if (text.length < 8) {
      erTextOldPass = Utilities.curLang.value["ShortPass"];
    } else {
      erTextOldPass = null;
    }
  }

  errorTextNewPassword() {
    final text = controllerNewPassword.value.text.toString();
    if (text.length < 8) {
      return Utilities.curLang.value["ShortPass"];
    } else {
      erTextNewPass = null;
    }
  }

  Color getColorErrorOldPassword() {
    return _submitter && erTextOldPass != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  Color getColorErrorNewPassword() {
    return _submitter && erTextNewPass != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back/back.png'), fit: BoxFit.fill)),
        alignment: Alignment.topCenter,
        child: ValueListenableBuilder<Map>(
            valueListenable: Utilities.curLang,
            builder: (_, lang, __) {
              return Scaffold(
                  backgroundColor: Colors.transparent,
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leadingWidth: 100,
                    leading: Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.all(0),
                                primary: Colors.transparent),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Image.asset("assets/items/backbut.png",
                                    scale: 1800 / Utilities.deviceSizeMultiply),
                                SizedBox(
                                  width: width / 30,
                                ),
                                Text(
                                  lang["Back"],
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 40),
                                )
                              ],
                            ))),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    physics: MediaQuery.of(context).viewInsets.bottom == 0
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: height / 7),
                                child: Text(lang["ChangePas"],
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize:
                                            Utilities.deviceSizeMultiply / 20,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(
                              height: height / 15,
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        lang["OldPass"],
                                        style: GoogleFonts.inter(
                                            color: getColorErrorOldPassword(),
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    41),
                                      ),
                                      Text(
                                        _submitter && erTextOldPass != null
                                            ? erTextOldPass!
                                            : "",
                                        style: GoogleFonts.inter(
                                            color: const Color(0xffa72627),
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    41),
                                      )
                                    ])),
                            TextField(
                              controller: controllerOldPassword,
                              style:
                                  TextStyle(color: getColorErrorOldPassword()),
                              autofocus: true,
                              obscureText: true,
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff878789)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorText: _submitter ? erTextOldPass : null,
                                errorStyle:
                                    const TextStyle(fontSize: 0, height: 0),
                              ),
                              onChanged: (_) => setState(() {
                                _submitter = false;
                              }),
                            ),
                            Container(
                                height: height / 21,
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(lang["NewPass"],
                                          style: GoogleFonts.inter(
                                              color: getColorErrorNewPassword(),
                                              fontSize:
                                                  Utilities.deviceSizeMultiply /
                                                      41)),
                                      Text(
                                        _submitter && erTextNewPass != null
                                            ? erTextNewPass!
                                            : "",
                                        style: GoogleFonts.inter(
                                            color: const Color(0xffa72627),
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    41),
                                      ),
                                    ])),
                            TextField(
                              controller: controllerNewPassword,
                              obscureText: true,
                              style:
                                  TextStyle(color: getColorErrorNewPassword()),
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff878789)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorText: _submitter ? erTextNewPass : null,
                                errorStyle:
                                    const TextStyle(fontSize: 0, height: 0),
                              ),
                              onChanged: (_) => setState(() {
                                _submitter = false;
                              }),
                            ),
                            SizedBox(height: height / 20),
                            SizedBox(
                              width: double.infinity,
                              height: height / 16,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: MColors.mainColor,
                                  onSurface: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                                child: Text(
                                  lang["ChangePas"],
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 35),
                                ),
                                onPressed: controllerOldPassword
                                            .value.text.isNotEmpty &&
                                        controllerNewPassword
                                            .value.text.isNotEmpty
                                    ? _submit
                                    : null,
                              ),
                            ),
                          ],
                        )),
                  ));
            }));
  }
}
