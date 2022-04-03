import 'package:flutter/material.dart';
import 'package:moans/elements/appbarleading.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  final Function() back;

  const ForgotPassword({Key? key, required this.back}) : super(key: key);
  @override
  State<ForgotPassword> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool submitter = false;

  final TextEditingController controllerEmail = TextEditingController();

  Color getColorErrorEmail() {
    return submitter && errorEmailText != null
        ? const Color(0xffa72627)
        : Colors.white;
  }

  String? get errorEmailText {
    final text = controllerEmail.value.text.toString();
    if (!text.contains("@") ||
        !text.contains(".") ||
        text.indexOf("@") == 0 ||
        text.indexOf(".") == text.length - 1) {
      return Utilities.curLang.value["EmailNotCorrect"];
    }
    return null;
  }

  submit() {
    setState(() {
      submitter = true;
    });
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
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leadingWidth: 100,
                leading: const AppBarLeading(back: null),
                automaticallyImplyLeading: false),
            body: Container(
                margin: EdgeInsets.only(top: height / 10),
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: ValueListenableBuilder<Map>(
                    valueListenable: Utilities.curLang,
                    builder: (_, lang, __) {
                      return SingleChildScrollView(
                          physics: MediaQuery.of(context).viewInsets.bottom == 0
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                    child: Text(lang["ForgotPassTitle"],
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize:
                                                Utilities.deviceSizeMultiply /
                                                    18,
                                            fontWeight: FontWeight.bold)))),
                            SizedBox(height: height / 18),
                            Text(lang["ForgotPassText"],
                                style: GoogleFonts.inter(
                                    color: const Color(0xffcfcfd0),
                                    fontSize:
                                        Utilities.deviceSizeMultiply / 30)),
                            SizedBox(height: height / 18),
                            Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(lang["Email"],
                                          style: GoogleFonts.inter(
                                              color: getColorErrorEmail(),
                                              fontSize:
                                                  Utilities.deviceSizeMultiply /
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
                                    })),
                            SizedBox(height: height / 12),
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
                                  lang["SendEmail"],
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 34),
                                ),
                                onPressed: controllerEmail.value.text.isNotEmpty
                                    ? submit
                                    : null,
                              ),
                            ),
                          ]));
                    }))));
  }
}
