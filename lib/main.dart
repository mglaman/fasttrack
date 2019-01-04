import 'package:fasttrack/fast_track_icons_icons.dart';
import 'package:fasttrack/fasting_status_widget.dart';
import 'package:fasttrack/journal_widget.dart';
import 'package:fasttrack/profile_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: FastingPage(title: 'Fast Track'),
    );
  }
}

class FastingPage extends StatefulWidget {
  FastingPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _FastingPageState createState() => _FastingPageState();
}

class _FastingPageState extends State<FastingPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FastingStatusWidget(),
    JournalWidget(),
    ProfileWidget()
  ];

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
              icon: new Icon(FastTrackIcons.fasting),
              title: new Text('Fasting'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(FastTrackIcons.journal),
              title: new Text('Journal'),
            ),
            BottomNavigationBarItem(
                icon: Icon(FastTrackIcons.profile),
                title: Text('Profile')
            )
          ],
          onTap: (int index) {
            setState(() => _currentIndex = index);
          },
        ),
        body: SafeArea(
          child: _children[_currentIndex],
        ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: FloatingActionButton(
                heroTag: null,
                tooltip: 'Log food',
                mini: true,
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).accentColor,
                onPressed: () {},
              ),
            ),
            FloatingActionButton(
                heroTag: null,
                tooltip: 'Log weight',
                child: Icon(Icons.assessment),
                onPressed: () {}),
          ],
        ));
  }
}