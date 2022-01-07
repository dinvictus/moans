import 'package:flutter/material.dart';
import 'package:moans/res.dart';
import 'feed.dart';
import 'record.dart';
import 'profile.dart';
import 'elements/helprefresher.dart';

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

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color(0xff000014),
        body: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) {
            setState(() {
              // HelpRefresh.toUpdate();
              FocusScope.of(context).unfocus();
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
            Profile(refresh),
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
            height: height / 10,
            child: BottomNavigationBar(
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xffcc80d3),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(height: 1.8),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              items: [
                BottomNavigationBarItem(
                  icon: _selectionIndex == 0
                      ? Image.asset(
                          'assets/items/feedon.png',
                          scale: 3,
                        )
                      : Image.asset(
                          'assets/items/feedoff.png',
                          scale: 3,
                        ),
                  label: Strings.curLang["Feed"],
                ),
                BottomNavigationBarItem(
                    icon: _selectionIndex == 1
                        ? Image.asset(
                            'assets/items/recordon.png',
                            scale: 3,
                          )
                        : Image.asset(
                            'assets/items/recordoff.png',
                            scale: 3,
                          ),
                    label: Strings.curLang["Record"]),
                BottomNavigationBarItem(
                    icon: _selectionIndex == 2
                        ? Image.asset(
                            'assets/items/profileon.png',
                            scale: 3,
                          )
                        : Image.asset(
                            'assets/items/profileoff.png',
                            scale: 3,
                          ),
                    label: Strings.curLang["Profile"]),
              ],
              currentIndex: _selectionIndex,
              onTap: onItemTapped,
            )));
  }
}
