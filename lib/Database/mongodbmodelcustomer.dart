import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Mongodbmodelcustomer mongodbmodelcustomerFromJson(String str) =>
    Mongodbmodelcustomer.fromJson(json.decode(str));

String mongodbmodelcustomerToJson(Mongodbmodelcustomer data) =>
    json.encode(data.toJson());

class Mongodbmodelcustomer {
  ObjectId id;
  String firstName;
  String lastName;
  String username;
  String address;
  String password;

  Mongodbmodelcustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.address,
    required this.password,
  });

  factory Mongodbmodelcustomer.fromJson(Map<String, dynamic> json) =>
      Mongodbmodelcustomer(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        address: json["address"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "address": address,
        "password": password,
      };
}
