import 'dart:developer';
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
}
