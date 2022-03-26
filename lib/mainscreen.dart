import 'package:flutter/material.dart';
import 'package:moans/res.dart';
import 'feed.dart';
import 'record.dart';
import 'profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

int _selectionIndex = 0;

class MainScreenState extends State<MainScreen> {
  PageController controller = PageController();
  void onItemTapped(int index) {
    setState(() {
      _selectionIndex = index;
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 250), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    double iconBottomBarSize = Utilities.deviceSizeMultiply / 20;
    precacheImage(const AssetImage("assets/items/recordon.png"), context);
    precacheImage(const AssetImage("assets/items/profileon.png"), context);
    precacheImage(const AssetImage("assets/items/feedoff.png"), context);
    return Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xff000014),
        body: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) {
            setState(() {
              FocusManager.instance.primaryFocus?.unfocus();
              if (value == 0) {
                _selectionIndex = 0;
              }
              if (value == 1) {
                _selectionIndex = 1;
              }
              if (value == 2) {
                _selectionIndex = 2;
              }
            });
          },
          children: [
            Feed(),
            Record(),
            Profile(),
          ],
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: MColors.mainColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 10)
                ]),
            height: Utilities.deviceSizeMultiply / 8.5,
            child: ValueListenableBuilder<Map>(
                valueListenable: Utilities.curLang,
                builder: (_, lang, __) {
                  return BottomNavigationBar(
                    selectedItemColor: Colors.white,
                    unselectedItemColor: const Color(0xffcc80d3),
                    selectedFontSize: Utilities.deviceSizeMultiply / 45,
                    unselectedFontSize: Utilities.deviceSizeMultiply / 45,
                    selectedLabelStyle: const TextStyle(height: 1.8),
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    items: [
                      BottomNavigationBarItem(
                        icon: _selectionIndex == 0
                            ? Image(
                                image:
                                    const AssetImage("assets/items/feedon.png"),
                                height: iconBottomBarSize,
                                width: iconBottomBarSize)
                            : Image(
                                image: const AssetImage(
                                    "assets/items/feedoff.png"),
                                height: iconBottomBarSize,
                                width: iconBottomBarSize),
                        label: lang["Feed"],
                      ),
                      BottomNavigationBarItem(
                          icon: _selectionIndex == 1
                              ? Image(
                                  image: const AssetImage(
                                      "assets/items/recordon.png"),
                                  height: iconBottomBarSize,
                                  width: iconBottomBarSize)
                              : Image(
                                  image: const AssetImage(
                                      "assets/items/recordoff.png"),
                                  height: iconBottomBarSize,
                                  width: iconBottomBarSize),
                          label: lang["Record"]),
                      BottomNavigationBarItem(
                          icon: _selectionIndex == 2
                              ? Image(
                                  image: const AssetImage(
                                      "assets/items/profileon.png"),
                                  height: iconBottomBarSize,
                                  width: iconBottomBarSize)
                              : Image(
                                  image: const AssetImage(
                                      "assets/items/profileoff.png"),
                                  height: iconBottomBarSize,
                                  width: iconBottomBarSize),
                          label: lang["Profile"]),
                    ],
                    currentIndex: _selectionIndex,
                    onTap: onItemTapped,
                  );
                })));
  }
}
