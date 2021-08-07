import 'dart:convert';

import 'package:http/http.dart' as http;

//? Get a users's contact buddies.
class getUserContacts {
  String id;
  String token;
  int? statusCode;
  Map? contacts;
  int? number;

  getUserContacts({required this.id, required this.token});
  Future<void> userContacts() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/contacts/all/$id');
    var response = await http.get(
      url,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded",
        "access_token": token
      },
    );

    statusCode = response.statusCode;
    contacts = jsonDecode(response.body);
    number = contacts!["contacts"].length;
  }
}

//? User to add contact buddies

class addUserContacts {
  String contact_name;
  String contact_phone;
  String contact_location;
  String contact_relationship;
  String token;
  int? statusCode;
  Map? data;

  addUserContacts(
      {required this.contact_name,
      required this.contact_phone,
      required this.contact_location,
      required this.contact_relationship,
      required this.token});

  Future<void> addBuddies() async {
    var body = {
      "contact_name": contact_name,
      "contact_phone": contact_phone,
      "contact_location": contact_location,
      "contact_relationship": contact_relationship,
    };
    var url = Uri.parse('http://10.0.2.2:5000/api/contacts/add');
    var response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded",
          "access_token": token
        },
        body: body);

    statusCode = response.statusCode;

    data = jsonDecode(response.body);
  }
}

//? User to delete contact buddies

class deleteUserContact {
  String id;
  String token;
  int? statusCode;

  deleteUserContact({required this.id, required this.token});

  Future<void> deleteBuddy() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/contacts/delete/$id');
    var response = await http.delete(
      url,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded",
        "access_token": token
      },
    );

    statusCode = response.statusCode;
    print(statusCode);
  }
}

//? User to edit contact buddies list

class editUserContacts {
  String id;
  String token;
  String contact_name;
  String contact_phone;
  String contact_location;
  String contact_relationship;
  int? statusCode;
  Map? data;

  editUserContacts(
      {required this.id,
      required this.token,
      required this.contact_name,
      required this.contact_phone,
      required this.contact_location,
      required this.contact_relationship});

  Future<void> editBuddy() async {
    var body = {
      "contact_name": contact_name,
      "contact_phone": contact_phone,
      "contact_location": contact_location,
      "contact_relationship": contact_relationship,
    };
    var url = Uri.parse('http://10.0.2.2:5000/api/contacts/edit/$id');
    var response = await http.put(
      url,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded",
        "access-token": token
      },
      body: body,
    );

    data = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
