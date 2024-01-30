// Tasker Registration UI/Screen

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:tasklocal/Database/mongoconnection.dart';
import 'package:tasklocal/Database/mongodbmodelcustomer.dart';

void main() => runApp(MaterialApp(
      home: TaskerRegistration(),
    ));

class TaskerRegistration extends StatefulWidget {
  @override
  _TaskerRegistrationState createState() => _TaskerRegistrationState();
}

class _TaskerRegistrationState extends State<TaskerRegistration> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[500],
        appBar: AppBar(
          title: Text('Tasker Account Registration'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
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
                  decoration: const InputDecoration(labelText: "Username"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Email Address"),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                )),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _insertTaskerData(fnameController.text, lnameController.text,
                      usernameController.text, addressController.text,
                      passwordController.text);
                },
                child: const Text("Register Account"))
          ],
        )));
  }

  Future<void> _insertTaskerData(String fname, String lname, String username,
      String address, String password) async {
    var _id = mongo_dart.ObjectId();
    final data = Mongodbmodelcustomer(
        id: _id,
        firstName: fname,
        lastName: lname,
        username: username,
        address: address,
        password: password);
    var result = await MongoConnection.insertCustomerData(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID " + _id.$oid)));
    _clearAll();
  }

  void _clearAll() {
    fnameController.text = '';
    lnameController.text = '';
    usernameController.text = '';
    addressController.text = '';
    passwordController.text = '';
  }
}