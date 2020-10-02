import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Audiop extends StatefulWidget {
  File video;
  File audio;
  Audiop(this.video, this.audio);
  @override
  _AudiopState createState() => _AudiopState();
}

class _AudiopState extends State<Audiop> {
  File _storedVideoOne;
  var isLoading = false;
  static final FlutterFFprobe _probe = FlutterFFprobe();

  var n = new Random().nextInt(1000);

  @override
  void initState() {
    super.initState();

    crop();
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

  void crop() async {
    _storedVideoOne = widget.video;

    // var file = new File('${(await getTemporaryDirectory()).path}/audio.mp3');
    // file = await file.writeAsBytes((await loadAsset()).buffer.asUint8List());

    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "oa" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    var a = await dur(widget.audio.path);
    var b = await dur(_storedVideoOne.path);

//Replacing original sound
    String commandToExecute;
    if (a > b) {
      print("In If And audio bigger");
      commandToExecute =
          '-i ${_storedVideoOne.path} -i ${widget.audio.path} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $outputPath'; //total time=video as shortest time is of video
    } else {
      print("In If ansd Video bigger");
      commandToExecute =
          '-i ${_storedVideoOne.path} -stream_loop -1 -i ${widget.audio.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //loop audio total time=video
    }

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      isLoading = true;
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
          isLoading = false;
          print('$outputPath');
          Navigator.of(context).pop(
            File(outputPath),
          );
          // b1 = "Done !";
          // GallerySaver.saveVideo(outputPath);
        });
      } else {
        setState(() {
          isLoading = false;
        });

        print("FFmpeg process exited with rc $rc");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // compress();
    return isLoading
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
            body: Container(
            color: Colors.black,
            child: Text("Please Try Again Later",
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ));
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class Audiop extends StatefulWidget {
//   File video;
//   File audio;
//   Audiop(this.video, this.audio);
//   @override
//   _AudiopState createState() => _AudiopState();
// }

// class _AudiopState extends State<Audiop> {
//   File _storedVideoOne;
//   var isLoading = false;
//   static final FlutterFFprobe _probe = FlutterFFprobe();

//   var n = new Random().nextInt(1000);

//   @override
//   void initState() {
//     super.initState();

//     crop();
//   }

//   double duration = 0;

//   Future<ByteData> loadAsset() async {
//     return await rootBundle.load('assets/audio.mp3');
//   }

//   Future<double> dur(String path) async {
//     Map<dynamic, dynamic> info = await _probe.getMediaInformation(path);
//     // print("hiii");
//     setState(() {
//       duration = info['duration'] / 1000;
//     });
//     return info['duration'] / 1000;
//   }

//   void crop() async {
//     _storedVideoOne = widget.video;

//     // var file = new File('${(await getTemporaryDirectory()).path}/audio.mp3');
//     // file = await file.writeAsBytes((await loadAsset()).buffer.asUint8List());

//     final appDir = await syspaths.getExternalStorageDirectory();
//     String rawDocumentPath = appDir.path;
//     String o = "oa" + "$n" + ".mp4";
//     final outputPath = '$rawDocumentPath/$o';

//     var a = await dur(widget.audio.path);
//     var b = await dur(_storedVideoOne.path);

// //Replacing original sound
//     String commandToExecute;
//     if (a > b) {
//       print("In If And audio bigger");
//       commandToExecute =
//           '-i ${_storedVideoOne.path} -i ${widget.audio.path} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $outputPath'; //total time=video as shortest time is of video
//     } else {
//       print("In If ansd Video bigger");
//       commandToExecute =
//           '-i ${_storedVideoOne.path} -stream_loop -1 -i ${widget.audio.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //loop audio total time=video
//     }

//     final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
//     setState(() {
//       isLoading = true;
//     });

//     // commandToExecute ='-i ${_storedVideoOne.path} -stream_loop -1 -i ${file.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //loop audio total time=video
//     // ' -stream_loop -1 -i ${_storedVideoOne.path} -i ${file.path} -shortest -map 0:v:0 -map 1:a:0 -y $outputPath'; //if video is small loop it..total time=audio's
//     // '-i ${_storedVideoOne.path} -i ${file.path} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $outputPath'; //nice-replacing original- total time=the one which has smallest duration
//     // '-i ${_storedVideoOne.path} -i ${file.path} -c:v copy -c:a aac $outputPath'; //working fine but no audio

//     _flutterFFmpeg.execute(commandToExecute)
//         // .then((rc) => print("FFmpeg process exited with rc $rc"));
//         .then((rc) {
//       if (rc == 0) {
//         setState(() {
//           isLoading = false;
//           print('$outputPath');
//           Navigator.of(context).pop(
//             File(outputPath),
//           );
//           // b1 = "Done !";
//           // GallerySaver.saveVideo(outputPath);
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });

//         print("FFmpeg process exited with rc $rc");
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // compress();
//     return isLoading
//         ? Scaffold(
//             body: Container(
//             color: Colors.black,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Center(
//                   child: SpinKitPouringHourglass(
//                     color: Colors.white,
//                     size: 100,
//                   ),
//                 ),
//                 Text(
//                   "Adding Sound...",
//                   style: TextStyle(color: Colors.white, fontSize: 25),
//                 ),
//               ],
//             ),
//           ))
//         : Scaffold(
//             body: Container(
//             color: Colors.black,
//             child: Text("Please Try Again Later",
//                 style: TextStyle(color: Colors.white, fontSize: 25)),
//           ));
//   }
// }
