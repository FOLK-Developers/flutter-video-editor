import 'dart:io';
import '../tools/global.dart' as global;
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

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    print("final color");
    print(pickerColor);
  }

  Widget player() {
    print("player wale xandY ${global.y}");
    print(widget.video);

    return Container(
      color: Colors.black,
      height: 500,
      child: Stack(
        children: [
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
      appBar: new AppBar(
        title: Text("Select features"),
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
            ],
          ),
        ),
      ),
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
            left: posx,
            top: posy,
          ),
        ],
      ),
    );
  }
}
