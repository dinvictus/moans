import 'package:flutter/material.dart';

class EndFeedItem extends StatelessWidget {
  final Function() toRefreshFeed;
  const EndFeedItem(this.toRefreshFeed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: Column(children: [
        Text(""),
        SizedBox(
            child: ElevatedButton(
          child: Text(""),
          onPressed: () => toRefreshFeed,
        ))
      ])),
    );
  }
}
