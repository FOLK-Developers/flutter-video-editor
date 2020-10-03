import 'dart:math';

import 'package:aikya/tools/video.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:tapioca/src/video_editor.dart';
import 'package:tapioca/tapioca.dart';

import 'package:path_provider/path_provider.dart';

import 'package:video_player/video_player.dart';

class Filter extends StatefulWidget {
  File v;
  Filter(this.v);

  @override
  _MyFilterState createState() => _MyFilterState();
}

class _MyFilterState extends State<Filter> {
  String _platformVersion = 'Unknown';
  final navigatorKey = GlobalKey<NavigatorState>();
  File _video;
  var _loading = false;
  var n = new Random().nextInt(1000);
  List<File> vp = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    vp.add(widget.v);
    initPlatformState();
  }

  Widget player() {
    print("RIDDHIJAIN");

    // // VideoPlayerController controller;
    print(vp.last);
    return Container(
      color: Colors.black,
      height: 500,
      //   child: VideoApp(video.last),
      // );
      child: Center(
        // child: Expanded(
        child: ChewieListItem(
          videoPlayerController: VideoPlayerController.file(vp.last),
        ),
        // ),
      ),
    );
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await VideoEditor.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _video = widget.v;
    });
  }

  void applyFilter(Filters x) async {
    String o = "ox" + "$n" + ".mp4";
    setState(() {
      _loading = true;
    });
    var tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/$o';

    try {
      final tapiocaBalls = [
        TapiocaBall.filter(x),
      ];
      if (_video != null) {
        final cup = Cup(Content(_video.path), tapiocaBalls);
        cup.suckUp(path).then((_) async {
          print("finished");

          // navigatorKey.currentState.push(
          //   MaterialPageRoute(builder: (context) => VideoScreen(path)),
          // );
          setState(() {
            vp.add(File(path));
            _loading = false;
          });
        });
      } else {
        print("video is null");
      }
    } on PlatformException {
      print("error!!!!");
    }
  }

  MediaQueryData qd;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Output'),
          actions: [
            IconButton(
                icon: Icon(Icons.undo),
                onPressed: () {
                  Navigator.of(context).pop(File(widget.v.path));
                }),
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  Navigator.of(context).pop(File(vp.last.path));
                }),
          ],
        ),
        body: Column(
          children: [
            _loading
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                    color: Colors.black,
                    height: 500,
                    width: double.infinity,
                  )
                : player(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 30,
          child: Row(
            children: [
              RaisedButton(
                child: Text("White"),
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () => applyFilter(Filters.white),
              ),
              RaisedButton(
                child: Text("Pink"),
                color: Colors.pink,
                textColor: Colors.black,
                onPressed: () => applyFilter(Filters.pink),
              ),
              RaisedButton(
                child: Text("Blue"),
                color: Colors.blue,
                textColor: Colors.black,
                onPressed: () => applyFilter(Filters.blue),
              ),
              RaisedButton(
                child: Text("Green"),
                color: Colors.green,
                textColor: Colors.black,
                onPressed: () => applyFilter(Filters.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
