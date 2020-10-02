import 'dart:io';
import 'global.dart' as global;
import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:video_player/video_player.dart';

class TextEditor extends StatefulWidget {
  File video;
  TextEditor(this.video);
  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  TextEditingController name = TextEditingController();

  final scaf = GlobalKey<ScaffoldState>();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  var slider = 20.0;
  int size = 21;
  String x;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    print("final color");
    print(pickerColor);
    // var points = _controller.points;
    // _controller =
    //     SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  // @override
  // void didChangeDependencies() {
  //   print("Independice");
  //   x = name.text;
  //   print(x);
  //   super.didChangeDependencies();
  // }

  Widget player() {
    print("RIDDHIJAIN");
    print("player wale xandY ${global.y}");
    print(widget.video);
    // String x = name.text;
    // print(x);
    return Container(
      color: Colors.black,
      height: 500,
      child: Stack(
        children: [
          // // global.g
          // //     ?
          // Positioned(
          //     child: Container(height: 10, width: 10, color: Colors.orange),
          //     left: global.gx,
          //     top: global.gy),
          // // : Container(),
          Center(
            child: MyWidget(widget.video, name, slider, pickerColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("global     x    ${global.x}");
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: new AppBar(
        title: Text("Select features"),
        // backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context,
                  {"text": name.text, "color": pickerColor, "size": size});
            },
          ),
          IconButton(
            icon: Icon(Icons.brush),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      // color: pickerColor,
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Select'),
                      onPressed: () {
                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
              print("curr colr");
              print(currentColor);
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // child: ListView(
            children: <Widget>[
              player(),
              // Text("X: ${global.x}       Y: ${global.y}"),
              Text("Enter Text!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: "Insert:)",
                  hintStyle:
                      TextStyle(color: Colors.black, fontSize: size.toDouble()),
                  alignLabelWithHint: true,
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.text,
                maxLines: 3,
                style: TextStyle(
                  fontSize: size.toDouble(),
                  color: pickerColor,
                ),
                // autofocus: true,
              ),
              SizedBox(height: 5),
              Text(
                "Size",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 2,
                  ),
                  Text('20', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      // color: Colors.black,
                      child: Slider(
                          label: "Size: $size",
                          divisions: 10,
                          value: slider,
                          min: 20.0,
                          max: 70.0,
                          onChangeEnd: (v) {
                            setState(() {
                              size = v.toInt();
                            });
                          },
                          onChanged: (v) {
                            setState(() {
                              slider = v;
                              print(v.toInt());
                              size = v.toInt();
                            });
                          }),
                    ),
                  ),
                  Text('70', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // SingleChildScrollView(
              //   child: ColorPicker(
              //     // color: pickerColor,
              //     pickerColor: pickerColor,
              //     onColorChanged: changeColor,
              //     showLabel: true,
              //     pickerAreaHeightPercent: 0.8,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Row(
      //   children: [
      //     new FlatButton(
      //         onPressed: () {
      //           showDialog(
      //             context: context,
      //             child: AlertDialog(
      //               title: const Text('Pick a color!'),
      //               content: SingleChildScrollView(
      //                 child: ColorPicker(
      //                   // color: pickerColor,
      //                   pickerColor: pickerColor,
      //                   onColorChanged: changeColor,
      //                   showLabel: true,
      //                   pickerAreaHeightPercent: 0.8,
      //                 ),
      //               ),
      //               actions: <Widget>[
      //                 FlatButton(
      //                   child: const Text('Select'),
      //                   onPressed: () {
      //                     setState(() => currentColor = pickerColor);
      //                     Navigator.of(context).pop();
      //                   },
      //                 ),
      //               ],
      //             ),
      //           );
      //           print("curr colr");
      //           print(currentColor);
      //         },
      //         color: Colors.black,
      //         child: new Text(
      //           "Pick Color",
      //           style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //               // fontSize: 22,
      //               color: Colors.white),
      //         )),
      //   ],
      // ),
    );
  }
}

class MyWidget extends StatefulWidget {
  File video;
  TextEditingController name;
  Color color;
  double x;

  MyWidget(this.video, this.name, this.x, this.color);
  @override
  State<StatefulWidget> createState() {
    return new MyWidgetState();
  }
}

class MyWidgetState extends State<MyWidget> {
  double posx = 100.0;
  double posy = 100.0;

  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.path)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    // print('${details.localPosition}');

    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
      global.y = localOffset.dy.toInt();
      global.x = localOffset.dx.toInt();
      global.g = true;
      global.gx = details.globalPosition.dx;
      global.gy = details.globalPosition.dy;
    });
    print("X: $posx , Y: ${global.y}");
    // print("Xoffset: ${details.localPosition} , X: $posx ");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: Stack(
        children: [
          _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller))
              : Container(
                  color: Colors.black, child: CircularProgressIndicator()),
          new Positioned(
            child: widget.name.text == ''
                ? CircleAvatar(radius: 5.0, backgroundColor: Colors.red)
                : Text(
                    widget.name.text,
                    style: TextStyle(fontSize: widget.x, color: widget.color),
                  ),
            // child: Text(widget.name.text),
            // child: CircleAvatar(radius: 10.0, backgroundColor: Colors.orange),
            left: posx,
            top: posy,
          ),
        ],
      ),
    );
    // child: _controller.value.initialized
    //     ? AspectRatio(
    //         aspectRatio: _controller.value.aspectRatio,
    //         child: VideoPlayer(_controller))
    //     : Container(
    //         color: Colors.black, child: CircularProgressIndicator()));

    // child: ChewieListItem(
    //   videoPlayerController: VideoPlayerController.file(widget.video),
    // ),);

    // return new GestureDetector(
    //   onTapDown: (TapDownDetails details) => onTapDown(context, details),
    //   child: Container(color: Colors.green, height: 30, width: 90),
    // );
  }
}

