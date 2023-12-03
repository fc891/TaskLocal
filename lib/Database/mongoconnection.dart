import 'dart:developer';
import 'package:tasklocal/mongodbmodel.dart';

import 'constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoConnection {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONNECTION_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(MONGO_TEST_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<String> insert(Mongodbmodel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      }
      else {
        return "Something went wrong while inserting data";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }  
  }
}
