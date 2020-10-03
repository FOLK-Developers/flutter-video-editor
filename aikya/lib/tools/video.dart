import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieListItem extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  bool looping;

  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  VideoPlayerController _controlv;
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();

    initial();
  }

  void initial() {
    _controlv = widget.videoPlayerController
      ..initialize().then((_) {
        setState(() {
          chewiee();
        });
      });
  }

  void chewiee() {
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        // aspectRatio: 16 / 11,
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        autoInitialize: true, //see first frame of the video
        looping: widget.looping,
        errorBuilder: (ctx, errorMessage) {
          return Center(
              child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ));
        });

    // print("inCHEWIEsize");
    // print(widget.videoPlayerController.value.size.height);
    // print(widget.videoPlayerController.value.size.width);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.videoPlayerController.value.initialized) {
      initial();
    }
    // // return Transform.scale(
    // //   scale: widget.videoPlayerController.value.aspectRatio,
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.videoPlayerController.value.initialized
            ? AspectRatio(
                aspectRatio: widget.videoPlayerController.value.aspectRatio,
                // child: Flexible(
                //   fit: FlexFit.loose,
                child: Chewie(
                  controller: _chewieController,
                ),
                // ),
              )
            : Container(
                color: Colors.black, child: CircularProgressIndicator()));
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
