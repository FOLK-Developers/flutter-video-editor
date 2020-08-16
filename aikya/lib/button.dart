import 'package:flutter/material.dart';

class RecordVideoButton extends StatelessWidget {
  final Function recordVideo;
  final String buttonText;

  RecordVideoButton(this.recordVideo, this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
          child: SizedBox.expand(
        child: RaisedButton(
          color: Colors.white,
          onPressed: recordVideo,
          child: Text(buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
        ),
      )),
      flex: 1,
    );
  }
}
