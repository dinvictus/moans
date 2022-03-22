import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/elements/postitem.dart';
import 'package:moans/res.dart';

class TrackElement extends StatefulWidget {
  final List<String> trackNames;
  final List<String> trackLikes;
  final List<int> trackIds;
  final List<int> trackStatuses;
  final Function() toUpdate;
  const TrackElement(
      {required this.trackNames,
      required this.trackLikes,
      required this.trackIds,
      required this.trackStatuses,
      required this.toUpdate,
      Key? key})
      : super(key: key);

  @override
  State<TrackElement> createState() {
    return _TrackElementState();
  }
}

class _TrackElementState extends State<TrackElement> {
  final List<Widget> listTracks = [];
  late double width;

  back() {
    Navigator.pop(context);
    widget.toUpdate();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      width = MediaQuery.of(context).size.width;
      for (int i = 0; i < widget.trackNames.length; i++) {
        listTracks.add(_trackElement(
            widget.trackNames[i],
            widget.trackLikes[i],
            widget.trackIds[i],
            Statuses.values.elementAt(widget.trackStatuses[i])));
      }
      setState(() {});
    });
  }

  Widget _trackElement(
      String trackName, String trackLike, int trackId, Statuses trackStatus) {
    Widget? imageStatus;
    switch (trackStatus) {
      case Statuses.draft:
        imageStatus = Image.asset("assets/items/doc.png");
        break;
      case Statuses.publish:
        imageStatus = Image.asset("assets/items/ok.png");
        break;
      case Statuses.banned:
        // TODO: Handle this case.
        break;
      case Statuses.deleted:
        // TODO: Handle this case.
        break;
    }
    Widget trackElement = Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xff4b4b4f)))),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: width / 2.2,
            child: Text(trackName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20)),
          ),
          Row(
            children: [
              Container(
                  height: 30,
                  padding: const EdgeInsets.all(9),
                  margin: const EdgeInsets.only(right: 5),
                  child: imageStatus),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostItem(back, trackId, "")));
                    },
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
    return widget.trackNames.isEmpty
        ? ValueListenableBuilder<Map>(
            valueListenable: Utilities.curLang,
            builder: (_, lang, __) {
              return Text(lang["NoTracks"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white));
            })
        : Column(children: listTracks);
  }
}
