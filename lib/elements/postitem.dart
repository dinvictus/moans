import 'package:flutter/material.dart';
import 'package:moans/changelanguage.dart';
import 'package:moans/elements/audiorecorder.dart';
import 'package:moans/elements/savetag.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/utils/server.dart';
import 'package:moans/utils/utilities.dart';

class PostItem extends StatefulWidget {
  final Function() back;
  final int trackId;
  final String pathToFile;
  const PostItem(this.back, this.trackId, this.pathToFile, {Key? key})
      : super(key: key);

  @override
  State<PostItem> createState() {
    return _PostItemState();
  }
}

class _PostItemState extends State<PostItem> {
  ValueNotifier<int> tagsCountForSave = ValueNotifier(0);
  ValueNotifier<int> descLength = ValueNotifier(0);
  ValueNotifier<int> titleLength = ValueNotifier(0);
  ValueNotifier<Languages> curLanguage =
      ValueNotifier<Languages>(Utilities.currentLanguage);
  late Voices currentVoice;
  late final List<String> listTags;
  Statuses curStatus = Statuses.publish;
  bool she = true;
  bool he = true;
  bool they = true;
  bool isLoading = true;
  final TextEditingController descController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextStyle textStyleSave = GoogleFonts.inter(
      color: const Color(0xffcfcfd0),
      fontSize: Utilities.deviceSizeMultiply / 41);
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff878789), width: 2),
        ),
        hintText: hint,
        hintStyle: textStyleSave);
  }

  int getVoiceCode() {
    return ((she ? 1 : 0) * 1 +
        (he ? 1 : 0) * 2 +
        (they ? 1 : 0) * 3 +
        ((she ^ he ^ they) && !(she && he && they) ? 0 : 1) -
        1);
  }

  editTrack() async {
    String tags = "";
    for (String tag in listTags) {
      tags += tag + " ";
    }
    Map<String, String> editTrackInfo = {
      "id": widget.trackId.toString(),
      "name": titleController.text,
      "description": descController.text,
      "voice": getVoiceCode().toString(),
      "language_id": Languages.values.indexOf(curLanguage.value).toString(),
      "tags": tags
    };

    int statusCodeEdit = await Server.editTrackInfo(editTrackInfo, context);
    switch (statusCodeEdit) {
      case 200:
        Utilities.showToast(Utilities.curLang.value["ToastEditTrack"]);
        widget.back();
        break;
      case 306:
        Utilities.showToast(Utilities.curLang.value["AlreadyHaveTitle"]);
        break;
      case 404:
        Utilities.showToast(Utilities.curLang.value["ServerError"]);
        break;
      default:
        Utilities.showToast(Utilities.curLang.value["Error"]);
        break;
    }
  }

  toPublishTrack() async {
    int statusCodeToDraft = await Server.changeTrackStatus(
        widget.trackId, Statuses.publish, context);
    if (statusCodeToDraft == 200) {
      Utilities.showToast(Utilities.curLang.value["ToastPostTrack"]);
      widget.back();
    } else {
      Utilities.showToast(Utilities.curLang.value["ServerError"]);
    }
  }

  toDraftTrack() async {
    int statusCodeToDraft =
        await Server.changeTrackStatus(widget.trackId, Statuses.draft, context);
    if (statusCodeToDraft == 200) {
      Utilities.showToast(Utilities.curLang.value["ToastDraftTrack"]);
      widget.back();
    } else {
      Utilities.showToast(Utilities.curLang.value["ServerError"]);
    }
  }

  postTrack() async {
    String tags = "";
    for (String tag in listTags) {
      tags += tag + " ";
    }
    int voiceCode = getVoiceCode();

    Map<String, String> uploadTrackInfo = {
      "name": titleController.text,
      "description": descController.text,
      "voice": voiceCode.toString(),
      "language_id": Languages.values.indexOf(curLanguage.value).toString(),
      "tag": tags
    };
    int statusCodeUpload =
        await Server.uploadTrack(uploadTrackInfo, widget.pathToFile, context);
    switch (statusCodeUpload) {
      case 201:
        Utilities.showToast(Utilities.curLang.value["ToastPostTrack"]);
        FocusManager.instance.primaryFocus?.unfocus();
        pageAudioRecordNotifier.value = AudioRecordState.main;
        break;
      case 306:
        Utilities.showToast(Utilities.curLang.value["AlreadyHaveTitle"]);
        break;
      case 404:
        Utilities.showToast(Utilities.curLang.value["ServerError"]);
        break;
      default:
        Utilities.showToast(Utilities.curLang.value["Error"]);
    }
  }

  changeTagsCount(int count) {
    tagsCountForSave.value = count;
    setState(() {});
  }

  bool getTrueInfo() {
    return titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        listTags.isNotEmpty;
  }

  ElevatedButton getButton(Function() func, String text) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            onSurface: Colors.white,
            primary: MColors.mainColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0))),
        onPressed: func == toDraftTrack ? func : (getTrueInfo() ? func : null),
        child: FittedBox(
            child: Text(text,
                style: GoogleFonts.inter(
                    fontSize: Utilities.deviceSizeMultiply / 35,
                    fontWeight: FontWeight.w500))));
  }

  changeLanguage(Languages language) {
    setState(() {
      curLanguage.value = language;
    });
  }

  loadingTrackInfo() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Map responceInfo = await Server.getEditTrackInfo(widget.trackId, context);
      if (responceInfo["status_code"] == 200) {
        Map trackEditInfo = responceInfo["track_info"];
        titleController.text = trackEditInfo["name"];
        descController.text = trackEditInfo["description"];
        listTags = (trackEditInfo["tags"] as String).split(" ");
        curLanguage.value =
            Languages.values.elementAt(trackEditInfo["language_id"]);
        currentVoice =
            Voices.values.elementAt(int.parse(trackEditInfo["voice"]));
        curStatus =
            Statuses.values.elementAt(int.parse(trackEditInfo["status"]));
        descLength.value = descController.text.length;
        titleLength.value = titleController.text.length;
        tagsCountForSave.value = listTags.length;
        setState(() {
          she = (currentVoice == Voices.she ||
              currentVoice == Voices.sheHe ||
              currentVoice == Voices.sheThey ||
              currentVoice == Voices.sheHeThey);
          he = (currentVoice == Voices.he ||
              currentVoice == Voices.sheHe ||
              currentVoice == Voices.heThey ||
              currentVoice == Voices.sheHeThey);
          they = (currentVoice == Voices.they ||
              currentVoice == Voices.heThey ||
              currentVoice == Voices.sheThey ||
              currentVoice == Voices.sheHeThey);
          isLoading = false;
        });
      } else {
        Utilities.showToast(Utilities.curLang.value["ServerError"]);
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.trackId != -1) {
      loadingTrackInfo();
    } else {
      listTags = [];
      isLoading = false;
      pageAudioRecordNotifier.addListener(() {
        if (pageAudioRecordNotifier.value == AudioRecordState.main) {
          descController.text = "";
          titleController.text = "";
          tagsCountForSave.value = 0;
          descLength.value = 0;
          titleLength.value = 0;
          curLanguage.value = Languages.english;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder<Map>(
        valueListenable: Utilities.curLang,
        builder: (_, lang, __) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: const Color(0xff000014),
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
                            Image.asset("assets/items/backbut.png",
                                scale: 1800 / Utilities.deviceSizeMultiply),
                            SizedBox(
                              width: width / 30,
                            ),
                            Text(
                              lang["Back"],
                              style: GoogleFonts.inter(
                                  fontSize: Utilities.deviceSizeMultiply / 40),
                            )
                          ],
                        ))),
                elevation: 0,
                centerTitle: true,
                title: Text(
                  widget.trackId == -1 ? lang["Save"] : lang["Edit"],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: Utilities.deviceSizeMultiply / 30),
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
                          Text(lang["SaveTitle"], style: textStyleSave),
                          ValueListenableBuilder<int>(
                            valueListenable: titleLength,
                            builder: (_, value, __) {
                              return Text(
                                  value == 0 ? "" : value.toString() + "/30",
                                  style: GoogleFonts.inter(
                                      color: value >= 30
                                          ? const Color(0xffa72627)
                                          : Colors.white,
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 43));
                            },
                          )
                        ],
                      ),
                      TextField(
                          controller: titleController,
                          onChanged: (value) {
                            setState(() {});
                            if (value.length >= 31) {
                              titleLength.value = 30;
                              titleController.text =
                                  titleController.text.substring(0, 30);
                              titleController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: titleController.text.length));
                            } else {
                              titleLength.value = value.length;
                            }
                          },
                          decoration: inputDecoration(lang["TrackName"]),
                          style: GoogleFonts.inter(color: Colors.white)),
                      SizedBox(height: height / 35),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang["SaveDesc"], style: textStyleSave),
                            ValueListenableBuilder<int>(
                              valueListenable: descLength,
                              builder: (_, value, __) {
                                return Text(
                                  value == 0 ? "" : value.toString() + "/150",
                                  style: GoogleFonts.inter(
                                      color: value >= 150
                                          ? const Color(0xffa72627)
                                          : Colors.white,
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 43),
                                );
                              },
                            )
                          ]),
                      TextField(
                        controller: descController,
                        onChanged: (value) {
                          setState(() {});
                          if (value.length >= 151) {
                            descController.text =
                                descController.text.substring(0, 150);
                            descController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: descController.text.length));
                            descLength.value = 150;
                          } else {
                            descLength.value = value.length;
                          }
                        },
                        decoration: inputDecoration(""),
                        minLines: 4,
                        maxLines: 4,
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      SizedBox(height: height / 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lang["SaveTags"], style: textStyleSave),
                          ValueListenableBuilder<int>(
                            valueListenable: tagsCountForSave,
                            builder: (_, value, __) {
                              return Text(
                                  value == 0 ? "" : value.toString() + "/16",
                                  style: GoogleFonts.inter(
                                      color: value == 16
                                          ? const Color(0xffa72627)
                                          : Colors.white,
                                      fontSize:
                                          Utilities.deviceSizeMultiply / 43));
                            },
                          )
                        ],
                      ),
                      isLoading
                          ? const TextField(enabled: false)
                          : SaveTag(
                              listTagsString: listTags,
                              changeTagsCount: changeTagsCount),
                      SizedBox(height: height / 30),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangeLanguage(
                                        curLanguage.value,
                                        true,
                                        changeLanguage)));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.all(
                                  Utilities.deviceSizeMultiply / 45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: const BorderSide(color: Colors.white))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                curLanguage.value == Languages.english
                                    ? "English"
                                    : "Русский",
                                style: textStyleSave,
                              ),
                              Image.asset(
                                "assets/items/arrowright.png",
                                scale: 1000 / Utilities.deviceSizeMultiply,
                              ),
                            ],
                          )),
                      SizedBox(height: height / 30),
                      Text(
                        lang["SaveVoice"],
                        style: textStyleSave,
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
                          Text(lang["she/her"],
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  textStyle: textStyleSave)),
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
                          Text(lang["he/him"],
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  textStyle: textStyleSave)),
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
                          Text(lang["they/them"],
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  textStyle: textStyleSave)),
                        ],
                      ),
                      SizedBox(height: height / 25),
                      Container(
                          alignment: Alignment.center,
                          height: height / 13,
                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          width: double.infinity,
                          child: widget.trackId != -1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                        width: width / 3,
                                        height: height / 16,
                                        child: getButton(
                                            () => editTrack(), lang["Edit"])),
                                    SizedBox(
                                        width: width / 3,
                                        height: height / 16,
                                        child: curStatus == Statuses.publish
                                            ? getButton(() => toDraftTrack(),
                                                lang["ToDraft"])
                                            : getButton(() => toPublishTrack(),
                                                lang["SavePost"]))
                                  ],
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: height / 16,
                                  child: getButton(
                                      () => postTrack(), lang["SavePost"]))),
                      SizedBox(height: height / 10)
                    ],
                  ))));
        });
  }
}
