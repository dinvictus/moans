import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moans/elements/audiorecorder.dart';
import 'package:moans/elements/savetagitem.dart';
import 'package:moans/res.dart';

class SaveTag extends StatefulWidget {
  final List<String> listTagsString;
  final Function(int count) changeTagsCount;
  const SaveTag(
      {required this.listTagsString, required this.changeTagsCount, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SaveTagState();
  }
}

class _SaveTagState extends State<SaveTag> {
  final List<Widget> _listTags = [];
  // final List<String> _listTagsString = [];
  final _scrollController = ScrollController();
  final _tagController = TextEditingController();

  loadingTags() {
    for (String tag in widget.listTagsString) {
      _listTags.add(SaveTagItem(tag, _delTagItem));
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
            _listTags.clear();
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
          _listTags.removeAt(i);
          widget.changeTagsCount(_listTags.length);
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

  _textChanged(String text) {
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
          widget.listTagsString.add(temp);
          widget.changeTagsCount(_listTags.length);
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
