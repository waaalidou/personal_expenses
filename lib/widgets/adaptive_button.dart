import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final VoidCallback _handeler;
  final String _title;
  const AdaptiveFlatButton({super.key, required handeler, required title})
      : _handeler = handeler,
        _title = title;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: _handeler,
            child: Text(
              _title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : OutlinedButton(
            onPressed: _handeler,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary),
              side: MaterialStateProperty.all(BorderSide.none),
            ),
            child:  Text(
              _title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
