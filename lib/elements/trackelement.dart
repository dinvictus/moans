import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/elements/postitem.dart';
import 'package:moans/utils/utilities.dart';

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
    return TrackElementState();
  }
}

class TrackElementState extends State<TrackElement> {
  final List<Widget> _listTracks = [];
  late double _width;
  late double _height;

  _back() {
    Navigator.pop(context);
    widget.toUpdate();
  }

  update() {
    _listTracks.clear();
    for (int i = 0; i < widget.trackNames.length; i++) {
      _listTracks.add(_trackElement(
          widget.trackNames[i],
          widget.trackLikes[i],
          widget.trackIds[i],
          Statuses.values.elementAt(widget.trackStatuses[i])));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;
      update();
    });
  }

  Widget _trackElement(
      String trackName, String trackLike, int trackId, Statuses trackStatus) {
    Widget? imageStatus;
    switch (trackStatus) {
      case Statuses.draft:
        imageStatus = Image.asset("assets/items/doc.png",
            scale: 1400 / Utilities.deviceSizeMultiply);
        break;
      case Statuses.publish:
        imageStatus = Image.asset("assets/items/ok.png",
            scale: 1000 / Utilities.deviceSizeMultiply);
        break;
      case Statuses.banned:
        //  Handle this case.
        break;
      case Statuses.deleted:
        //  Handle this case.
        break;
    }
    Widget trackElement = Container(
      margin: EdgeInsets.only(bottom: _height / 70),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xff4b4b4f)))),
      height: _height / 15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: _width / 2.3,
            child: Text(trackName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: Utilities.deviceSizeMultiply / 25)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 5),
                  child: imageStatus),
              Container(
                padding: const EdgeInsets.all(3),
                child: Image.asset("assets/items/likeoff.png",
                    scale: 3000 / Utilities.deviceSizeMultiply),
              ),
              const SizedBox(width: 2),
              Container(
                  padding: const EdgeInsets.only(bottom: 3),
                  width: _width / 12,
                  margin: EdgeInsets.only(right: _width / 15),
                  child: Text(trackLike,
                      style: GoogleFonts.inter(color: Colors.white))),
              Container(
                  margin: EdgeInsets.only(bottom: _height / 60),
                  width: Utilities.deviceSizeMultiply / 20,
                  height: Utilities.deviceSizeMultiply / 20,
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
                                  PostItem(_back, trackId, "")));
                    },
                    child: Image.asset("assets/items/edit.png"),
                  )),
              SizedBox(width: _width / 20)
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
        : Column(children: _listTracks);
  }
}
