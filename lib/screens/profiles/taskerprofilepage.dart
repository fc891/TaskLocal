// ignore_for_file: prefer_const_constructor

//Contributors: Bill

import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tasklocal/screens/profiles/taskereditprofile.dart';
import 'package:tasklocal/screens/profiles/taskertaskinfopage.dart';
import 'package:tasklocal/screens/profiles/taskeruploadedmedia.dart';
import 'package:tasklocal/screens/profiles/taskertaskcategory.dart';
import 'package:tasklocal/screens/profiles/taskinfo.dart';
import 'package:tasklocal/screens/profiles/settingspage.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;
import 'package:tasklocal/screens/profiles/uploadmediapage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//Bill's Tasker Profile Page Screen
class TaskerProfilePage extends StatefulWidget {
  const TaskerProfilePage({super.key});
  @override
  State<TaskerProfilePage> createState() => _TaskerProfilePageState();
}

enum UrlType { IMAGE, VIDEO, UNKNOWN }

//Bill's Tasker Profile Page Screen
class _TaskerProfilePageState extends State<TaskerProfilePage> {
  String username = "Testlocal123";
  String firstname = "First";
  String lastname = "Last";
  String date = 'dd-MM-yyyy';
  int taskscompleted = 0;
  double rating = 5.0;
  final dB = FirebaseStorage.instance;
  String defaultProfilePictureURL =
      "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";
  late String profilePictureURL;
  bool _hasProfilePicture = false;
  bool runOnce = true;
  int numMediaUploaded = 0;
  int taskCategories = 0;
  List<String> mediaList = [];
  List<String> taskCategoryList = [];

  bool _taskCategoriesSelected = false;
  bool _uploadedMediaSelected = false;
  bool _taskHistorySelected = true;

  //Lists to store supported image/video extensions
  List<String> imageExtensions = ["jpg", "jpeg", "png", "gif"];
  List<String> videoExtensions = ["mp4", "mov"];
  File? videoThumbnail;

  //List to store all media as File type
  List<File> mediaFileList = [];

  PlatformFile? selected;

  //WIP
  //Bill's get user's info using testid (username right now)
  void getUserInfo(String testid) async {
    var collection = FirebaseFirestore.instance.collection('Taskers');
    var docSnapshot = await collection.doc(testid).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    setState(() {
      username = data['username'];
      firstname = data['first name'];
      lastname = data['last name'];
    });
  }

  //Bill's get user's profile picture using id
  void getProfilePicture(String id) async {
    try {
      final ref = dB.ref().child("profilepictures/$id/profilepicture.jpg");
      final url = await ref.getDownloadURL();
      setState(() {
        profilePictureURL = url;
      });
      _hasProfilePicture = true;
      globals.checkProfilePictureTasker =
          false; //Set to false after one check so that this function does not run multiple times
    } catch (err) {
      _hasProfilePicture = false;
      globals.checkProfilePictureTasker =
          false; //Set to false after one check so that this function does not run multiple times
    }
  }

  //Bill's get user's join date using id
  void getJoinDate(String id) async {
    var collection = FirebaseFirestore.instance.collection('Taskers');
    var docSnapshot = await collection.doc(id).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    try {
      if (data['joindate'] != null) {
        date = data['joindate'];
      } else if (data['joindate'] == null) {
        DateFormat joindateformat = DateFormat('MM-dd-yyyy');
        DateTime joindate = DateTime(2024, 2, 15);
        date = joindateformat.format(joindate);
      }
    } catch (err) {
      date = "error";
    }
  }

  //WIP
  //Bill's get user's number of requested tasks completed using id
  void getTasksCompleted(String id) async {
    taskscompleted = 10;
  }

  //Bill's get user's task categories using id
  void getTaskCategories(String id) async {
    taskCategories = 0;
    globals.checkCategories = false;

    //Getting instance of tasker doc
    //Get all task categories tasker instance is signed up for and insert to taskCategoryList list
    await firebaseFirestore
        .collection("Taskers")
        .doc(id)
        .collection("Signed Up Tasks")
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          String taskCat = docSnapshot.id;
          taskCategoryList.add(taskCat);
          taskCategories += 1;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    //print(taskCategoryList);
  }

