import 'package:fasttrack/fast_track_icons_icons.dart';
import 'package:fasttrack/fasting_status_widget.dart';
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
//      home: FastingPage(title: 'Fast Track'),
      initialRoute: '/',
      routes: {
        '/': (context) => FastingPage(title: 'Fast tracking'),
        '/journal': (context) => JournalPage()
      },
    );
  }
}

AppNavigationBar appBottomNavigationBar() {
  return AppNavigationBar();
}

class AppNavigationBar extends StatefulWidget {
  @override
  AppNavigationBarState createState() {
    return new AppNavigationBarState();
  }
}

// @todo improve navigation via https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation
// instead of routes and pages, array of children things in one page.
class AppNavigationBarState extends State<AppNavigationBar> {
  int _currentIndex = 0;
  List<int> _history = [0];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
        _history.add(index);
        setState(() => _currentIndex = index);
        switch (index) {
          case 1:
            Navigator.pushNamed(context, '/journal');
            break;
          case 0:
          default:
            Navigator.pushNamed(context, '/');
            break;
        }
      },
    );
  }
}

SafeArea appBody(Widget child) {
  return SafeArea(
    child: child,
  );
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
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        bottomNavigationBar: appBottomNavigationBar(),
        body: appBody(
            Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                children: <Widget>[FastingStatusWidget()],
              ),
            )
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

class JournalPage extends StatefulWidget {
  @override
  JournalPageState createState() {
    return new JournalPageState();
  }
}

class JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: appBottomNavigationBar(),
      body: appBody(
        Text('journal')
      )
    );
  }
}