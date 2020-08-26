import 'package:flutter/material.dart';

class RecordVideoButton extends StatelessWidget {
  final Function recordVideo;
  final String buttonText;

  RecordVideoButton(this.recordVideo, this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        color: Colors.yellow,
        onPressed: recordVideo,
        child: Text(buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
      ),

      // flex: 1,
    );
  }
}
