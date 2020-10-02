import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';

import 'package:path_provider/path_provider.dart' as syspaths;

class Audiox extends StatefulWidget {
  File video;
  Audiox(this.video);
  @override
  _AudioxState createState() => _AudioxState();
}

class _AudioxState extends State<Audiox> {
  String _absolutePathOfAudio;
  AudioPlayer audioPlayer;
  File file;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  bool _loading = false;
  // var isLoading = false;
  static final FlutterFFprobe _probe = FlutterFFprobe();

  var n = new Random().nextInt(1000);

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  // void showLoading() {
  //   if (_loading == true) {
  //     showDialog(
  //       context: navigatorKey.currentState.overlay.context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           child: new Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               new CircularProgressIndicator(),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: new Text("Loading"),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  void onSelect() async {
    setState(() {
      file = File(_absolutePathOfAudio);
    });

    audio();
  }

  double duration = 0;

  Future<double> dur(String path) async {
    Map<dynamic, dynamic> info = await _probe.getMediaInformation(path);
    // print("hiii");
    setState(() {
      duration = info['duration'] / 1000;
    });
    return info['duration'] / 1000;
  }

  void audio() async {
    // _storedVideoOne = widget.video;

    // var file = new File('${(await getTemporaryDirectory()).path}/audio.mp3');
    // file = await file.writeAsBytes((await loadAsset()).buffer.asUint8List());

    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "oa" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    var a = await dur(file.path);
    var b = await dur(widget.video.path);

//Replacing original sound
    String commandToExecute;
    if (a > b) {
      print("In If And audio bigger");
      commandToExecute =
          '-i ${widget.video.path} -i ${file.path} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $outputPath'; //total time=video as shortest time is of video
    } else {
      print("In If ansd Video bigger");
      commandToExecute =
          '-i ${widget.video.path} -stream_loop -1 -i ${file.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //loop audio total time=video
    }

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      _loading = true;
      // showLoading();
    });

    // commandToExecute ='-i ${_storedVideoOne.path} -stream_loop -1 -i ${file.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //loop audio total time=video
    // ' -stream_loop -1 -i ${_storedVideoOne.path} -i ${file.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //if video is small loop it..total time=audio's
    // '-i ${_storedVideoOne.path} -i ${file.path} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $outputPath'; //nice-replacing original- total time=the one which has smallest duration
    // '-i ${_storedVideoOne.path} -i ${file.path} -c:v copy -c:a aac $outputPath'; //working fine but no audio

    _flutterFFmpeg.execute(commandToExecute)
        // .then((rc) => print("FFmpeg process exited with rc $rc"));
        .then((rc) {
      if (rc == 0) {
        setState(() {
          _loading = false;
          print('$outputPath');
          Navigator.of(context).pop(
            File(outputPath),
          );
          // b1 = "Done !";
          // GallerySaver.saveVideo(outputPath);
        });
      } else {
        setState(() {
          _loading = false;
        });

        print("FFmpeg process exited with rc $rc");
      }
    });
  }

  void openAudioPicker() async {
    // setState(() {
    //   _loading = true;
    //   // showLoading();
    // });
    // showLoading();
    await FilePicker.getFilePath(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    ).then((value) {
      setState(() {
        // _loading = false;
        _absolutePathOfAudio = value;
        print(value);
      });
    });
  }

  void playMusic() async {
    await audioPlayer.play(_absolutePathOfAudio, isLocal: true);
  }

  void stopMusic() async {
    await audioPlayer.stop();
  }

  void resumeMusic() async {
    await audioPlayer.resume(); // quickly plays the sound, will not release
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: _loading
          ? Scaffold(
              body: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: SpinKitPouringHourglass(
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                  Text(
                    "Adding Sound...",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              ),
            ))
          : Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                // backgroundColor: Colors.black,
                title: const Text('Adding Audio'),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.orange,
                      child: Text(
                        "Select an audio",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        openAudioPicker();
                      },
                    ),
                    _absolutePathOfAudio == null
                        ? Container()
                        : Text(
                            "Absolute path",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              new ClipboardData(text: _absolutePathOfAudio));
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Copied path !')),
                          );
                        },
                        child: _absolutePathOfAudio == null
                            ? Container()
                            : Text(_absolutePathOfAudio),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _absolutePathOfAudio == null
                            ? Container()
                            : FlatButton(
                                color: Colors.green[400],
                                child: Text(
                                  "Play",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: playMusic,
                              ),
                        _absolutePathOfAudio == null
                            ? Container()
                            : FlatButton(
                                color: Colors.red[400],
                                child: Text(
                                  "Stop",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: stopMusic,
                              )
                      ],
                    ),
                    _absolutePathOfAudio == null
                        ? Container()
                        : FlatButton(
                            color: Colors.blue,
                            child: Text(
                              "Select",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: onSelect,
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
