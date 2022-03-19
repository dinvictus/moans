import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/elements/audiorecorder.dart';
import 'package:moans/elements/savetagitem.dart';

class SaveTag extends StatefulWidget {
  final List<String> listTagsString;
  final Function(int count) changeTagsCount;
  const SaveTag(
      {required this.listTagsString, required this.changeTagsCount, Key? key})
      : super(key: key);
  @override
  State<SaveTag> createState() {
    return _SaveTagState();
  }
}

class _SaveTagState extends State<SaveTag> {
  final List<Widget> listTags = [];
  // final List<String> _listTagsString = [];
  final scrollController = ScrollController();
  final tagController = TextEditingController();

  loadingTags() {
    for (String tag in widget.listTagsString) {
      listTags.add(SaveTagItem(tag, _delTagItem));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.listTagsString.isNotEmpty) {
      loadingTags();
    }
    pageAudioRecordNotifier.addListener(() {
      if (pageAudioRecordNotifier.value == AudioRecordState.main) {
        if (mounted) {
          setState(() {
            tagController.clear();
            listTags.clear();
            widget.listTagsString.clear();
          });
        }
      }
    });
  }

  _delTagItem(text) {
    setState(() {
      for (int i = 0; i < widget.listTagsString.length; i++) {
        if (widget.listTagsString[i] == text) {
          widget.listTagsString.removeAt(i);
          listTags.removeAt(i);
          widget.changeTagsCount(listTags.length);
        }
      }
    });
  }

  _animate() {
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        if (listTags.length >= 2) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        }
      });
    });
  }

  _textChanged(String text) {
    if (listTags.length >= 16) {
      tagController.text = "";
    }
    if (tagController.text.length >= 25) {
      tagController.text = tagController.text.substring(0, 24);
      tagController.selection = TextSelection.fromPosition(
          TextPosition(offset: tagController.text.length));
    }
    if (text.isNotEmpty && text.substring(text.length - 1) == " ") {
      String temp = text.trim().replaceAll(" ", "");
      setState(() {
        if (temp != "") {
          listTags.add(SaveTagItem(temp, _delTagItem));
          widget.listTagsString.add(temp);
          widget.changeTagsCount(listTags.length);
          _animate();
        }
        tagController.text = text.substring(temp.length + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return TextField(
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xff878789))),
            prefixIcon: listTags.isNotEmpty
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 0.725 * width),
                    child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: listTags)))
                : null),
        controller: tagController,
        onChanged: _textChanged);
  }
}
