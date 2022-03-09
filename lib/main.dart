import 'package:flutter/material.dart';
import 'package:moans/login.dart';
import 'package:moans/mainscreen.dart';
import 'res.dart';
import 'package:google_fonts/google_fonts.dart';
import 'elements/dropbutton.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    WidgetsFlutterBinding.ensureInitialized();
    Utilities.init();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      debugShowCheckedModeBanner: false,
      home: ConfirmAge(),
    );
  }
}

class ConfirmAge extends StatefulWidget {
  const ConfirmAge({Key? key}) : super(key: key);
  @override
  State<ConfirmAge> createState() => ConfirmAgeState();
}

class ConfirmAgeState extends State<ConfirmAge> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              backgroundColor: const Color(0xff000014),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  MyDropButton(notifyParent: refresh, updateFeed: false)
                ],
              ),
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(16, 35, 16, 16),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/back/back.png'),
                      fit: BoxFit.fill),
                ),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
                                child: Text(
                              lang["18eQuesText"],
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: height / 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Container(height: height / 25),
                          Text(
                            lang["18eText"],
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: height / 40),
                          ),
                          Container(height: height / 15),
                          SizedBox(
                            width: double.infinity,
                            height: height / 15,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MColors.mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                              ),
                              child: Text(
                                lang["18eButText"],
                                style: GoogleFonts.inter(
                                    color: Colors.white, fontSize: height / 55),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen())); // Заменить на Login
                              },
                            ),
                          ),
                          Container(height: height / 25),
                          GestureDetector(
                              onTap: () {},
                              child: Text(lang["18eTerAndCondText"],
                                  style: GoogleFonts.inter(
                                      color: MColors.mainColor,
                                      decoration: TextDecoration.underline)))
                        ],
                      ),
                    ),
                  ],
                )),
              ));
        });
  }
}
