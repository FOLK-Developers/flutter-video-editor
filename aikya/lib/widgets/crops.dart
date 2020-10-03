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

  var n = new Random().nextInt(10000);

  @override
  void initState() {
    super.initState();
    crop();
  }

  void crop() async {
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
        '-i "${_storedVideoOne.path}" -filter:v "crop=240:120:240:120" "$outputPath"'; //change to get parameters for all 4 corners

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
}
