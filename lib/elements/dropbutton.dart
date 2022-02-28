import 'package:flutter/material.dart';
import 'package:moans/changelanguage.dart';
import 'package:moans/res.dart';

class MyDropButton extends StatefulWidget {
  final Function() notifyParent;
  final bool updateFeed;
  const MyDropButton(
      {Key? key, required this.notifyParent, required this.updateFeed})
      : super(key: key);

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
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeLanguage(Strings.listLanguages,
                        widget.notifyParent, widget.updateFeed, false)));
          },
          child: Row(
            children: [
              Text(Strings.currentLanguage,
                  style: const TextStyle(color: MColors.mainColor)),
              const SizedBox(width: 7),
              Image.asset("assets/items/arrow.png", scale: 2.5),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
