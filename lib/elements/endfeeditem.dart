import 'package:flutter/material.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class EndFeedItem extends StatelessWidget {
  final Function() toRefreshFeed;
  const EndFeedItem(this.toRefreshFeed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder<Map>(
            valueListenable: Utilities.curLang,
            builder: (_, lang, __) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lang["EndFeed"],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: Utilities.deviceSizeMultiply / 25,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: height / 15),
                    SizedBox(
                        height: height / 16,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: MColors.mainColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0))),
                          child: Text(lang["Refresh"],
                              style: GoogleFonts.inter(
                                  fontSize: Utilities.deviceSizeMultiply / 30)),
                          onPressed: () => toRefreshFeed(),
                        ))
                  ]);
            }));
  }
}
