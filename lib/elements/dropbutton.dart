import 'package:flutter/material.dart';
import 'package:moans/changelanguage.dart';
import 'package:moans/utils/utilities.dart';

class MyDropButton extends StatefulWidget {
  const MyDropButton({Key? key}) : super(key: key);

  @override
  State<MyDropButton> createState() {
    return MyDropButtonState();
  }
}

class MyDropButtonState extends State<MyDropButton>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeLanguage(
                        Utilities.currentLanguage, false, null)));
          },
          child: Row(
            children: [
              ValueListenableBuilder<Map>(
                  valueListenable: Utilities.curLang,
                  builder: (_, lang, __) {
                    return Text(lang["lang"],
                        style: TextStyle(
                            color: MColors.mainColor,
                            fontSize: Utilities.deviceSizeMultiply / 40));
                  }),
              const SizedBox(width: 7),
              Image.asset("assets/items/arrow.png",
                  scale: 1500 / Utilities.deviceSizeMultiply),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
