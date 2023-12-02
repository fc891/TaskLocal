import 'dart:developer';
import 'package:tasklocal/mongodbmodel.dart';

import 'constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoConnection {
  static var db, userCollection;

  static connect() async {
    var db = await Db.create(MONGO_CONNECTION_URL);
    await db.open();
    inspect(db);
    
    var status = db.serverStatus();
    print(status);

    var userCollection = db.collection(MONGO_TEST_COLLECTION);
    await userCollection.insertOne({
      "username": "billtest",
      "name": "Bill",
      "email": "billtest@tasklocal.com"
    });

    print(await userCollection.find().toList());
  }
  static Future<String> insert(Mongodbmodel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess)
        return "Data Inserted";
      else
        return "Something went wrong while inserting data";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }  
  }
}
