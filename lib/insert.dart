import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:tasklocal/Database/mongoconnection.dart';
import 'package:tasklocal/mongodbmodel.dart';

class MongoDbInsert extends StatefulWidget {
  MongoDbInsert({Key? key}) : super(key: key);

  @override
  _MongoDbInsertState createState() => _MongoDbInsertState();
}

class _MongoDbInsertState extends State<MongoDbInsert> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Insert Data",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: fnameController,
                  decoration: const InputDecoration(labelText: "First Name"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: lnameController,
                  decoration: const InputDecoration(labelText: "Last Name"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: usernameController,
                  // minLines: 3,
                  // maxLines: 5,
                  decoration: const InputDecoration(labelText: "Username"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: addressController,
                  // minLines: 3,
                  // maxLines: 5,
                  decoration: const InputDecoration(labelText: "Email Address"),
                )),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _insertData(fnameController.text, lnameController.text,
                      usernameController.text, addressController.text);
                },
                child: const Text("Insert Data"))
          ],
        )));
  }

  Future<void> _insertData(
      String fname, String lname, String username, String address) async {
    var _id = mongo_dart.ObjectId();
    final data = Mongodbmodel(
        id: _id,
        firstName: fname,
        lastName: lname,
        username: username,
        address: address);
    var result = await MongoConnection.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID " + _id.$oid)));
    _clearAll();
  }

  void _clearAll() {
    fnameController.text = '';
    lnameController.text = '';
    usernameController.text = '';
    addressController.text = '';
  }
}
