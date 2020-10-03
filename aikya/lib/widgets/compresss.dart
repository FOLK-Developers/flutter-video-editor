import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
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
  var n = new Random().nextInt(10000);

  @override
  void initState() {
    super.initState();
    compress();
  }

  void compress() async {
    _storedVideoOne = widget.video;
    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "oc" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      isLoading = true;
    });

    String commandToExecute =
        '-i "${_storedVideoOne.path}" -c:v mpeg4 "$outputPath"';
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
        print("FFmpeg process exited with rc $rc");
        setState(() {
          isLoading = false;
        });
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
                  "Compressing...",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
          ))
        : Container();
  }
}