// import 'dart:math';

// import 'package:aikya/text.dart';
// import 'package:aikya/video.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:tapioca/src/video_editor.dart';
// import 'package:tapioca/tapioca.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';

// class Textover extends StatefulWidget {
//   File v;
//   Textover(this.v);

//   @override
//   _TextoverState createState() => _TextoverState();
// }

// class _TextoverState extends State<Textover> {
//   String _platformVersion = 'Unknown';
//   final navigatorKey = GlobalKey<NavigatorState>();
//   File _video;
//   var _loading = false;
//   var n = new Random().nextInt(1000);
//   List<File> vp = [];
//   bool isLoading = false;
//   String val;

//   GlobalKey key = GlobalKey();
//   // Container(key: key,...); //add key to your widget, which position you need to find

//   @override
//   void initState() {
//     super.initState();
//     vp.add(widget.v);
//     initPlatformState();
//   }

//   Widget player() {
//     print("RIDDHIJAIN");

//     print(vp.last);
//     return Container(
//       color: Colors.black,
//       height: 500,
//       child: Center(
//         child: ChewieListItem(
//           videoPlayerController: VideoPlayerController.file(vp.last),
//         ),
//       ),
//     );
//   }

//   Future<void> initPlatformState() async {
//     String platformVersion;
//     try {
//       platformVersion = await VideoEditor.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//       _video = widget.v;
//     });
//   }

//   Color x = Color(0xff443a49);
//   TextEditingController name = TextEditingController();

//   void applyText(var val) async {
//     String o = "ot" + "$n" + ".mp4";
//     setState(() {
//       _loading = true;
//     });
//     var tempDir = await getTemporaryDirectory();
//     final path = '${tempDir.path}/$o';
//     print(val);
//     try {
//       final tapiocaBalls = [
//         TapiocaBall.textOverlay(val['text'], 10, 10, val['size'], val['color']),
//       ];
//       if (_video != null) {
//         final cup = Cup(Content(_video.path), tapiocaBalls);
//         cup.suckUp(path).then((_) async {
//           print("finished");

//           setState(() {
//             vp.add(File(path));
//             _loading = false;
//           });
//         });
//       } else {
//         print("video is null");
//       }
//     } on PlatformException {
//       print("error!!!!");
//     }
//   }

//   MediaQueryData qd;
//   @override
//   Widget build(BuildContext context) {
//     // RenderBox box = key.currentContext.findRenderObject();
//     // Offset position = box.localToGlobal(Offset.zero); //this is global position
//     // double y = position.dy;
//     // double x = position.dx;
//     // print("X :$x ,Y :$y ");
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       home: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: Text('Output'),
//             actions: [
//               IconButton(
//                   icon: Icon(Icons.undo),
//                   onPressed: () {
//                     Navigator.of(context).pop(File(widget.v.path));
//                   }),
//               IconButton(
//                   icon: Icon(Icons.save),
//                   onPressed: () {
//                     Navigator.of(context).pop(File(vp.last.path));
//                   }),
//             ],
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _loading
//                     ? Container(
//                         child: Center(child: CircularProgressIndicator()),
//                         color: Colors.black,
//                         height: 500,
//                         width: double.infinity,
//                       )
//                     : player(),
//                 Text("Selecting text features"),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: name,
//                   decoration: InputDecoration(
//                     hintText: "Insert:)",
//                     hintStyle: TextStyle(
//                       color: Colors.black,
//                       // fontSize: size.toDouble(),
//                     ),
//                     alignLabelWithHint: true,
//                   ),
//                   scrollPadding: EdgeInsets.all(20.0),
//                   keyboardType: TextInputType.text,
//                   maxLines: 3,
//                   style: TextStyle(
//                       // fontSize: size.toDouble(),
//                       // color: pickerColor,
//                       ),
//                   // autofocus: true,
//                 ),
//                 Container(
//                   // color: Colors.black,
//                   child: Row(
//                     children: [
//                       Center(
//                         child: RaisedButton(
//                             child: Text("ADD TEXT"),
//                             color: Colors.white,
//                             textColor: Colors.black,
//                             onPressed: () async {
//                               final value = await Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => TextEditor()));
//                               if (value.toString().isEmpty) {
//                                 print("true");
//                               } else {
//                                 applyText(value);
//                               }
//                             }),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           bottomNavigationBar: ,),
//     );
//   }
// }
//  }
// }
