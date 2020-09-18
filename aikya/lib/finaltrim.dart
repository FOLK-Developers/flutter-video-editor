// import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/storage_dir.dart';
import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/video_viewer.dart';
import 'dart:io';
import 'dart:math';
// import 'package:firebase_storage/firebase_storage.dart';

class TrimmerView extends StatefulWidget {
  final Trimmer _trimmer;

  TrimmerView(this._trimmer);
  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  double _startValue = 0.0;
  double _endValue = 0.0;
  var n = new Random().nextInt(1000);

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await widget._trimmer
        .saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      storageDir: StorageDir.externalStorageDirectory,
    )
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
        actions: [
          IconButton(
            icon: Icon(Icons.radio),
            onPressed: _progressVisibility
                ? null
                : () async {
                    _saveVideo().then(
                      (outputPath) {
                        print('OUTPUT PATH: $outputPath');
                        File file = new File(outputPath);
                        Navigator.of(context).pop(
                          file,
                        );
                        // GallerySaver.saveVideo(outputPath);
                        // final snackBar =
                        //     SnackBar(content: Text('Video Saved successfully'));
                        // Scaffold.of(context).showSnackBar(snackBar);
                      },
                    );
                  },
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                // Column(
                //   children: [
                //     SizedBox(
                //       height: 20,
                //     ),
                //     RaisedButton(
                //       color: Colors.yellow,
                //       onPressed: _progressVisibility
                //           ? null
                //           : () async {
                //               _saveVideo().then((outputPath) {
                //                 print('OUTPUT PATH: $outputPath');
                //                 GallerySaver.saveVideo(outputPath);
                //                 final snackBar = SnackBar(
                //                     content: Text('Video Saved successfully'));
                //                 Scaffold.of(context).showSnackBar(snackBar);
                //               });
                //             },
                //       child: Text(
                //         "Save to Gallery",
                //         textAlign: TextAlign.center,
                //         style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     RaisedButton(
                //       color: Colors.yellow,
                //       onPressed: _progressVisibility
                //           ? null
                //           : () async {
                //               _saveVideo().then((outputPath) {
                //                 File file = new File(outputPath);
                //                 final StorageReference firestorageRef =
                //                     FirebaseStorage.instance
                //                         .ref()
                //                         .child("Videos")
                //                         .child('$n.mp4');

                //                 firestorageRef
                //                     .putFile(file)
                //                     .onComplete
                //                     .then((storage) async {
                //                   String link =
                //                       await storage.ref.getDownloadURL();
                //                   print(link);
                //                   final snackBar = SnackBar(
                //                       content:
                //                           Text('Video Saved successfully'));
                //                   Scaffold.of(context).showSnackBar(snackBar);
                //                 });
                //               });
                //             },
                //       child: Text(
                //         "Save to Firebase",
                //         textAlign: TextAlign.center,
                //         style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                //       ),
                //     ),
                //   ],
                // ),
                Expanded(
                  child: VideoViewer(),
                ),
                Center(
                  child: TrimEditor(
                    viewerHeight: 70.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                Center(
                  child: FlatButton(
                    child: _isPlaying
                        ? Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                    onPressed: () async {
                      bool playbackState =
                          await widget._trimmer.videPlaybackControl(
                        startValue: _startValue,
                        endValue: _endValue,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