  //Bill's get links of tasker's uploaded media using id
  void getUploadedMedia(String id) async {
    mediaList = [];
    mediaFileList = [];
    numMediaUploaded = 0;
    globals.checkMedia =
        false; //Set to false after checking media so that app does not continuously check (set to True after tasker uploads new media)
    final storageRef =
        dB.ref().child("taskermedia/$id"); //Folder in Firebase storage
    final listResult = await storageRef.listAll(); //Convert media to link
    // for (var prefix in listResult.prefixes) {
    //   final url = await prefix.getDownloadURL();
    //   mediaList[numMediaUploaded] = url;
    //   numMediaUploaded += 1;
    // }
    for (var item in listResult.items) {
      //Loop through all files found in Firebase storage folder
      final url = await item.getDownloadURL();
      setState(() {
        mediaList.add(
            url); //All files under folder are converted to link and added to mediaList array for later use
      });

      var type = getUrlType(url); //Get file type via extension
      if (type == UrlType.IMAGE || type == UrlType.UNKNOWN) {
        //Adding images as files to list (not used)
        File addToList = File(url);
        setState(() {
          mediaFileList.add(addToList);
          numMediaUploaded += 1;
        });
      } else if (type == UrlType.VIDEO) {
        //Adding video thumbnails as files to list (used)
        File addToList = await getVideoThumbnail(
            url); //Calling function to convert link to a file to display video thumbnail
        setState(() {
          mediaFileList.add(addToList);
          numMediaUploaded += 1;
        });
      }
    }
  }

