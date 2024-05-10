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
import 'package:tasklocal/screens/profiles/completedtask.dart';
import 'package:tasklocal/screens/profiles/settingspage.dart';
import 'package:tasklocal/screens/profiles/profilepageglobals.dart' as globals;
import 'package:tasklocal/screens/profiles/uploadmediapage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasklocal/screens/rate_and_review/review_page.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

//Bill's Tasker Profile Page Screen
class TaskerProfilePage extends StatefulWidget {
  const TaskerProfilePage(
      {super.key, required this.userEmail, required this.isOwnProfilePage});
  final String userEmail;
  final bool isOwnProfilePage;
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
  String email = '';
  int taskscompleted = 0;
  double rating = 0.0;
  String ratingDisplayed = "N/A";
  int numberReviews = 0;
  final dB = FirebaseStorage.instance;
  String defaultProfilePictureURL =
      "https://firebasestorage.googleapis.com/v0/b/authtutorial-a4202.appspot.com/o/profilepictures%2Ftasklocaltransparent.png?alt=media&token=31e20dcc-4b9a-41cb-85ed-bc82166ac836";
  late String profilePictureURL;
  bool _hasProfilePicture = false;
  bool runOnce = true;
  int numMediaUploaded = 0;
  int taskCategories = 0;
  List<String> mediaList = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> taskCompletedList = [];
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

  //Bill's get user's info using testid (email)
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

  //Bill's get user's rating-related information using id (email)
  void getUserRating(String id) async {
    var collection = FirebaseFirestore.instance.collection('Taskers');
    var docSnapshot = await collection.doc(id).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    try {
      rating = data['rating'];
      numberReviews = data['numberReviews'];
      //If the current tasker user has any reviews at all, display, otherwise keep as N/A
      if ((rating != 0.0 && numberReviews != 0) && (!rating.isNaN && !numberReviews.isNaN)) {
        ratingDisplayed = data['rating'].toString();
      }
    } catch (err) {
      //If 'rating' field not found, set a default one for the tasker
      print("$id has no ratings yet, setting to 0.0 (default)");
      FirebaseFirestore.instance
          .collection('Taskers')
          .doc(id)
          .set({'rating': 0.0}, SetOptions(merge: true)).then((value) {
      });
      //If 'numberReviews' field not found, set a default one for the tasker
      FirebaseFirestore.instance
          .collection('Taskers')
          .doc(id)
          .set({'numberReviews': 0}, SetOptions(merge: true)).then((value) {
        numberReviews = data['numberReviews'];
      });
      //If 'overallRating' field not found, set a default one for the tasker
      FirebaseFirestore.instance
          .collection('Taskers')
          .doc(id)
          .set({'overallRating': 0}, SetOptions(merge: true)).then((value) {});
    }
  }

  //Bill's get user's profile picture using id (email)
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

  //Bill's get user's join date using id (email)
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

  //Bill's get user's completed task details and number using id (email)
  void getTasksCompleted(String id) async {
    globals.checkTasks = false;

    //Query all documents under "Completed Tasks" for taskers in database, add to list to display later
    await firebaseFirestore
        .collection("Taskers")
        .doc(id)
        .collection("Completed Tasks")
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          taskCompletedList.add(docSnapshot);
          taskscompleted += 1;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  //Bill's get user's task categories using id (email)
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
  }

  //Bill's get links of tasker's uploaded media using id (email)
  void getUploadedMedia(String id) async {
    mediaList = [];
    mediaFileList = [];
    numMediaUploaded = 0;
    globals.checkMedia =
        false; //Set to false after checking media so that app does not continuously check (set to True after tasker uploads new media)
    final storageRef =
        dB.ref().child("taskermedia/$id"); //Folder in Firebase storage
    final listResult = await storageRef.listAll(); //Convert media to link
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
    email = testid;
    if (widget.isOwnProfilePage == false) {
      testid = widget.userEmail; //Use email passed in
      email = widget.userEmail;
    }
    if (globals.checkProfilePictureTasker) {
      getProfilePicture(testid);
    }
    getUserInfo(testid);
    getJoinDate(testid);
    getUserRating(testid);
    if (globals.checkTasks) {
      getTasksCompleted(testid);
    }
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
    //All functions below are to run once so that it will not continuously check for updates (only run again once something new is added to database)
    if (runOnce) {
      globals.checkProfilePictureTasker =
          true; //Check once in case user has a profile page set but did not set a new one
      globals.checkCategories = true;
      globals.checkMedia = true;
      globals.checkTasks = true;

      runOnce = false;
    }
    runGetters(); //Run all getter functions
    return Scaffold(
        //Appbar
        appBar: AppBar(
          title: Text('@${username}',
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            if (widget.isOwnProfilePage)
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
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReviewsPage(taskerEmail: email)));
                    },
                    child: Text(
                      'User Rating: $ratingDisplayed ($numberReviews)',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 16.0,
                      ),
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
                      child: Text("View Task History",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: _taskHistorySelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              shadows: _taskHistorySelected
                                  ? <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                      ),
                                    ]
                                  : <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        color: Color.fromARGB(0, 0, 0, 0),
                                      ),
                                    ])),
                      onPressed: () {
                        setState(() {
                          _taskCategoriesSelected = false;
                          _uploadedMediaSelected = false;
                          _taskHistorySelected = true;
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
                      child: Text("View Task Categories",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: _taskCategoriesSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              shadows: _taskCategoriesSelected
                                  ? <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                      ),
                                    ]
                                  : <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        color: Color.fromARGB(0, 0, 0, 0),
                                      ),
                                    ])),
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
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: _uploadedMediaSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              shadows: _uploadedMediaSelected
                                  ? <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                      ),
                                    ]
                                  : <Shadow>[
                                      Shadow(
                                        offset: Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        color: Color.fromARGB(0, 0, 0, 0),
                                      ),
                                    ])),
                      onPressed: () {
                        setState(() {
                          _taskCategoriesSelected = false;
                          _uploadedMediaSelected = true;
                          _taskHistorySelected = false;
                        });
                      },
                    )),
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
                                // onTap: () {
                                //   TaskInfo info =
                                //       TaskInfo(taskCategoryList[index], index);
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               TaskerTaskCategory(
                                //                   taskinfo: info)));
                                // },
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
                Text('Uploaded Media($numMediaUploaded)',
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
                          if (index == 0 && widget.isOwnProfilePage == false) {
                            return Card(
                                child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child:
                                        Text("$username's Uploaded Media:")));
                          } else if (index == 0 && widget.isOwnProfilePage) {
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
                            itemCount: taskscompleted,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  CompletedTask info = CompletedTask(
                                      taskCompletedList[index]
                                          .get("customer email"),
                                      taskCompletedList[index]
                                          .get("customer first name"),
                                      taskCompletedList[index]
                                          .get("customer last name"),
                                      taskCompletedList[index]
                                          .get("customer username"),
                                      taskCompletedList[index]
                                          .get("description"),
                                      taskCompletedList[index].get("location"),
                                      taskCompletedList[index].get("pay rate"),
                                      taskCompletedList[index]
                                          .get("start date"),
                                      taskCompletedList[index]
                                          .get("task category"),
                                      index + 1); //Placeholder
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskerTaskInfoPage(
                                              //Change to tasker specific later
                                              taskinfo: info)));
                                },
                                title: Text(
                                    "${taskCompletedList[index].get("task category")}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                subtitle: Text(
                                    "@${taskCompletedList[index].get("customer username")} (${taskCompletedList[index].get("start date")})",
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
