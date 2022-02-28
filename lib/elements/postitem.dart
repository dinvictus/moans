import 'package:flutter/material.dart';
import 'package:moans/changelanguage.dart';
import 'package:moans/elements/audiorecorder.dart';
import 'package:moans/elements/savetag.dart';
import 'package:google_fonts/google_fonts.dart';
import '../res.dart';

class PostItem extends StatefulWidget {
  final Function() back;
  const PostItem(this.back, {Key? key}) : super(key: key);

  @override
  State<PostItem> createState() {
    return PostItemState();
  }
}

class PostItemState extends State<PostItem> {
  bool she = true;
  bool he = true;
  bool they = true;
  late final TextEditingController _descController;
  late final TextEditingController _titleController;
  final TextStyle _textStyleSave =
      GoogleFonts.inter(color: const Color(0xffcfcfd0));
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff878789), width: 2),
        ),
        hintText: hint,
        hintStyle: _textStyleSave);
  }

  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController();
    _titleController = TextEditingController();
    pageAudioRecordNotifier.addListener(() {
      if (pageAudioRecordNotifier.value == AudioRecordState.main) {
        _descController.text = "";
        _titleController.text = "";
      }
    });
  }

  @override
  void dispose() {
    // _descController.dispose();
    // _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leadingWidth: 100,
          leading: Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      primary: Colors.transparent),
                  onPressed: widget.back,
                  child: Row(
                    children: [
                      Image.asset("assets/items/backbut.png", scale: 3),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        Strings.curLang["Back"],
                        style: GoogleFonts.inter(),
                      )
                    ],
                  ))),
          elevation: 0,
          centerTitle: true,
          title: Text(
            Strings.curLang["Save"],
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(10, height / 8, 10, 0),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Strings.curLang["SaveTitle"], style: _textStyleSave),
                    ValueListenableBuilder<int>(
                      valueListenable: Strings.titleLength,
                      builder: (_, value, __) {
                        return Text(value == 0 ? "" : value.toString() + "/30",
                            style: GoogleFonts.inter(
                                color: value >= 30
                                    ? const Color(0xffa72627)
                                    : Colors.white));
                      },
                    )
                  ],
                ),
                TextField(
                    controller: _titleController,
                    onChanged: (value) {
                      if (value.length >= 31) {
                        Strings.titleLength.value = 30;
                        _titleController.text =
                            _titleController.text.substring(0, 30);
                        _titleController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _titleController.text.length));
                      } else {
                        Strings.titleLength.value = value.length;
                      }
                    },
                    decoration: _inputDecoration("Track name"),
                    style: GoogleFonts.inter(color: Colors.white)),
                SizedBox(height: height / 35),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Strings.curLang["SaveDesc"], style: _textStyleSave),
                      ValueListenableBuilder<int>(
                        valueListenable: Strings.descLength,
                        builder: (_, value, __) {
                          return Text(
                            value == 0 ? "" : value.toString() + "/150",
                            style: GoogleFonts.inter(
                                color: value >= 150
                                    ? const Color(0xffa72627)
                                    : Colors.white),
                          );
                        },
                      )
                    ]),
                TextField(
                  controller: _descController,
                  onChanged: (value) {
                    if (value.length >= 151) {
                      _descController.text =
                          _descController.text.substring(0, 150);
                      _descController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _descController.text.length));
                      Strings.descLength.value = 150;
                    } else {
                      Strings.descLength.value = value.length;
                    }
                  },
                  decoration: _inputDecoration(""),
                  minLines: 4,
                  maxLines: 4,
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                SizedBox(height: height / 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Strings.curLang["SaveTags"], style: _textStyleSave),
                    ValueListenableBuilder<int>(
                      valueListenable: Strings.tagsCountForSave,
                      builder: (_, value, __) {
                        return Text(value == 0 ? "" : value.toString() + "/16",
                            style: GoogleFonts.inter(
                                color: value == 16
                                    ? const Color(0xffa72627)
                                    : Colors.white));
                      },
                    )
                  ],
                ),
                const SaveTag(),
                SizedBox(height: height / 30),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeLanguage(
                                  Strings.listLanguages,
                                  refresh,
                                  false,
                                  true)));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.all(13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: const BorderSide(color: Colors.white))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.langForSaveTrack,
                          style: _textStyleSave,
                        ),
                        Image.asset(
                          "assets/items/arrowright.png",
                          scale: 2,
                        ),
                      ],
                    )),
                SizedBox(height: height / 30),
                Text(
                  Strings.curLang["SaveVoice"],
                  style: _textStyleSave,
                ),
                SizedBox(height: height / 40),
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
                    Text(Strings.curLang["she/her"],
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
                    Text(Strings.curLang["he/him"],
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
                    Text(Strings.curLang["they/them"],
                        style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
                SizedBox(height: height / 25),
                Container(
                    height: height / 13,
                    margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: MColors.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0))),
                        onPressed: () {},
                        child: Text(Strings.curLang["SavePost"],
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500))))
              ],
            ))));
  }
}
