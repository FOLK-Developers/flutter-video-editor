import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Crops extends StatefulWidget {
  File video;
  Crops(this.video);
  @override
  _CropsState createState() => _CropsState();
}

class _CropsState extends State<Crops> {
  File _storedVideoOne;
  var isLoading = false;

  // VideoPlayerController videoPlayerController;
  // var h, w;
  var n = new Random().nextInt(1000);
  // String b1 = "Save to Gallery";
  // String b2 = "Save to firebase";

  @override
  void initState() {
    super.initState();
    // videoPlayerController = VideoPlayerController.file(widget.video)
    //   ..initialize().then((value) {
    //     // h = videoPlayerController.value.size.height;
    //     // w = videoPlayerController.value.size.width;
    //     // print("videohbhailogon");
    //     // print(h);
    //   });
    crop();
  }

  void crop() async {
    // print("in crop");
    // print(h / 2);
    _storedVideoOne = widget.video;
    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "op" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      isLoading = true;
    });
    String commandToExecute =
        '-i ${_storedVideoOne.path} -filter:v "crop=240:120:240:120" $outputPath';
    // '-i ${_storedVideoOne.path} -filter:v "crop=${w / 2}:${h / 2}:${w / 2}:${h / 2}" $outputPath';
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
                  "Cropping...",
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("CROP VIDEOS"),
  //     ),
  //     body: Container(
  //       padding: EdgeInsets.only(top: 200),
  //       child: Column(
  //         children: [
  //           Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SizedBox.fromSize(
  //                   size: Size(100, 100), // button width and height
  //                   child: ClipOval(
  //                     child: Material(
  //                       color: Color(0xffe49273), // button color
  //                       child: InkWell(
  //                         splashColor: Colors.green, // splash color
  //                         onTap: _pickVideo, // button pressed
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: <Widget>[
  //                             Icon(Icons.video_library, size: 40), // icon
  //                             Text("Video 1"), // text
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ]),
  //           SizedBox(
  //             height: 30,
  //           ),
  //           _storedVideoOne != null
  //               ? Column(
  //                   children: [
  //                     RecordVideoButton(_videoCrop, b1),
  //                     RecordVideoButton(_videoCropf, b2),
  //                   ],
  //                 )
  //               : Container(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _pickVideo() async {
  //   File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
  //   // _video = video;
  //   if (video != null && video.path != null) {
  //     setState(() {
  //       if (_storedVideoOne == null) {
  //         _storedVideoOne = video;
  //         print('video 1 stored');
  //       }
  //     });
  //   }
  // }

  // void _videoCrop() async {
  //   // final appDir = await syspaths.getApplicationDocumentsDirectory();
  //   final appDir = await syspaths.getExternalStorageDirectory();
  //   String rawDocumentPath = appDir.path;
  //   String o = "op" + "$n" + ".mp4";
  //   final outputPath = '$rawDocumentPath/$o';

  //   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  //   setState(() {
  //     b1 = 'Loading..';
  //   });
  //   String commandToExecute =
  //       '-i ${_storedVideoOne.path} -filter:v "crop=240:120:240:120" $outputPath';
  //   _flutterFFmpeg.execute(commandToExecute)
  //       // .then((rc) => print("FFmpeg process exited with rc $rc"));
  //       .then((rc) {
  //     if (rc == 0) {
  //       setState(() {
  //         b1 = "Done !";
  //         GallerySaver.saveVideo(outputPath);
  //       });
  //     } else {
  //       setState(() {
  //         b1 = 'ERROR';
  //       });

  //       print("FFmpeg process exited with rc $rc");
  //     }
  //   });
  // }

  // void _videoCropf() async {
  //   // final appDir = await syspaths.getApplicationDocumentsDirectory();
  //   final appDir = await syspaths.getExternalStorageDirectory();
  //   String rawDocumentPath = appDir.path;
  //   String o = "op" + "$n" + ".mp4";
  //   final outputPath = '$rawDocumentPath/$o';

  //   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  //   setState(() {
  //     b2 = 'Loading..';
  //   });
  //   String commandToExecute =
  //       '-i ${_storedVideoOne.path} -filter:v "crop=240:120:240:120" $outputPath';
  //   _flutterFFmpeg.execute(commandToExecute)
  //       // .then((rc) => print("FFmpeg process exited with rc $rc"));
  //       .then((rc) {
  //     if (rc == 0) {
  //       setState(() {
  //         fire(outputPath);
  //       });
  //     } else {
  //       print("FFmpeg process exited with rc $rc");
  //     }
  //   });
  // }

  // void fire(String out) async {
  //   File file = new File("$out");
  //   // String name = path.basename(file.path);
  //   final StorageReference firestorageRef =
  //       FirebaseStorage.instance.ref().child("Videos").child('$n.mp4');

  //   firestorageRef.putFile(file).onComplete.then((storage) async {
  //     String link = await storage.ref.getDownloadURL();
  //     setState(() {
  //       b2 = 'DONE!';
  //     });
  //     print(link);
  //   });
  // }
}
