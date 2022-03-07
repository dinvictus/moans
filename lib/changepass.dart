import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:moans/actionconfirm.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<ChangePassword> createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _controllerOldPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  final ValueNotifier<String?> _erTextOldPass = ValueNotifier<String?>(null);
  bool _submitter = false;

  Future<void> changepass() async {
    Utilities.showLoadingScreen(context);
    // Запрос к серверу на смену пароля, добавить окошко загрузки на время запроса и окно с подтверждением или ошибкой
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pop();
      print("Change Pass");
      Fluttertoast.showToast(msg: "Пароль успешно изменён!");
      Navigator.of(context).pop();
    });
  }

  Future<void> _submit() async {
    _errorTextOldPassword();
    setState(() {
      _submitter = true;
    });
    if (_errorTextNewPassword == null && _erTextOldPass.value == null) {
      _checkOldPassword().then((confirmOldPass) {
        Navigator.of(context).pop();
        if (confirmOldPass) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ActionConfirm(confirmtrue: changepass)));
        }
      });
    }
  }

  Future<bool> _checkOldPassword() async {
    Utilities.showLoadingScreen(context);
    // Запрос на проверку старого пароля
    return Future.delayed(const Duration(seconds: 3), () {
      // _erTextOldPass.value = Utilities.curLang["OldPassMatch"];
      setState(() {});
      return true;
    });
  }

  @override
  void dispose() {
    _controllerOldPassword.dispose();
    _controllerNewPassword.dispose();
    super.dispose();
  }

  _errorTextOldPassword() {
    final text = _controllerOldPassword.value.text.toString();
    if (text != _controllerNewPassword.value.text.toString()) {
      _erTextOldPass.value = Utilities.curLang["PassMatch"];
    } else {
      _erTextOldPass.value = null;
    }
  }

  String? get _errorTextNewPassword {
    final text = _controllerNewPassword.value.text.toString();
    if (text != _controllerOldPassword.value.text.toString()) {
      return Utilities.curLang["PassMatch"];
    }
    return null;
  }

  Color _getColorErrorOldPassword() {
    return _submitter && _erTextOldPass.value != null
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
        child: Scaffold(
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
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/items/backbut.png", scale: 3),
                        const SizedBox(width: 15),
                        Text(Utilities.curLang["Back"],
                            style: GoogleFonts.inter())
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
                      child: Text(Utilities.curLang["ChangePas"],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Utilities.curLang["OldPass"],
                              style: GoogleFonts.inter(
                                  color: _getColorErrorOldPassword(),
                                  fontSize: 12),
                            ),
                            ValueListenableBuilder<String?>(
                              valueListenable: _erTextOldPass,
                              builder: (_, value, __) {
                                return Text(
                                  _submitter && value != null ? value : "",
                                  style: GoogleFonts.inter(
                                      color: const Color(0xffa72627),
                                      fontSize: 12),
                                );
                              },
                            )
                          ])),
                  ValueListenableBuilder<String?>(
                      valueListenable: _erTextOldPass,
                      builder: (_, value, __) {
                        return TextField(
                          controller: _controllerOldPassword,
                          style: TextStyle(color: _getColorErrorOldPassword()),
                          autofocus: true,
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff878789)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorText: _submitter ? value : null,
                            errorStyle: const TextStyle(fontSize: 0, height: 0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Utilities.curLang["NewPass"],
                                style: GoogleFonts.inter(
                                    color: _getColorErrorNewPassword(),
                                    fontSize: 12)),
                            Text(
                              _submitter && _errorTextNewPassword != null
                                  ? _errorTextNewPassword!
                                  : "",
                              style: GoogleFonts.inter(
                                  color: const Color(0xffa72627), fontSize: 12),
                            ),
                          ])),
                  TextField(
                    controller: _controllerNewPassword,
                    obscureText: true,
                    style: TextStyle(color: _getColorErrorNewPassword()),
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff878789)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorText: _submitter ? _errorTextNewPassword : null,
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
                        Utilities.curLang["ChangePas"],
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: height / 50),
                      ),
                      onPressed: _controllerOldPassword.value.text.isNotEmpty &&
                              _controllerNewPassword.value.text.isNotEmpty
                          ? _submit
                          : null,
                    ),
                  ),
                ],
              )),
        ));
  }
}
