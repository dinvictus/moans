import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/utils/utilities.dart';

class ActionConfirm extends StatelessWidget {
  final Function() confirmtrue;
  const ActionConfirm({Key? key, required this.confirmtrue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xff0f0f14),
        body: ValueListenableBuilder<Map>(
            valueListenable: Utilities.curLang,
            builder: (_, lang, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(lang["Shure"],
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Utilities.deviceSizeMultiply / 15)),
                  SizedBox(
                    height: height / 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: width / 3,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(
                                      0,
                                      Utilities.deviceSizeMultiply / 40,
                                      0,
                                      Utilities.deviceSizeMultiply / 40),
                                  primary: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.lerp(
                                          const BorderSide(
                                              width: 1,
                                              color: MColors.mainColor),
                                          const BorderSide(
                                              width: 1,
                                              color: MColors.mainColor),
                                          2),
                                      borderRadius:
                                          BorderRadius.circular(50.0))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                lang["No"],
                                style: GoogleFonts.inter(
                                    color: MColors.mainColor,
                                    fontSize:
                                        Utilities.deviceSizeMultiply / 30),
                              ))),
                      SizedBox(
                          width: width / 3,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(
                                    0,
                                    Utilities.deviceSizeMultiply / 40,
                                    0,
                                    Utilities.deviceSizeMultiply / 40),
                                primary: MColors.mainColor,
                                onSurface: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                confirmtrue();
                              },
                              child: Text(lang["Yes"],
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 30)))),
                    ],
                  )
                ],
              );
            }));
  }
}
