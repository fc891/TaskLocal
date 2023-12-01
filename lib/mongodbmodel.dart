import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Mongodbmodel mongodbmodelFromJson(String str) => Mongodbmodel.fromJson(json.decode(str));

String mongodbmodelToJson(Mongodbmodel data) => json.encode(data.toJson());

class Mongodbmodel {
    ObjectId id;
    String firstName;
    String lastName;
    String address;

    Mongodbmodel({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.address,
    });

    factory Mongodbmodel.fromJson(Map<String, dynamic> json) => Mongodbmodel(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
    };
}