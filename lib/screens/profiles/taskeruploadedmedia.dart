// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:video_player/video_player.dart';

//Bill's Tasker Uploaded Media Screen
class TaskerUploadedMedia extends StatefulWidget {
  const TaskerUploadedMedia({super.key, required this.taskinfo});
  State<TaskerUploadedMedia> createState() => _TaskerUploadedMediaState();

  final TaskInfo
      taskinfo; //WIP: convert this to some sort of image/video once implemented in the future
}

enum UrlType { IMAGE, VIDEO, UNKNOWN }

//Bill's Tasker Uploaded Media Screen
class _TaskerUploadedMediaState extends State<TaskerUploadedMedia> {
  // Using video_player.dart reference
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
      widget.taskinfo.taskInfo,
    ))
      ..initialize().then((_) {
        _controller.play();
        setState(() {
          //wip
        });
      });

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  UrlType getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg" || typeString == "png" || typeString == "gif") {
      return UrlType.IMAGE;
    }
    if (typeString == "mp4") {
      return UrlType.VIDEO;
    } else {
      return UrlType.UNKNOWN;
    }
  }

  @override
  Widget build(BuildContext context) {
    String mediaLink = widget.taskinfo.taskInfo;
    int tasknumber = widget.taskinfo.taskNumber + 1;
    UrlType type = getUrlType(mediaLink);
    return Scaffold(
      //Background color of UI
      backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('Uploaded Media#$tasknumber'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(children: [
        Column(children: <Widget>[
          //Display media (Image)
          if(type == UrlType.IMAGE)
          Image(image: NetworkImage(mediaLink)),
          //Display media (Video)
          if(type == UrlType.VIDEO)
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : Container(),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          //Task details
          Text('Task info here',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
                fontSize: 16.0,
              )),
        ]),
      ])),
    );
  }
}
