import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'button.dart';

class Compress extends StatefulWidget {
  @override
  _CompressState createState() => _CompressState();
}

class _CompressState extends State<Compress> {
  var _buttonText = 'Record Video';
  VideoPlayerController _videoPlayerController;
  File _video;
  File _storedVideoOne;
  File _storedVideoTwo;
  File _outputFile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            RecordVideoButton(_recordVideo, _buttonText),
            Container(
              child: Column(
                children: <Widget>[
                  if (_video != null)
                    _videoPlayerController.value.initialized
                        ? AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayer(_videoPlayerController),
                          )
                        : Container()
                  else
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        color: Colors.lightBlue,
                        onPressed: () {
                          _pickVideo();
                        },
                        child: Text("View Video From Gallery"),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _videoMerger() async {
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    final appDir = await syspaths.getExternalStorageDirectory();
    String rawDocumentPath = appDir.path;
    final outputPath = '$rawDocumentPath/output.mp4';

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    String commandToExecute =
        '-y -i ${_storedVideoOne.path} -i ${_storedVideoTwo.path} -filter_complex \'[0:0][1:0]concat=n=2:v=1:a=0[out]\' -map \'[out]\' $outputPath';
    _flutterFFmpeg
        .execute(commandToExecute)
        .then((rc) => print("FFmpeg process exited with rc $rc"));
  }

// This funcion will helps you to pick a Video File
  void _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  void _recordVideo() async {
    ImagePicker.pickVideo(source: ImageSource.camera)
        .then((File recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          _buttonText = 'Saving in Progress...';
        });
        GallerySaver.saveVideo(recordedVideo.path).then((_) {
          setState(() {
            _buttonText = 'Video Saved!\n\nClick to Record New Video';
            if (_storedVideoOne == null) {
              _storedVideoOne = recordedVideo;
              print('video 1 stored');
            } else {
              _storedVideoTwo = recordedVideo;
              print('video 2 stored');
              _videoMerger();
            }
          });
        });
      }
    });
  }
}
