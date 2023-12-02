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
