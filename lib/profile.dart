import 'package:flutter/material.dart';
import 'package:moans/changepass.dart';
import 'package:moans/elements/dropbutton.dart';
import 'package:moans/elements/trackelement.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final Function() toUpdate;
  const Profile(this.toUpdate, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  bool she = true;
  bool he = true;
  bool they = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xff000014),
        appBar: AppBar(
          actions: [
            MyDropButton(notifyParent: widget.toUpdate, updateFeed: true)
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            Utilities.curLang["Profile"],
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(20, height / 7, 20, 20),
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/back/back.png'), fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Utilities.email,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: height / 25,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: height / 40),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePassword()));
                  },
                  child: Text(Utilities.curLang["ChangePas"],
                      style: GoogleFonts.inter(
                          color: MColors.mainColor,
                          fontSize: height / 45,
                          decoration: TextDecoration.underline))),
              SizedBox(height: height / 20),
              Text(Utilities.curLang["Voice"],
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: height / 35,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: height / 25),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Checkbox(
                        activeColor: Colors.transparent,
                        value: she,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            !he && !they ? null : she = value!;
                          });
                        },
                      )),
                  Text(Utilities.curLang["she/her"],
                      style: GoogleFonts.inter(color: Colors.white)),
                  const Spacer(),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Checkbox(
                        activeColor: Colors.transparent,
                        value: he,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            !she && !they ? null : he = value!;
                          });
                        },
                      )),
                  Text(Utilities.curLang["he/him"],
                      style: GoogleFonts.inter(color: Colors.white)),
                  const Spacer(),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Checkbox(
                        activeColor: Colors.transparent,
                        value: they,
                        tristate: false,
                        onChanged: (value) {
                          setState(() {
                            !he && !she ? null : they = value!;
                          });
                        },
                      )),
                  Text(Utilities.curLang["they/them"],
                      style: GoogleFonts.inter(color: Colors.white)),
                ],
              ),
              SizedBox(height: height / 12),
              Text(Utilities.curLang["MyRec"],
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: height / 25,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: height / 30),
              const Expanded(child: TrackElement()),
            ],
          ),
        ));
  }
}
