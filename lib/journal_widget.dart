import 'package:flutter/material.dart';

class JournalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Journal',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
            ),
          ],
        )
    );
  }
}
