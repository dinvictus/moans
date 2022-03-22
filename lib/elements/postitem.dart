import 'package:flutter/material.dart';
import 'package:moans/changelanguage.dart';
import 'package:moans/elements/audiorecorder.dart';
import 'package:moans/elements/savetag.dart';
import 'package:google_fonts/google_fonts.dart';
import '../res.dart';

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
  bool she = true;
  bool he = true;
  bool they = true;
  bool isLoading = true;
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
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
      "name": _titleController.text,
      "description": _descController.text,
      "voice": getVoiceCode().toString(),
      "language_id": Languages.values.indexOf(curLanguage.value).toString(),
      "tags": tags
    };

    int statusCodeEdit = await Server.editTrackInfo(editTrackInfo, context);
    switch (statusCodeEdit) {
      case 200:
        // Редактирование завершено успешно
        widget.back();
        break;
      case 306:
        // У вас уже существует трек с таким именем
        break;
      case 404:
        // Ошибка подключения к серверу
        break;
      default:
        // Ошибка
        break;
    }
  }

  toDraftTrack() async {}

  postTrack() async {
    String tags = "";
    for (String tag in listTags) {
      tags += tag + " ";
    }
    int voiceCode = getVoiceCode();

    Map<String, String> uploadTrackInfo = {
      "name": _titleController.text,
      "description": _descController.text,
      "voice": voiceCode.toString(),
      "language_id": Languages.values.indexOf(curLanguage.value).toString(),
      "tag": tags
    };
    int statusCodeUpload =
        await Server.uploadTrack(uploadTrackInfo, widget.pathToFile, context);
    if (statusCodeUpload == 201) {
      // Успешно загружено
    } else {
      // Ошибка подключения к серверу
    }
  }

  changeTagsCount(int count) {
    tagsCountForSave.value = count;
  }

  ElevatedButton _getButton(Function() func, String text) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: MColors.mainColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0))),
        onPressed: func,
        child: Text(text,
            style:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)));
  }

  changeLanguage(Languages language) {
    curLanguage.value = language;
  }

  loadingTrackInfo() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Map responceInfo = await Server.getEditTrackInfo(widget.trackId, context);
      if (responceInfo["status_code"] == 200) {
        Map trackEditInfo = responceInfo["track_info"];
        _titleController.text = trackEditInfo["name"];
        _descController.text = trackEditInfo["description"];
        listTags = (trackEditInfo["tags"] as String).split(" ");
        curLanguage.value =
            Languages.values.elementAt(trackEditInfo["language_id"]);
        currentVoice =
            Voices.values.elementAt(int.parse(trackEditInfo["voice"]));
        descLength.value = _descController.text.length;
        titleLength.value = _titleController.text.length;
        tagsCountForSave.value = listTags.length;
        setState(() {
          she = (currentVoice == Voices.she ||
              currentVoice == Voices.sheHe ||
              currentVoice == Voices.sheThey);
          he = (currentVoice == Voices.he ||
              currentVoice == Voices.sheHe ||
              currentVoice == Voices.heThey);
          they = (currentVoice == Voices.they ||
              currentVoice == Voices.heThey ||
              currentVoice == Voices.sheThey);
          isLoading = false;
        });
      } else {
        // Ошибка подключения к серверу
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
          _descController.text = "";
          _titleController.text = "";
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
                              lang["Back"],
                              style: GoogleFonts.inter(),
                            )
                          ],
                        ))),
                elevation: 0,
                centerTitle: true,
                title: Text(
                  widget.trackId == -1 ? lang["Save"] : lang["Edit"],
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
                          Text(lang["SaveTitle"], style: _textStyleSave),
                          ValueListenableBuilder<int>(
                            valueListenable: titleLength,
                            builder: (_, value, __) {
                              return Text(
                                  value == 0 ? "" : value.toString() + "/30",
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
                              titleLength.value = 30;
                              _titleController.text =
                                  _titleController.text.substring(0, 30);
                              _titleController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: _titleController.text.length));
                            } else {
                              titleLength.value = value.length;
                            }
                          },
                          decoration: _inputDecoration("Track name"),
                          style: GoogleFonts.inter(color: Colors.white)),
                      SizedBox(height: height / 35),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lang["SaveDesc"], style: _textStyleSave),
                            ValueListenableBuilder<int>(
                              valueListenable: descLength,
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
                            _descController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _descController.text.length));
                            descLength.value = 150;
                          } else {
                            descLength.value = value.length;
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
                          Text(lang["SaveTags"], style: _textStyleSave),
                          ValueListenableBuilder<int>(
                            valueListenable: tagsCountForSave,
                            builder: (_, value, __) {
                              return Text(
                                  value == 0 ? "" : value.toString() + "/16",
                                  style: GoogleFonts.inter(
                                      color: value == 16
                                          ? const Color(0xffa72627)
                                          : Colors.white));
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
                              padding: const EdgeInsets.all(13),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: const BorderSide(color: Colors.white))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                curLanguage.value == Languages.english
                                    ? "English"
                                    : "Русский",
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
                        lang["SaveVoice"],
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
                          Text(lang["she/her"],
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
                          Text(lang["he/him"],
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
                          Text(lang["they/them"],
                              style: GoogleFonts.inter(color: Colors.white)),
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
                                        height: height / 13,
                                        child: _getButton(
                                            () => editTrack(), lang["Edit"])),
                                    SizedBox(
                                        width: width / 3,
                                        height: height / 13,
                                        child: _getButton(() => toDraftTrack(),
                                            lang["ToDraft"]))
                                  ],
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: height / 13,
                                  child: _getButton(
                                      () => postTrack(), lang["SavePost"])))
                    ],
                  ))));
        });
  }
}
