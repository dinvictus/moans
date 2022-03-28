import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moans/utils/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class TagItem extends StatefulWidget {
  final int _index;
  final List<String> _tags;
  const TagItem(this._tags, this._index, {Key? key}) : super(key: key);
  @override
  State<TagItem> createState() {
    return _TagItemState();
  }
}

class _TagItemState extends State<TagItem> {
  late final int averageSymbols;
  final TextStyle _textStyle = GoogleFonts.montserrat(
    color: MColors.mainColor,
    fontSize: Utilities.deviceSizeMultiply / 40,
    fontWeight: FontWeight.w500,
  );
  final BoxDecoration _boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: MColors.mainColor));
  final EdgeInsets _padding = EdgeInsets.fromLTRB(
      Utilities.deviceSizeMultiply / 22,
      0,
      Utilities.deviceSizeMultiply / 22,
      0);
  final EdgeInsets _margin = const EdgeInsets.fromLTRB(5, 0, 5, 10);
  late ScrollController _scrollController;
  final List<Container> elementsList = [];

  animateForward() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: averageSymbols),
          curve: const Interval(0.05, 1));
    }
  }

  animateRewerse() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: Duration(seconds: averageSymbols),
          curve: const Interval(0.05, 1));
    }
  }

  Container getTagItem(String text) {
    return Container(
        alignment: Alignment.center,
        height: Utilities.deviceSizeMultiply / 15,
        margin: _margin,
        padding: _padding,
        decoration: _boxDecoration,
        child: Text(
          text,
          style: _textStyle,
          textAlign: TextAlign.center,
        ));
  }

  @override
  void initState() {
    super.initState();
    int countSymbols = 0;
    for (String tagItem in widget._tags) {
      elementsList.add(getTagItem(tagItem));
      countSymbols += tagItem.length;
    }
    averageSymbols = sqrt(countSymbols * widget._tags.length).toInt();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        Timer(const Duration(seconds: 1), animateRewerse);
      }
      if (_scrollController.offset == 0) {
        Timer(const Duration(seconds: 1), animateForward);
      }
    });
    Utilities.curPage.addListener(() {
      if (widget._index != Utilities.curPage.value) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.01);
        }
      }
      if (widget._index == Utilities.curPage.value) {
        animateForward();
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
    double height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        animateForward();
      }
    });
    return Center(
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, height / 19, 0, height / 18),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(children: elementsList))));
  }
}
