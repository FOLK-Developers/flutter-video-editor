import 'dart:math';

import 'package:aikya/widgets/text.dart';
import 'package:aikya/tools/video.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tapioca/src/video_editor.dart';
import '../tools/global.dart' as global;
import 'package:tapioca/tapioca.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Textover extends StatefulWidget {
  File v;
  Textover(this.v);

  @override
  _TextoverState createState() => _TextoverState();
}

class _TextoverState extends State<Textover> {
  String _platformVersion = 'Unknown';
  final navigatorKey = GlobalKey<NavigatorState>();
  File _video;
  var _loading = false;
  var n = new Random().nextInt(1000);
  List<File> vp = [];
  bool isLoading = false;
  String val;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  var slider = 20.0;
  int size = 21;

  @override
  void initState() {
    super.initState();
    vp.add(widget.v);
    initPlatformState();
  }

  Widget player() {
    print("RIDDHIJAIN");

    print(vp.last);
    return Container(
      color: Colors.black,
      height: 500,
      child: Center(
        child: ChewieListItem(
          videoPlayerController: VideoPlayerController.file(vp.last),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;
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

  Color x = Color(0xff443a49);
  TextEditingController name = TextEditingController();

  void applyText(var val) async {
    String o = "ot" + "$n" + ".mp4";
    setState(() {
      _loading = true;
    });
    var tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/$o';
    print(val);
    print(global.y);
    try {
      final tapiocaBalls = [
        TapiocaBall.textOverlay(
            val['text'], global.x, global.y, val['size'], val['color']),
      ];
      if (_video != null) {
        final cup = Cup(Content(_video.path), tapiocaBalls);
        cup.suckUp(path).then((_) async {
          print("finished");

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _loading
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                      color: Colors.black,
                      height: 500,
                      width: double.infinity,
                    )
                  : player(),
              Container(
                color: Colors.black,
                child: Row(
                  children: [
                    Center(
                      child: RaisedButton(
                          child: Text("ADD TEXT"),
                          color: Colors.white,
                          textColor: Colors.black,
                          onPressed: () async {
                            final value = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TextEditor(vp.last)));
                            if (value.toString().isEmpty) {
                              print("true");
                            } else {
                              applyText(value);
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
