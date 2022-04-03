import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:moans/utils/utilities.dart';

class AppBarLeading extends StatelessWidget {
  final Function? back;
  const AppBarLeading({Key? key, required this.back}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(0),
                primary: Colors.transparent),
            onPressed: () {
              if (back != null) {
                back!();
              } else {
                Navigator.pop(context);
              }
            },
            child: Row(
              children: [
                Image.asset("assets/items/backbut.png",
                    scale: 1800 / Utilities.deviceSizeMultiply),
                SizedBox(
                  width: width / 30,
                ),
                ValueListenableBuilder<Map>(
                    valueListenable: Utilities.curLang,
                    builder: (_, lang, __) {
                      return Text(
                        lang["Back"],
                        style: GoogleFonts.inter(
                            fontSize: Utilities.deviceSizeMultiply / 40),
                      );
                    })
              ],
            )));
  }
}
