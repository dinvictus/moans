import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:moans/actionconfirm.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController controllerOldPassword = TextEditingController();
  final TextEditingController controllerNewPassword = TextEditingController();
  final ValueNotifier<String?> erTextOldPass = ValueNotifier<String?>(null);
  bool _submitter = false;

  Future<void> _submit() async {
    _errorTextOldPassword();
    setState(() {
      _submitter = true;
    });
    if (_errorTextNewPassword == null && erTextOldPass.value == null) {
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
    Utilities.showLoadingScreen(context);
    int statusCodePass = await Server.changePassword(userPasss);
    Navigator.of(context).pop();
    switch (statusCodePass) {
      case 200:
        Fluttertoast.showToast(msg: "Пароль успешно изменён!");
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context).pop();
        break;
      case 403:
        setState(() {
          erTextOldPass.value = Utilities.curLang.value["OldPassMatch"];
        });
        break;
      case 404:
        // Ошибка подключения к серверу
        break;
      default:
        // Ошибка
        break;
    }
  }

  @override
  void dispose() {
    controllerOldPassword.dispose();
    controllerNewPassword.dispose();
    super.dispose();
  }

  _errorTextOldPassword() {
    erTextOldPass.value = null;
  }

  String? get _errorTextNewPassword {
    return null;
  }

  Color _getColorErrorOldPassword() {
    return _submitter && erTextOldPass.value != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  Color _getColorErrorNewPassword() {
    return _submitter && _errorTextNewPassword != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                              Image.asset("assets/items/backbut.png", scale: 3),
                              const SizedBox(width: 15),
                              Text(lang["Back"], style: GoogleFonts.inter())
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
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: height / 7),
                            child: Text(lang["ChangePas"],
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 35,
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
                                        color: _getColorErrorOldPassword(),
                                        fontSize: 12),
                                  ),
                                  ValueListenableBuilder<String?>(
                                    valueListenable: erTextOldPass,
                                    builder: (_, value, __) {
                                      return Text(
                                        _submitter && value != null
                                            ? value
                                            : "",
                                        style: GoogleFonts.inter(
                                            color: const Color(0xffa72627),
                                            fontSize: 12),
                                      );
                                    },
                                  )
                                ])),
                        ValueListenableBuilder<String?>(
                            valueListenable: erTextOldPass,
                            builder: (_, value, __) {
                              return TextField(
                                controller: controllerOldPassword,
                                style: TextStyle(
                                    color: _getColorErrorOldPassword()),
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
                                  errorText: _submitter ? value : null,
                                  errorStyle:
                                      const TextStyle(fontSize: 0, height: 0),
                                ),
                                onChanged: (_) => setState(() {
                                  _submitter = false;
                                }),
                              );
                            }),
                        Container(
                            height: height / 21,
                            alignment: Alignment.bottomLeft,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lang["NewPass"],
                                      style: GoogleFonts.inter(
                                          color: _getColorErrorNewPassword(),
                                          fontSize: 12)),
                                  Text(
                                    _submitter && _errorTextNewPassword != null
                                        ? _errorTextNewPassword!
                                        : "",
                                    style: GoogleFonts.inter(
                                        color: const Color(0xffa72627),
                                        fontSize: 12),
                                  ),
                                ])),
                        TextField(
                          controller: controllerNewPassword,
                          obscureText: true,
                          style: TextStyle(color: _getColorErrorNewPassword()),
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff878789)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorText:
                                _submitter ? _errorTextNewPassword : null,
                            errorStyle: const TextStyle(fontSize: 0, height: 0),
                          ),
                          onChanged: (_) => setState(() {
                            _submitter = false;
                          }),
                        ),
                        SizedBox(height: height / 20),
                        SizedBox(
                          width: double.infinity,
                          height: height / 15,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: MColors.mainColor,
                              onSurface: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                            ),
                            child: Text(
                              lang["ChangePas"],
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: height / 50),
                            ),
                            onPressed: controllerOldPassword
                                        .value.text.isNotEmpty &&
                                    controllerNewPassword.value.text.isNotEmpty
                                ? _submit
                                : null,
                          ),
                        ),
                      ],
                    )),
              );
            }));
  }
}
