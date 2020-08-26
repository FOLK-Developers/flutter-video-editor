import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'crope.dart';
import 'crops.dart';
import 'package:video_trimmer/video_trimmer.dart';
// import 'compress.dart';
import 'compresss.dart';
import 'merge.dart';
import 'finaltrim.dart';

void main() => runApp(HomeApp());

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VideoEditor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final Trimmer _trimmer = Trimmer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Editor"),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          // childAspectRatio: 1.0,
          padding: EdgeInsets.only(
            top: 150,
            left: 40,
            right: 40,
          ),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: [
            SizedBox.fromSize(
              // size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color(0xff2b4570), // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () async {
                      File file = await ImagePicker.pickVideo(
                        source: ImageSource.gallery,
                      );
                      if (file != null) {
                        await _trimmer.loadVideo(videoFile: file);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return TrimmerView(_trimmer);
                        }));
                      }
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.video_library, size: 40), // icon
                        Text("Trim"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              // size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color(0xffa37a74), // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Crops();
                      }));
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.crop, size: 40), // icon
                        Text("Crop"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              // size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color(0xffabd0db), // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Merge();
                      }));
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.music_video, size: 40), // icon
                        Text("Merge"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              // size: Size(100, 100), // button width and height
              child: ClipOval(
                child: Material(
                  color: Color(0xffe49273), // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Compresss();
                      }));
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.rotate_90_degrees_ccw, size: 40), // icon
                        Text("Compress"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
