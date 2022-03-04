import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moans/res.dart';
import 'package:google_fonts/google_fonts.dart';

class TagItem extends StatefulWidget {
  final int _index;
  final List _tags;
  const TagItem(this._tags, this._index, {Key? key}) : super(key: key);
  @override
  State<TagItem> createState() {
    return TagItemState();
  }
}

class TagItemState extends State<TagItem> {
  final TextStyle _textStyle = GoogleFonts.montserrat(
      color: MColors.mainColor, fontSize: 13, height: 1.8);
  final BoxDecoration _boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: MColors.mainColor));
  final EdgeInsets _padding = const EdgeInsets.fromLTRB(10, 0, 10, 0);
  final EdgeInsets _margin = const EdgeInsets.fromLTRB(5, 0, 5, 10);
  late ScrollController _scrollController;

  _animateForward() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 30), curve: const Interval(0.05, 1));
  }

  _animateRewerse() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 30), curve: const Interval(0.05, 1));
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        Timer(const Duration(seconds: 1), _animateRewerse);
      }
      if (_scrollController.offset == 0) {
        Timer(const Duration(seconds: 1), _animateForward);
      }
    });
    Utilities.curPage.addListener(() {
      if (widget._index != Utilities.curPage.value) {
        _scrollController.jumpTo(0.01);
      }
      if (widget._index == Utilities.curPage.value) {
        _animateForward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 30),
            curve: const Interval(0.05, 1.0));
      }
    });
    return Center(
        child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(10, 30, 10, 40),
            height: 43,
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget._tags.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: _margin,
                      padding: _padding,
                      decoration: _boxDecoration,
                      child: Text(
                        widget._tags[index],
                        style: _textStyle,
                        textAlign: TextAlign.center,
                      ));
                })));
  }
}
