import 'package:fasttrack/fast_track_icons_icons.dart';
import 'package:fasttrack/fasting_status_widget.dart';
import 'package:fasttrack/journal_widget.dart';
import 'package:fasttrack/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  Widget _handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Text('Loading!'),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return FastingPage(
                title: 'Fast Track',
                analytics: analytics,
                observer: observer,
              );
            }

            return Scaffold(
              body: Center(
                child: RaisedButton(
                    child: Text("Begin"),
                    onPressed: () async {
                      final FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
                      print(user.isAnonymous);
                      print(user.displayName);
                      print(user.uid);
                    }
                ),
              ),
            );
          }
        }
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: _handleCurrentScreen(),
    );
  }
}

class FastingPage extends StatefulWidget {
  FastingPage({Key key, this.title, this.analytics, this.observer}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _FastingPageState createState() => _FastingPageState(analytics, observer);
}

class _FastingPageState extends State<FastingPage> {
  _FastingPageState(this.analytics, this.observer);

  double _currentWeight = 252.6;
  int _currentIndex = 0;
  final List<Widget> _children = [
    FastingStatusWidget(),
    JournalWidget(),
    ProfileWidget()
  ];
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          iconSize: 28,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(FastTrackIcons.fasting),
              title: const Text('Fasting'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(FastTrackIcons.journal),
              title: const Text('Journal'),
            ),
            const BottomNavigationBarItem(
                icon: const Icon(FastTrackIcons.profile),
                title: const Text('Profile'))
          ],
          onTap: (int index) {
            setState(() {
              List<String> _screenNames = [
                'Fasting',
                'Journal',
                'Profile',
              ];
              analytics.setCurrentScreen(
                  screenName: _screenNames[index]
              );
              _currentIndex = index;
            });
          },
        ),
        body: SafeArea(
          child: _children[_currentIndex],
        ),
        floatingActionButtonAnimator: NoScalingAnimation(),
        floatingActionButton: _currentIndex == 2
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: FloatingActionButton(
                      heroTag: 'logFood',
                      tooltip: 'Log food',
                      mini: true,
                      child: Icon(Icons.add),
                      backgroundColor: Theme.of(context).accentColor,
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext buildContext) =>
                                new AlertDialog(
                                  title: const Text('Log food?'),
                                  content: const Text(
                                      "Track when you eat during the day, and if track if you break your fast."),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: () {
                                          Navigator.of(buildContext)
                                              .pop('cancel');
                                        },
                                        child: const Text("Cancel")),
                                    new FlatButton(
                                        onPressed: () => Navigator.of(buildContext).pop('food'),
                                        child: Text("I ate!",))
                                  ],
                                )).then((value) => {});
                      },
                    ),
                  ),
                  FloatingActionButton(
                      heroTag: 'logWeight',
                      tooltip: 'Log weight',
                      child: Icon(Icons.assessment),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext buildContext) =>
                                new NumberPickerDialog.decimal(
                                  title: const Text('Log weight'),
                                  minValue: 100,
                                  maxValue: 500,
                                  decimalPlaces: 1,
                                  initialDoubleValue: _currentWeight,
                                )).then((value) {
                          if (value != null) {
                            if (value is double) {
                              setState(() {
                                _currentWeight = value;
                                Firestore.instance.collection('testweights').add({
                                  'weight': value,
                                  'when': DateTime.now(),
                                });
                              });
                            }
                          }
                        });
                      }),
                ],
              ));
  }
}

class NoScalingAnimation extends FloatingActionButtonAnimator{
  double _x;
  double _y;
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    _x = begin.dx +(end.dx - begin.dx)*progress ;
    _y = begin.dy +(end.dy - begin.dy)*progress;
    return Offset(_x,_y);
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}