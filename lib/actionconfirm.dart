import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/res.dart';

class ActionConfirm extends StatelessWidget {
  final Function() confirmtrue;
  const ActionConfirm({Key? key, required this.confirmtrue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff0f0f14),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Utilities.curLang["Shure"],
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35)),
          SizedBox(
            height: height / 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              side: BorderSide.lerp(
                                  const BorderSide(
                                      width: 1, color: MColors.mainColor),
                                  const BorderSide(
                                      width: 1, color: MColors.mainColor),
                                  2),
                              borderRadius: BorderRadius.circular(50.0))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        Utilities.curLang["No"],
                        style: GoogleFonts.inter(
                            color: MColors.mainColor, fontSize: 16),
                      ))),
              SizedBox(
                  width: 120,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        primary: MColors.mainColor,
                        onSurface: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        confirmtrue();
                      },
                      child: Text(Utilities.curLang["Yes"],
                          style: GoogleFonts.inter(fontSize: 16)))),
            ],
          )
        ],
      ),
    );
  }
}
