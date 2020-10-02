import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'compresss.dart';

class Fire extends StatefulWidget {
  File video;
  Fire(this.video);
  @override
  _FireState createState() => _FireState();
}

class _FireState extends State<Fire> {
  double duration;
  File _video;
  String op;
  var n = new Random().nextInt(1000);
  static final FlutterFFprobe _probe = FlutterFFprobe();
  @override
  void initState() {
    // TODO: implement initState
    _video = widget.video;
    trim();
    super.initState();
  }

  void trim() async {
    duration = await dur(widget.video.path);
    if (duration > 15.0) {
      final appDir = await syspaths.getExternalStorageDirectory();
      String rawDocumentPath = appDir.path;
      String k = "ot" + "$n" + ".mp4";
      final outputPath1 = '$rawDocumentPath/$k';

      final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
      setState(() {
        // b = "Triming";
      });
      String commandToExecute =
          '-i ${_video.path} -ss 00:00:00 -t 00:00:15 -async 1 $outputPath1';
      // '-i ${_storedVideoTwo.path} -vf "scale=$w1:$h1:force_original_aspect_ratio=increase,setsar=1:1,crop=$w1:$h1" $outputPath1';

      _flutterFFmpeg.execute(commandToExecute).then((rc) {
        if (rc == 0) {
          setState(() {
            File t = new File(outputPath1);
            // widget.video.add(t);
            _video = t;
            op = outputPath1;
            fire();
          });
        } else {
          // b = 'error';
        }
        print("FFmpeg process exited with rc $rc");
      });
    } else {
      fire();
    }
  }

  void fire() async {
    setState(() {
      // b = 'Loading..';
    });

    File f2 = _video;
    if (f2 != null) {
      final File tt = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return Compresss(_video);
      }));
      setState(() {
        if (tt != null) {
          _video = tt;
        }
      });
      File file = new File(widget.video.path);

      String link;
      final StorageReference firestorageRef =
          FirebaseStorage.instance.ref().child("Videos").child('$n.mp4');

      firestorageRef.putFile(file).onComplete.then(
        (storage) async {
          link = await storage.ref.getDownloadURL();
          // print(link);
          // print("Hello");
          var d = await dur(widget.video.path);
          await getid(link, d);
          setState(() {
            // b = 'Save To Cloud';
            Navigator.of(context).pop(File(op));
          });
        },
      );
    }
  }

  Future<double> dur(String path) async {
    Map<dynamic, dynamic> info = await _probe.getMediaInformation(path);
    // print("hiii");
    setState(() {
      duration = info['duration'] / 1000;
    });
    return info['duration'] / 1000;
  }

  Future<void> getid(String link, double d) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance.collection('Videos').add({
      'URL': link,
      'time': Timestamp.now(),
      'duration': d,
    }).then((value) => print("Video Added"));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
