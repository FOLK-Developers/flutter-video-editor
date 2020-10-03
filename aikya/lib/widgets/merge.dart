import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_player/video_player.dart';

class Merge extends StatefulWidget {
  File video;
  Merge(this.video);
  @override
  _MergeState createState() => _MergeState();
}

class _MergeState extends State<Merge> {
  File _storedVideoOne;
  File _storedVideoTwo;
  File _scaled;
  VideoPlayerController videoPlayerController1;
  VideoPlayerController videoPlayerController2;
  var h1;
  String b1 = '...';
  var w1;
  var w2;
  var _r = true;

  var isLoading = false;

  var n = new Random().nextInt(10000);

  @override
  void initState() {
    super.initState();
    print("VIDEO1 ka H");

    videoPlayerController1 = VideoPlayerController.file(widget.video)
      ..initialize().then((value) {
        print("VIDEO1 ka H");
        h1 = videoPlayerController1.value.size.height;
        w1 = videoPlayerController1.value.size.width;
        print(h1);
      });

    pick();
  }

  void pick() async {
    File video2 = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (video2 != null && video2.path != null) {
      setState(() {
        _storedVideoTwo = video2;
        print("VIDEO2 ka H");

        print('video 2 stored');

        // merge();
      });
      await dur(widget.video.path, _storedVideoTwo.path);
      setState(() {
        if (audio == true) {
          scale();
        }
      });
    } else {
      Navigator.of(context).pop(File(widget.video.path));
    }
  }

  static final FlutterFFprobe _probe = FlutterFFprobe();
  bool audio = true;

  Future<void> dur(String path1, String path2) async {
    Map<dynamic, dynamic> file1 = await _probe.getMediaInformation(path1);
    print("infooooooooo");
    Map<dynamic, dynamic> file2 = await _probe.getMediaInformation(path2);
    var a1 = file1['streams'].last;
    var a2 = file2['streams'].last;
    var aa1 = a1['type'];
    var aa2 = a2['type'];
    setState(() {
      if (aa1 != 'audio' || aa2 != 'audio') {
        audio = false;
      }
    });
  }

  void scale() async {
    // _storedVideoOne = widget.video;

    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String k = "os" + "$n" + ".mp4";
    final outputPath1 = '$rawDocumentPath/$k';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      isLoading = true;
      b1 = "Scaling...";
    });
    String commandToExecute =
        '-i "${_storedVideoTwo.path}" -vf "scale=$w1:$h1:force_original_aspect_ratio=increase,setsar=1:1,crop=$w1:$h1" "$outputPath1"';
    // '-i ${_storedVideoTwo.path} -filter:v "crop=320:240:320:240" $outputPath1';
    // ' -i ${_storedVideoTwo.path} -vf scale=320:240,setsar=1:1 $outputPath1';

    _flutterFFmpeg.execute(commandToExecute).then((rc) {
      if (rc == 0) {
        setState(() {
          _scaled = File(outputPath1);
          print('$outputPath1....Calling merge');
          // Navigator.of(context).pop(File(outputPath1));
          merge();
        });
      } else {
        setState(() {
          isLoading = false;
          // _r = false;
          print("get lost");
        });
        print("FFmpeg process exited with rc $rc");
      }
    });
  }

  void merge() async {
    _storedVideoOne = widget.video;
    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    String o = "om" + "$n" + ".mp4";
    final outputPath = '$rawDocumentPath/$o';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    setState(() {
      isLoading = true;
      b1 = "Merging..";
    });

    String commandToExecute;
    if (audio == true) {
      commandToExecute =
          ' -i "${_storedVideoOne.path}" -i "${_scaled.path}" -filter_complex \"[0:v]setsar=1[v0]; \[1:v]setsar=1[v1];[v0][0:a][v1][1:a]concat=n=2:v=1:a=1[outv][outa]" \-map "[outv]"  -vsync 2 -map "[outa]" -c:v libx264 -c:a aac -movflags +faststart "$outputPath"'; //PERFECT WITH SOUND
    }
    //else {
    //   commandToExecute =
    //       '-y -i "${_storedVideoOne.path}" -i "${_scaled.path}" -filter_complex \"[0:v]setsar=1[v0]; \[1:v]setsar=1[v1];[0:0][1:0]concat=n=2:v=1:a=0[out]\" -vsync 2 -map \'[out]\' $outputPath'; //workingfine//perfect w/o sound

    // }

    // commandToExecute =

    //     ' -i "${_storedVideoOne.path}" -i "${_scaled.path}" -filter_complex \"[0:v]setsar=1[v0]; \[1:v]setsar=1[v1];[v0][0:a][v1][1:a]concat=n=2:v=1:a=1[outv][outa]" \-map "[outv]"  -vsync 2 -map "[outa]" -c:v libx264 -c:a aac -movflags +faststart "$outputPath"'; //PERFECT WITH SOUND

    // // '-y -i ${_storedVideoOne.path} -i ${_scaled.path} -filter_complex \'[0:0][1:0]concat=n=2:v=1:a=0[out]\' -vsync 2 -map \'[out]\' $outputPath'; //workingfine//perfect w/o sound
    _flutterFFmpeg.execute(commandToExecute)
        // .then((rc) => print("FFmpeg process exited with rc $rc"));
        .then((rc) {
      if (rc == 0) {
        setState(() {
          isLoading = false;
          // GallerySaver.saveVideo(outputPath);
          print('$outputPath');
          _r = true;

          Navigator.of(context).pop(File(outputPath));
        });
      } else {
        setState(() {
          isLoading = false;
          _r = false;
        });
        print("FFmpeg process exited with rc $rc");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return audio
        ? isLoading
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
                      b1,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
              ))
            : _r
                ? Container()
                : Scaffold(
                    body: Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            "ERROR- Please Try again later..",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        )))
        : Scaffold(
            body: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    "ERROR- Videos cannot be merged if no audio..",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )));
  }
}
