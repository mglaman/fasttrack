import 'package:flutter/material.dart';

class JournalWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Journal',
          style: Theme.of(context).textTheme.title,
        )
      ],
    );
  }
}