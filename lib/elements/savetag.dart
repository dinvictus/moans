import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/elements/audiorecorder.dart';
import 'package:moans/elements/savetagitem.dart';
import 'package:moans/res.dart';

class SaveTag extends StatefulWidget {
  const SaveTag({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SaveTagState();
  }
}

class SaveTagState extends State<SaveTag> {
  final List<Widget> _listTags = [];
  final List<String> _listTagsString = [];
  final _scrollController = ScrollController();
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageAudioRecordNotifier.addListener(() {
      if (pageAudioRecordNotifier.value == AudioRecordState.main) {
        setState(() {
          _listTags.clear();
          _listTagsString.clear();
        });
      }
    });
  }

  void _delTagItem(text) {
    setState(() {
      for (int i = 0; i < _listTagsString.length; i++) {
        if (_listTagsString[i] == text) {
          _listTagsString.removeAt(i);
          _listTags.removeAt(i);
          Strings.tagsCountForSave.value = _listTags.length;
        }
      }
    });
  }

  _animate() {
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        if (_listTags.length >= 2) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        }
      });
    });
  }

  void _textChanged(String text) {
    if (_listTags.length >= 16) {
      _tagController.text = "";
    }
    if (_tagController.text.length >= 25) {
      _tagController.text = _tagController.text.substring(0, 24);
      _tagController.selection = TextSelection.fromPosition(
          TextPosition(offset: _tagController.text.length));
    }
    if (text.isNotEmpty && text.substring(text.length - 1) == " ") {
      String temp = text.trim().replaceAll(" ", "");
      setState(() {
        if (temp != "") {
          _listTags.add(SaveTagItem(temp, _delTagItem));
          _listTagsString.add(temp);
          Strings.tagsCountForSave.value = _listTags.length;
          _animate();
        }
        _tagController.text = text.substring(temp.length + 1);
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
            prefixIcon: _listTags.isNotEmpty
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 0.725 * width),
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _listTags)))
                : null),
        controller: _tagController,
        onChanged: _textChanged);
  }
}
