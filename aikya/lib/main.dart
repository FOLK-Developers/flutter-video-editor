// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'FirebaseMessagingD.dart';
// import 'urlrb.dart';
import 'package:video_player/video_player.dart';
import 'video.dart';

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AikyaYouth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApp(),
      // home: Urlrb(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Video player'),
        ),
        body: ListView(
          children: <Widget>[
            ChewieListItem(
              videoPlayerController:
                  VideoPlayerController.asset('videos/sample-mp4-file.mp4'),
              looping: true,
            ),
            // ChewieListItem(
            //   videoPlayerController: VideoPlayerController.network(
            //     'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            //   ),
            //   // looping: true,
            // ),
          ],
        ));
  }
}
