import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackElement extends StatefulWidget {
  const TrackElement({Key? key}) : super(key: key);

  @override
  State<TrackElement> createState() {
    return TrackElementState();
  }
}

class TrackElementState extends State<TrackElement> {
  late List<String> trackNames;
  late List<String> trackLikes;

  @override
  void initState() {
    super.initState();
    trackNames = ["Track 1", "Track 2", "Track 3", "Track 4", "Track 5"];
    trackLikes = ["45k", "345", "1k", "4k", "115k"];
  }

  Widget _trackElement(String trackName, String trackLike) {
    Widget trackElement = Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xff4b4b4f)))),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(trackName,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400)),
          Row(
            children: [
              Container(
                  height: 30,
                  padding: const EdgeInsets.all(9),
                  margin: const EdgeInsets.only(right: 5),
                  child: Image.asset("assets/items/ok.png")),
              Container(
                width: 20,
                padding: const EdgeInsets.all(3),
                child: Image.asset("assets/items/likeoff.png"),
              ),
              Container(
                  width: 30,
                  margin: const EdgeInsets.only(right: 30),
                  child: Text(trackLike,
                      style: GoogleFonts.inter(color: Colors.white))),
              SizedBox(
                  width: 25,
                  height: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.all(0)),
                    onPressed: () {},
                    child: Image.asset("assets/items/edit.png"),
                  )),
            ],
          )
        ],
      ),
    );

    return trackElement;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      scrollDirection: Axis.vertical,
      itemCount: trackNames.length,
      itemBuilder: (context, index) {
        return _trackElement(trackNames[index], trackLikes[index]);
      },
    );
  }
}