  //Generate thumbnail for video, return video thumbnail as File
  Future<File> getVideoThumbnail(String path) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 100,
      quality: 25,
    );
    File file = File(fileName!);
    return file;
  }

  //Get URL type of file
  UrlType getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (imageExtensions.contains(typeString)) {
      return UrlType.IMAGE;
    }
    if (videoExtensions.contains(typeString)) {
      return UrlType.VIDEO;
    } else {
      return UrlType.UNKNOWN;
    }
  }

  //Bill's function to run all getters above to initialize variables
  void runGetters() async {
    var current = FirebaseAuth.instance
        .currentUser!; //Use to get the info of the currently logged in user
    String testid = current.email!; //Get email of current user
    if (globals.checkProfilePictureTasker) {
      getProfilePicture(testid);
    }
    getUserInfo(testid);
    getJoinDate(testid);
    getTasksCompleted(testid);
    if (globals.checkCategories) {
      getTaskCategories(testid);
    }
    if (globals.checkMedia) {
      getUploadedMedia(testid);
    }
  }

  //Bill's Tasker profile page screen/UI code
  @override
  Widget build(BuildContext context) {
    if (runOnce) {
      globals.checkProfilePictureTasker =
          true; //Check once in case user has a profile page set but did not set a new one
      globals.checkCategories = true;
      globals.checkMedia = true;

      runOnce = false;
    }
    runGetters(); //Run all getter functions
    return Scaffold(
        //Background color of UI
        //backgroundColor: Colors.green[500],
        appBar: AppBar(
          title: Text('${username}\'s profile page'),
          centerTitle: true,
          //backgroundColor: Colors.green[800],
          elevation: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsPage(userType: "Taskers")));
              },
              icon: Icon(
                //Icons.edit_outlined,
                Icons.settings_outlined,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        //Tasker profile picture
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
            child: Column(children: [
              Center(
                  child: Stack(
                children: <Widget>[
                  Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Theme.of(context).colorScheme.secondary)
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: _hasProfilePicture
                                ? NetworkImage(
                                    profilePictureURL) //If user has selected an image from their gallery, display it
                                : NetworkImage(
                                        defaultProfilePictureURL) //If user has NOT selected an image from their gallery, display their original profile picture
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ))),
                ],
              )),
              Center(
                //Username text
                child: Text('$firstname $lastname',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold)),
              ),
              //Display tasker info on profile page (join date, # tasks completed, user rating)
              Column(children: <Widget>[
                Text('Join Date: $date',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
                Text('Tasks Completed: $taskscompleted',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
                Text('User Rating: $rating',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontSize: 16.0,
                    )),
              ]),
              Divider(
                //color: Colors.green[500],
                height: 10.0,
              ),
              Row(children: <Widget>[
                Container(
                    height: 80.0,
                    width: 95.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary),
                      child: Text("View Task Categories",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                      onPressed: () {
                        setState(() {
                          _taskCategoriesSelected = true;
                          _uploadedMediaSelected = false;
                          _taskHistorySelected = false;
                        });
                      },
                    )),
                VerticalDivider(
                  //color: Colors.green[500],
                  width: 30.0,
                ),
                Container(
                    height: 80.0,
                    width: 95.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary),
                      child: Text("View and Upload Media",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                      onPressed: () {
                        setState(() {
                          _taskCategoriesSelected = false;
                          _uploadedMediaSelected = true;
                          _taskHistorySelected = false;
                        });
                      },
                    )),
                VerticalDivider(
                  //color: Colors.green[500],
                  width: 30.0,
                ),
                Container(
                    height: 80.0,
                    width: 95.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary),
                      child: Text("View Task History",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary)),
                      onPressed: () {
                        setState(() {
                          _taskCategoriesSelected = false;
                          _uploadedMediaSelected = false;
                          _taskHistorySelected = true;
                        });
                      },
                    ))
              ]),
              //Divider (line)
              Divider(
                height: 10.0,
                //color: Colors.grey[1500],
              ),
              //List task categories of tasker
              if (_taskCategoriesSelected)
                Text('Task Categories($taskCategories)',
                    style: TextStyle(
                        //color: Colors.white,
                        letterSpacing: 1.3,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              if (_taskCategoriesSelected)
                Divider(
                  height: 10.0,
                  //color: Colors.grey[1500],
                ),
              //Task Categories Display
              if (_taskCategoriesSelected)
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: SizedBox(
                        //height: 100.0,
                        child: ListView.builder(
                            itemCount: taskCategories,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  TaskInfo info =
                                      TaskInfo(taskCategoryList[index], index);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TaskerTaskCategory(
                                                  taskinfo: info)));
                                },
                                title: Text(taskCategoryList[index],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ));
                            }))),
              if (_taskCategoriesSelected)
                Divider(
                  height: 10.0,
                  //color: Colors.green[500],
                ),
              //List uploaded photos and videos by tasker
              if (_uploadedMediaSelected)
                Text('Uploaded Photos and Videos($numMediaUploaded)',
                    style: TextStyle(
                        //color: Colors.white,
                        letterSpacing: 1.3,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              if (_uploadedMediaSelected)
                Divider(
                  height: 10.0,
                  //color: Colors.grey[1500],
                ),
              //Uploaded Photos and Videos Display
              if (_uploadedMediaSelected)
                SizedBox(
                    height: 330.0,
                    width: 400.0,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                        ), //Using GridView to display media in grid manner (instead of list)
                        //crossAxisCount: 3 means there are 3 media in a row (3 boxes)
                        scrollDirection: Axis.vertical,
                        itemCount: numMediaUploaded + 1,
                        itemBuilder: (context, index) {
                          late UrlType
                              type; //Storing file type to differentiate between image/gif and video
                          if (index > 0) {
                            //Getting file type using url extension
                            type = getUrlType(mediaList[index - 1]);
                          }
                          if (index == 0) {
                            //Upload media card will always be displayed first
                            return Card(
                                child: Wrap(children: <Widget>[
                              Container(
                                  height: 108.0,
                                  width: 108.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white.withOpacity(1),
                                        size: 60.0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadMediaPage()));
                                      })),
                            ]));
                          } else if (index != 0 && //Images, GIFs, and other
                              (type == UrlType.IMAGE ||
                                  type == UrlType.UNKNOWN)) {
                            return Card(
                                child: Wrap(children: <Widget>[
                              Container(
                                  height: 108.0,
                                  width: 108.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(mediaList[index - 1]),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.camera,
                                        color: Colors.green.withOpacity(
                                            0)), //Transparent icon to put button over image without covering it
                                    onPressed: () {
                                      TaskInfo info = TaskInfo(
                                          mediaList[index - 1], index - 1);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskerUploadedMedia(
                                                      taskinfo: info)));
                                    },
                                  )),
                            ]));
                          } else if (index != 0 && type == UrlType.VIDEO) {
                            //Videos (displaying as a thumbnail with play button over it)
                            return Card(
                                child: Wrap(children: <Widget>[
                              Container(
                                  height: 108.0,
                                  width: 108.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          FileImage(mediaFileList[index - 1]),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(1),
                                      size: 80.0,
                                    ), //Play icon to show video
                                    onPressed: () {
                                      TaskInfo info = TaskInfo(
                                          mediaList[index - 1], index - 1);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskerUploadedMedia(
                                                      taskinfo: info)));
                                    },
                                  )),
                            ]));
                          }
                        })),
              if (_uploadedMediaSelected)
                Divider(
                  height: 10.0,
                  //color: Colors.green[500],
                ),
              //List history of tasks that tasker has completed
              if (_taskHistorySelected)
                Text('Task History',
                    style: TextStyle(
                        //color: Colors.white,
                        letterSpacing: 1.3,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              if (_taskHistorySelected)
                Divider(
                  height: 10.0,
                  //color: Colors.grey[1500],
                ),
              //Task history display
              if (_taskHistorySelected)
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: SizedBox(
                        //height: 100.0,
                        child: ListView.builder(
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  TaskInfo info = TaskInfo(
                                      "Task History", index); //Placeholder
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskerTaskInfoPage(
                                              //Change to tasker specific later
                                              taskinfo: info)));
                                },
                                title: Text("test$index",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                              ));
                            }))),
              if (_taskHistorySelected)
                Divider(
                  height: 20.0,
                  //color: Colors.green[500],
                ),
            ])));
  }
}
