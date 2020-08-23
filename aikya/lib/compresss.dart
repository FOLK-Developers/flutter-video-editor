import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class Compresss extends StatefulWidget {
  File f;

  @override
  _CompresssState createState() => _CompresssState();
}

class _CompresssState extends State<Compresss> {
  Subscription _subscription;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: FlatButton(onPressed: videoPick, child: Text("press"))),
    );
  }

  void videoPick() async {
    PickedFile file = await _picker.getVideo(source: ImageSource.gallery);

    print(file.path);
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    print("done");
    setState(() {});
  }
}
