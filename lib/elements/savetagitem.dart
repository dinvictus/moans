import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../res.dart';

class SaveTagItem extends StatelessWidget {
  final String text;
  final ValueChanged<String> onDeleted;
  const SaveTagItem(this.text, this.onDeleted, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MColors.mainColor)),
            child: Row(children: [
              Text(text,
                  style: GoogleFonts.inter(
                      color: MColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Utilities.deviceSizeMultiply / 42)),
              Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: Utilities.deviceSizeMultiply / 30,
                  width: Utilities.deviceSizeMultiply / 30,
                  child: IconButton(
                      padding: const EdgeInsets.all(5),
                      splashRadius: 0.01,
                      onPressed: () {
                        onDeleted(text);
                      },
                      icon: Image.asset(
                        "assets/items/cross.png",
                      )))
            ])));
  }
}
