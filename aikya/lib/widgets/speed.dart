import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:math';
import 'package:aikya/tools/video.dart';
import 'package:video_player/video_player.dart';

class Speedx extends StatefulWidget {
  File v;
  Speedx(this.v);

  @override
  _SpeedxState createState() => _SpeedxState();
}

class _SpeedxState extends State<Speedx> {
  final navigatorKey = GlobalKey<NavigatorState>();

  var _loading = false;
  var n = new Random().nextInt(1000);
  List<File> vp = [];
  bool isLoading = false;
  double x;

  @override
  void initState() {
    super.initState();
    vp.add(widget.v);
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

  static final FlutterFFprobe _probe = FlutterFFprobe();
  bool audio = true;

  Future<void> dur(String path1) async {
    Map<dynamic, dynamic> file1 = await _probe.getMediaInformation(path1);
    print("infooooooooo");

    var a1 = file1['streams'].last;

    var aa1 = a1['type'];

    setState(() {
      if (aa1 != 'audio') {
        audio = false;
      }
    });
  }

  void crop() async {
    await dur(vp.last.path);
    if (audio == true) {
      speed();
    }
  }

  void speed() async {
    var n = new Random().nextInt(10000);
    File _storedVideoOne = vp.last;
    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "os" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      _loading = true;
    });
    String commandToExecute;

    if (x == 0.5) {
      commandToExecute =
          '-i "${_storedVideoOne.path}" -filter_complex "[0:v]setpts=PTS/0.5[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" "$outputPath"';
      // '-i ${_storedVideoOne.path} -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" $outputPath';
    } else if (x == 1.0) {
      commandToExecute =
          '-i "${_storedVideoOne.path}" -filter_complex "[0:v]setpts=1.0*PTS[v];[0:a]atempo=1.0[a]" -map "[v]" -map "[a]" "$outputPath"'; //done
    } else if (x == 1.5) {
      commandToExecute =
          '-i "${_storedVideoOne.path}" -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2.0[a]" -map "[v]" -map "[a]" "$outputPath"'; //done
    } else if (x == 2.0) {
      commandToExecute =
          '-i "${_storedVideoOne.path}" -filter_complex "[0:v]setpts=0.25*PTS[v];[0:a]atempo=4.0[a]" -map "[v]" -map "[a]" "$outputPath"'; //done
    } else if (x == 0.75) {
      commandToExecute =
          '-i "${_storedVideoOne.path}" -filter_complex "[0:v]setpts=PTS/0.75[v];[0:a]atempo=0.75[a]" -map "[v]" -map "[a]" "$outputPath"'; //done
    }

    //https://williamyaps.blogspot.com/2017/01/ffmpeg-speed-up-video-and-audio.html?m=1

    _flutterFFmpeg.execute(commandToExecute).then((rc) {
      if (rc == 0) {
        setState(() {
          _loading = false;
          print('$outputPath');
          // Navigator.of(context).pop(
          //   File(outputPath),
          // );
          vp.add(File(outputPath));
        });
      } else {
        setState(() {
          _loading = false;
        });

        print("FFmpeg process exited with rc $rc");
      }
    });
  }

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
            audio
                ? Container()
                : Center(
                    child: Container(
                        child: Text("Please make sure video has audio",
                            style: TextStyle(color: Colors.white)))),
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
          padding: EdgeInsets.only(left: 5),
          height: 30,
          color: Colors.black,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              RaisedButton(
                child: Text("0.5x"),
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    x = 0.5;
                  });
                  crop();
                },
              ),
              RaisedButton(
                child: Text("0.75x"),
                color: Colors.green,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    x = 0.75;
                  });
                  print(x);
                  crop();
                },
              ),
              RaisedButton(
                child: Text("1.0x"),
                color: Colors.pink,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    x = 1.0;
                  });
                  crop();
                },
              ),
              RaisedButton(
                child: Text("1.5x"),
                color: Colors.blue,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    x = 1.5;
                  });
                  crop();
                },
              ),
              RaisedButton(
                child: Text("2.0x"),
                color: Colors.green,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    x = 2.0;
                  });
                  crop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
