// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//Bill's Uploaded Media Screen
class UploadMediaPage extends StatefulWidget {
  const UploadMediaPage({super.key});
  State<UploadMediaPage> createState() => _UploadMediaPageState();
}

enum UrlType { IMAGE, VIDEO, UNKNOWN }

//Bill's Tasker Upload Media Screen
class _UploadMediaPageState extends State<UploadMediaPage> {
  bool hasMediaSelected = false;
  PlatformFile? selected;

  //Allow user to select media to upload from their device
  Future selectMedia() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    setState(() {
      selected = result.files.first;
      hasMediaSelected = true;
    });
  }

  //Upload user's media to Firebase Storage under taskermedia/{their email address}/{file name}
  Future uploadMedia() async {
    UploadTask? task;
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String id = current.email!; //Get email of current user

    final filePath = 'taskermedia/$id/${selected!.name}';
    final fileToUpload = File(selected!.path!);

    final ref = firebaseStorage.ref().child(filePath);
    setState(() {
      task = ref.putFile(fileToUpload);
    });

    final snapshot = await task!.whenComplete(() {});

    setState(() {
      task = null;
      globals.checkMedia = true;
      hasMediaSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Background color of UI
      //backgroundColor: Colors.green[500],
      //UI Appbar (bar at top of screen)
      appBar: AppBar(
        title: Text('Upload Media'),
        centerTitle: true,
        //backgroundColor: Colors.green[800],
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(children: [
          if (selected != null)
            //Allowing user to preview their selected image
            Flexible(
                child: Container(
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Image.file(
                      File(selected!.path!),
                      width: 500.0,
                      height: 500.0,
                      fit: BoxFit.cover,
                    ))),
          const SizedBox(height: 20.0),
          //Image details
          if (selected != null)
            Text(selected!.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.0,
                  fontSize: 16.0,
                )),
          const SizedBox(height: 20.0),
          //Select media button
          ElevatedButton(
              child: Text("Select Media", style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await selectMedia();
              }),
          const SizedBox(height: 20.0),
          //Upload media button (only display once user selects an image)
          if (hasMediaSelected)
            ElevatedButton(
                child: const Text("Upload Media", style: TextStyle(color: Colors.black)),
                onPressed: () async {
                  if (selected != null) {
                    await uploadMedia();
                    print("Successfully uploaded!");
                    Navigator.pop(context);
                  } else if (selected == null) {
                    print("Null value, not uploading");
                  }
                }),
        ]),
      ),
    );
  }
}
