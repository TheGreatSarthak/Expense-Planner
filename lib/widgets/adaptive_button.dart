import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  //const AdaptiveButton({Key? key}) : super(key: key);

  final String text;
  final void Function() handler;
  // ignore: use_key_in_widget_constructors
  const AdaptiveButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(text),
            onPressed: handler,
          )
        : TextButton(
            child: Text(text),
            style:
                TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            onPressed: handler,
          );
  }
}
