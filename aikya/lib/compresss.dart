import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'button.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Compresss extends StatefulWidget {
  File video;
  Compresss(this.video);
  @override
  _CompresssState createState() => _CompresssState();
}

class _CompresssState extends State<Compresss> {
  File _storedVideoOne;
  var isLoading = false;
  // File _storedVideoTwo;
  var n = new Random().nextInt(1000);
  // String b1 = "Save to Gallery";
  // String b2 = "Save to firebase";
  // String videoLink = '';

  @override
  void initState() {
    super.initState();
    compress();
  }

  void compress() async {
    // setState(() {
    //   isLoading = true;
    // });
    _storedVideoOne = widget.video;
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "oc" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      isLoading = true;
    });

    String commandToExecute =
        '-i ${_storedVideoOne.path} -c:v mpeg4 $outputPath';
    _flutterFFmpeg.execute(commandToExecute)
        // .then((rc) => print("FFmpeg process exited with rc $rc"));
        .then((rc) {
      if (rc == 0) {
        setState(() {
          isLoading = false;
          // b1 = "Done !";
          // GallerySaver.saveVideo(outputPath);
          print('$outputPath');
          Navigator.of(context).pop(
            File(outputPath),
          );
        });
      } else {
        print("FFmpeg process exited with rc $rc");
        setState(() {
          isLoading = false;
        });
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
                  "Compressing...",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),

                // const SpinKitRotatingPlain(color: Colors.white),
                // const SpinKitChasingDots(color: Colors.white),
              ],
            ),
          ))
        : Container();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Compress VIDEOS"),
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
  //                     RecordVideoButton(_videoCompress, b1),
  //                     RecordVideoButton(_videoCompressf, b2),
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

  // void _videoCompress() async {
  //   // final appDir = await syspaths.getApplicationDocumentsDirectory();
  //   final appDir = await syspaths.getExternalStorageDirectory();
  //   String rawDocumentPath = appDir.path;
  //   String o = "oc" + "$n" + ".mp4";
  //   final outputPath = '$rawDocumentPath/$o';

  //   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  //   setState(() {
  //     b1 = "Loading..";
  //   });

  //   String commandToExecute =
  //       '-i ${_storedVideoOne.path} -c:v mpeg4 $outputPath';
  //   _flutterFFmpeg.execute(commandToExecute)
  //       // .then((rc) => print("FFmpeg process exited with rc $rc"));
  //       .then((rc) {
  //     if (rc == 0) {
  //       setState(() {
  //         b1 = "Done !";
  //         GallerySaver.saveVideo(outputPath);
  //         print('$outputPath');
  //       });
  //     } else {
  //       setState(() {
  //         b1 = 'ERROR';
  //       });
  //       print("FFmpeg process exited with rc $rc");
  //     }
  //   });
  // }

  // void _videoCompressf() async {
  //   // final appDir = await syspaths.getApplicationDocumentsDirectory();
  //   final appDir = await syspaths.getExternalStorageDirectory();
  //   String rawDocumentPath = appDir.path;
  //   String o = "oc" + "$n" + ".mp4";
  //   final outputPath = '$rawDocumentPath/$o';
  //   final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  //   setState(() {
  //     b2 = "Loading..";
  //   });
  //   String commandToExecute =
  //       '-i ${_storedVideoOne.path} -c:v mpeg4 $outputPath';
  //   _flutterFFmpeg.execute(commandToExecute)
  //       // .then((rc) => print("FFmpeg process exited with rc $rc"));
  //       .then((rc) {
  //     if (rc == 0) {
  //       setState(() {
  //         // b2 = "Done !";
  //         print('$outputPath');
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
  //       b2 = "DONE!";
  //     });
  //     print(link);
  //   });
  // }
}
