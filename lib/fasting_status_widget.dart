import 'dart:async';

import 'package:fasttrack/fasting_status_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FastingStatusWidget extends StatefulWidget {
  @override
  FastingStatusWidgetState createState() {
    return new FastingStatusWidgetState();
  }
}

class FastingStatusWidgetState extends State<FastingStatusWidget> {
  Timer _timer;
  FastingStatus _fastingStatus;

  @override
  void initState() {
    _loadData();
    super.initState();
  }
  void callback(Timer timer) {
    setState(() {
      _fastingStatus.tick();
    });
  }
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // @todo this moved to the account document for the user.
      _fastingStatus = new FastingStatus(
          prefs.getInt('fastStartHour') ?? 20,
          prefs.getInt('fastStartMinute') ?? 00,
          prefs.getInt('fastEndHour') ?? 12,
          prefs.getInt('fastEndMinute') ?? 00
      );
      _timer = new Timer.periodic(new Duration(seconds: 1), callback);
    });
  }


  String twoDigits(int n) => (n >= 10) ? "$n" : "0$n";

  String formatDuration(Duration d) {
    return "${d.inHours}:${twoDigits(d.inMinutes.remainder(Duration.minutesPerHour))}:${twoDigits(d.inSeconds.remainder(Duration.secondsPerMinute))}";
  }

  @override
  Widget build(BuildContext context) {
    if (_fastingStatus == null) {
      return Center(
        child: Text("Loading..."),
      );
    }

    double getProgressIndicatorValue() {
      Duration _entireDuration;
      double value;
      if (_fastingStatus.isFasting()) {
        _entireDuration = _fastingStatus.fastEnd.add(Duration(days: 1)).difference(_fastingStatus.fastStart);
        value = _fastingStatus.timeUntilFastEnds.inSeconds / _entireDuration.inSeconds;
      } else {
        _entireDuration = _fastingStatus.fastStart.difference(_fastingStatus.fastEnd);
        value = _fastingStatus.timeUntilFastStarts.inSeconds / _entireDuration.inSeconds;
      }
      return 1 - value;
    }

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: Text(
                'Currently ${_fastingStatus.isFasting() ? 'fasting' : 'nosh time'}',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Text(
              _fastingStatus.isFasting() ?
              'Fast ends in ${formatDuration(_fastingStatus.timeUntilFastEnds)}'
                  :
              'Fasting begins in ${formatDuration(_fastingStatus.timeUntilFastStarts)}',
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              child: CircularProgressIndicator(
                value: getProgressIndicatorValue(),
                strokeWidth: 15.0,
                valueColor: new AlwaysStoppedAnimation<Color>(_fastingStatus.isFasting() ? Colors.red : Colors.green),
              ),
              width: 200,
              height: 200,
            )
          ]
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}