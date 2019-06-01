import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking Timer',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Cooking timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _time = 30;
  var _future;
  bool _isplay = false;
  var _stop = false;
  AudioPlayer _player;

  void _decrementSecondUntilZero() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_time > 0) {
        _time--;
      }
      else playMusic();
    });
  }


  void playMusic() async  {
    if(!_stop && !_isplay) {
      setState(() {
        _isplay = true;
      });
      final ByteData data = await rootBundle.load('music/nyancat.mp3');
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/nyancat.mp3');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

      _player.play(tempFile.uri.toString(), isLocal: true);
    }
  }

  void stopMusic() {
    setState(() {
      _isplay = false;
    });
    _player.stop();
  }

  initFuture() {
    if (_future == null) {

      _future = Timer.periodic(const Duration(seconds: 1), (timer) {
        _decrementSecondUntilZero();
      });


      _player = new AudioPlayer();

    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    initFuture();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Remain seconds: ',
            ),
            Text(
              '$_time',
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton.icon(
                icon: Icon(Icons.timer),
                label: Text('Start/Reset'),
                onPressed: () {
                  stopMusic();
                  setState(() {
                    _stop = false;
                    _time = 30;
                  });
                }),
            FlatButton.icon(
                icon: Icon(Icons.stop),
                label: Text('Stop'),
                onPressed: () {
                  setState(() {
                    _stop = true;
                  });
                  stopMusic();
                })
          ],
        ),
      ),
    );
  }


}
