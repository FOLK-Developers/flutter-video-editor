import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(HomeApp());
// import 'dart:io';
// import 'dart:math';
// import 'package:aikya/textover.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'filter.dart';
// import 'video.dart';
// import 'crops.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// import 'compresss.dart';
// import 'merge.dart';
// import 'package:video_player/video_player.dart';
// import 'finaltrim.dart';

// class HomeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'VideoEditor',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final Trimmer _trimmer = Trimmer();
//   static final FlutterFFprobe _probe = FlutterFFprobe();
//   double duration = 0;
//   MediaQueryData qd;
//   var n = new Random().nextInt(1000);
//   String b = "Save To Cloud";

//   List<File> video = [];
//   Widget _video() {
//     print("RIDDHIJAIN");

//     // // VideoPlayerController controller;
//     print(video);
//     return Container(
//       color: Colors.black,
//       height: (qd.size.height * 13) / 20,
//       //   child: VideoApp(video.last),
//       // );
//       child: Center(
//         // child: Expanded(
//         child: ChewieListItem(
//           videoPlayerController: VideoPlayerController.file(video.last),
//         ),
//         // ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     qd = MediaQuery.of(context);
//     // print(ff);
//     return Scaffold(
//       // bottomNavigationBar: BottomNavigationBar(),
//       appBar: AppBar(
//         title: Text("Video Editor"),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () async {
//                 File f = await ImagePicker.pickVideo(
//                   source: ImageSource.gallery,
//                 );
//                 setState(() {
//                   // ff = f;
//                   // video = [];
//                   if (f != null) {
//                     video.add(f);
//                   }
//                 });
//               }),
//           IconButton(
//               icon: Icon(Icons.undo),
//               onPressed: () {
//                 setState(() {
//                   // ff = null;
//                   video = [];
//                 });
//               }),
//         ],
//       ),
//       body: Column(children: [
//         video.length != 0
//             ? Container(
//                 color: Colors.black,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     RaisedButton(
//                       color: Colors.grey,
//                       onPressed: () {
//                         GallerySaver.saveVideo(video.last.path);
//                         print("videosaved");
//                       },
//                       child: Text("Save to Gallery"),
//                     ),
//                     RaisedButton(
//                       color: Colors.grey,
//                       // onPressed: trim,
//                       onPressed: () async {
//                         duration = await dur(video.last.path);
//                         if (duration > 15) {
//                           _showMyDialog();
//                         } else {
//                           fire();
//                         }
//                       },
//                       // onPressed: _showMyDialog,
//                       child: Text(b),
//                     )
//                   ],
//                 ),
//               )
//             : Container(
//                 color: Colors.black,
//               ),
//         video.length != 0
//             ? _video()
//             : Container(
//                 color: Colors.black,
//                 height: (qd.size.height * 13) / 20,
//                 width: double.infinity,
//                 child: Center(
//                   child: Text(
//                     "Please Select Video",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//         Expanded(
//           child: Container(
//             color: Colors.black,
//             child: GridView.count(
//               crossAxisCount: 5,
//               childAspectRatio: 1.0,
//               padding: EdgeInsets.only(
//                 left: 20,
//                 right: 20,
//               ),
//               crossAxisSpacing: 20.0,
//               children: [
//                 SizedBox.fromSize(
//                   // size: Size(50, 50), // button width and height
//                   child: ClipOval(
//                     child: Material(
//                       color: Color(0xff2b4570), // button color
//                       child: InkWell(
//                         splashColor: Colors.green, // splash color
//                         onTap: () async {
//                           File file = video.last;
//                           if (file != null) {
//                             await _trimmer.loadVideo(videoFile: file);
//                             final File tf = await Navigator.of(context)
//                                 .push(MaterialPageRoute(builder: (context) {
//                               return TrimmerView(_trimmer);
//                             }));
//                             setState(() {
//                               if (tf != null) {
//                                 // ff = tf;
//                                 video.add(tf);
//                               }
//                             });
//                           }
//                         },
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Icon(Icons.video_library, size: 20), // icon
//                             Text("Trim"), // text
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox.fromSize(
//                   // size: Size(100, 100), // button width and height
//                   child: ClipOval(
//                     child: Material(
//                       color: Color(0xffa37a74), // button color
//                       child: InkWell(
//                         splashColor: Colors.green, // splash color
//                         onTap: () async {
//                           File f4 = video.last;
//                           if (f4 != null) {
//                             final File t4 = await Navigator.of(context)
//                                 .push(MaterialPageRoute(builder: (context) {
//                               return Crops(video.last);
//                             }));
//                             setState(() {
//                               if (t4 != null) {
//                                 video.add(t4);
//                               }
//                             });
//                           }
//                         }, // button pressed
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Icon(Icons.crop, size: 20), // icon
//                             Text("Crop"), // text
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox.fromSize(
//                   // size: Size(100, 100), // button width and height
//                   child: ClipOval(
//                     child: Material(
//                       color: Color(0xffabd0db), // button color
//                       child: InkWell(
//                         splashColor: Colors.green, // splash color
//                         onTap: () async {
//                           File f3 = video.last;
//                           if (f3 != null) {
//                             final File t3 = await Navigator.of(context)
//                                 .push(MaterialPageRoute(builder: (context) {
//                               return Merge(video.last);
//                             }));
//                             setState(() {
//                               if (t3 != null) {
//                                 video.add(t3);
//                               }
//                             });
//                           }
//                         }, // button pressed
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Icon(Icons.music_video, size: 20), // icon
//                             Text("Merge"), // text
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox.fromSize(
//                   // size: Size(100, 100), // button width and height
//                   child: ClipOval(
//                     child: Material(
//                       color: Color(0xff2b4570), // button color
//                       child: InkWell(
//                         splashColor: Colors.green, // splash color
//                         onTap: () async {
//                           File f5 = video.last;
//                           if (f5 != null) {
//                             final File t3 = await Navigator.of(context)
//                                 .push(MaterialPageRoute(builder: (context) {
//                               // return Filter();
//                               return Filter(f5);
//                             }));
//                             setState(() {
//                               if (t3 != null) {
//                                 video.add(t3);
//                               }
//                             });
//                           }
//                         }, // button pressed
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Icon(Icons.filter, size: 20), // icon
//                             Text("FILTER"), // text
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox.fromSize(
//                   // size: Size(100, 100), // button width and height
//                   child: ClipOval(
//                     child: Material(
//                       color: Color(0xffa37a74), // button color
//                       child: InkWell(
//                         splashColor: Colors.green, // splash color
//                         onTap: () async {
//                           File f5 = video.last;
//                           if (f5 != null) {
//                             final File t3 = await Navigator.of(context)
//                                 .push(MaterialPageRoute(builder: (context) {
//                               // return Filter();
//                               return Textover(f5);
//                             }));
//                             setState(() {
//                               if (t3 != null) {
//                                 video.add(t3);
//                               }
//                             });
//                           }
//                         }, // button pressed
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Icon(Icons.text_format, size: 20), // icon
//                             Text("TEXT"), // text
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   void fire() async {
//     setState(() {
//       b = 'Loading..';
//     });

//     File f2 = video.last;
//     if (f2 != null) {
//       final File tt = await Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) {
//         return Compresss(video.last);
//       }));
//       setState(() {
//         if (tt != null) {
//           video.add(tt);
//         }
//       });
//       File file = new File(video.last.path);

//       String link;
//       final StorageReference firestorageRef =
//           FirebaseStorage.instance.ref().child("Videos").child('$n.mp4');

//       firestorageRef.putFile(file).onComplete.then(
//         (storage) async {
//           link = await storage.ref.getDownloadURL();
//           // print(link);
//           // print("Hello");
//           var d = await dur(video.last.path);
//           await getid(link, d);
//           setState(() {
//             b = 'Save To Cloud';
//           });
//         },
//       );
//     }
//   }

//   Future<double> dur(String path) async {
//     Map<dynamic, dynamic> info = await _probe.getMediaInformation(path);
//     // print("hiii");
//     setState(() {
//       duration = info['duration'] / 1000;
//     });
//     return info['duration'] / 1000;
//   }

//   Future<void> getid(String link, double d) async {
//     await Firebase.initializeApp();
//     await FirebaseFirestore.instance.collection('Videos').add({
//       'URL': link,
//       'time': Timestamp.now().millisecondsSinceEpoch,
//       'duration': d,
//     }).then((value) => print("Video Added"));
//   }

//   Future<void> _showMyDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Uplaod To Cloud'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Video greater than 15 cannot be Uploaded'),
//                 Text('Would you like to TRIM It?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('YES'),
//               // onPressed: trim,
//               onPressed: () async {
//                 // await trim().then()
//                 Navigator.of(context).pop();
//                 trim();
//               },
//             ),
//             FlatButton(
//               child: Text('NO,Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> trim() async {
//     duration = await dur(video.last.path);
//     if (duration > 15.0) {
//       final appDir = await syspaths.getExternalStorageDirectory();
//       String rawDocumentPath = appDir.path;
//       String k = "ot" + "$n" + ".mp4";
//       final outputPath1 = '$rawDocumentPath/$k';

//       final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
//       setState(() {
//         b = "Triming";
//       });
//       String commandToExecute =
//           '-i ${video.last.path} -ss 00:00:00 -t 00:00:15 -async 1 $outputPath1';
//       // '-i ${_storedVideoTwo.path} -vf "scale=$w1:$h1:force_original_aspect_ratio=increase,setsar=1:1,crop=$w1:$h1" $outputPath1';

//       _flutterFFmpeg.execute(commandToExecute).then((rc) {
//         if (rc == 0) {
//           setState(() {
//             File t = new File(outputPath1);
//             video.add(t);
//             fire();
//           });
//         } else {
//           b = 'error';
//         }
//         print("FFmpeg process exited with rc $rc");
//       });
//     } else {
//       fire();
//     }
//   }
// }
