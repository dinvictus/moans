import 'package:flutter/material.dart';
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
  bool _submitter = false;

  Future<void> _submit() async {
    setState(() {
      _submitter = true;
    });
  }

  @override
  void dispose() {
    _controllerOldPassword.dispose();
    _controllerNewPassword.dispose();
    super.dispose();
  }

  String? get _errorTextOldPassword {
    final text = _controllerOldPassword.value.text.toString();
    if (text.length <= 8) {
      return Utilities.curLang["ShortPass"];
    }
    return null;
  }

  String? get _errorTextNewPassword {
    final text = _controllerNewPassword.value.text.toString();
    if (text.length <= 8) {
      return Utilities.curLang["ShortPass"];
    }
    return null;
  }

  Color _getColorErrorOldPassword() {
    return _submitter && _errorTextOldPassword != null
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
    return Scaffold(
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
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/back/back.png'), fit: BoxFit.fill)),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
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
                            Text(
                              _submitter && _errorTextOldPassword != null
                                  ? _errorTextOldPassword!
                                  : "",
                              style: GoogleFonts.inter(
                                  color: const Color(0xffa72627), fontSize: 12),
                            ),
                          ])),
                  TextField(
                    controller: _controllerOldPassword,
                    style: TextStyle(color: _getColorErrorOldPassword()),
                    autofocus: true,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff878789)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorText: _submitter ? _errorTextOldPassword : null,
                      errorStyle: const TextStyle(fontSize: 0, height: 0),
                    ),
                    onChanged: (_) => setState(() {
                      _submitter = false;
                    }),
                  ),
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
