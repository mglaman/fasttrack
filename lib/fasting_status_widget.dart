import 'dart:async';

import 'package:fasttrack/fasting_status_model.dart';
import 'package:flutter/material.dart';

class FastingStatusWidget extends StatefulWidget {
  @override
  FastingStatusWidgetState createState() {
    return new FastingStatusWidgetState();
  }
}

class FastingStatusWidgetState extends State<FastingStatusWidget> {
  Timer timer;
  FastingStatus _fastingStatus = new FastingStatus();

  @override
  void initState() {
    timer = new Timer.periodic(new Duration(seconds: 1), callback);
    super.initState();
  }
  void callback(Timer timer) {
    setState(() {
      _fastingStatus = new FastingStatus();
    });
  }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String formatDuration(Duration d) {
    return "${d.inHours}:${twoDigits(d.inMinutes.remainder(Duration.minutesPerHour))}:${twoDigits(d.inSeconds.remainder(Duration.secondsPerMinute))}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: Text(
              'Currently ${_fastingStatus.isFasting ? 'fasting' : 'nosh time'}',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          Text(
            _fastingStatus.isFasting ?
            'Fast ends in ${formatDuration(_fastingStatus.timeUntilFastEnds)}'
                :
            'Fasting beings in ${formatDuration(_fastingStatus.timeUntilFastStarts)}',
            style: Theme.of(context).textTheme.title,
          )
        ]
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }
}