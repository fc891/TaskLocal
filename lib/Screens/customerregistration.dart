//Customer Registration UI/Screen

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:tasklocal/Database/mongoconnection.dart';
import 'package:tasklocal/Database/mongodbmodelcustomer.dart';

void main() => runApp(MaterialApp(
      home: CustomerRegistration(),
    ));

class CustomerRegistration extends StatefulWidget {
  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

//Screen code
class _CustomerRegistrationState extends State<CustomerRegistration> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var usernameController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[500],
        appBar: AppBar(
          title: Text('Customer Account Registration'),
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
              // child: Text(
              //   "",
              //   style: TextStyle(fontSize: 20),
              // ),
            ),
            //First name entry field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: fnameController,
                  decoration: const InputDecoration(labelText: "First Name"),
                )),
            //Last name entry field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: lnameController,
                  decoration: const InputDecoration(labelText: "Last Name"),
                )),
            //Username entry field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                )),
            //Email entry field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Email Address"),
                )),
            //Password entry field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                )),
            //Register account button
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  _insertData(fnameController.text, lnameController.text,
                      usernameController.text, addressController.text, 
                      passwordController.text);
                },
                child: const Text("Register Account"))
          ],
        )));
  }

  //Inserting data to database using data entered in text fields above
  Future<void> _insertData(String fname, String lname, String username,
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

  //Function to clear all text fields
  void _clearAll() {
    fnameController.text = '';
    lnameController.text = '';
    usernameController.text = '';
    addressController.text = '';
    passwordController.text = '';
  }
}
