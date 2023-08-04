import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:yo_bray/ulits/urls.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool onError = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.network(Urls.feedbackFile + '${widget.path}')
          ..addListener(() {
            setState(() {});
          })
          ..initialize().then((_) {}).catchError((error) {
            this.onError = true;
          }).whenComplete(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 130,
      child: Center(
        child: onError
            ? Text("Video can't play")
            : _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
      ),
    );
  }

  Widget buildPlay() {
    if (_controller.value.isPlaying)
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _controller.pause();
        },
        child: Container(),
      );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _controller.play();
      },
      child: Container(
        color: Colors.black26,
        child: Center(child: Icon(Icons.play_arrow, color: Colors.white)),
      ),
    );
  }
}
