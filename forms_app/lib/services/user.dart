import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class getUser {
  String token;
  Map? data;
  int? statusCode;
  getUser({required this.token});

  Future<void> userDetails() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/users/user');
    var response = await http.get(url, headers: {
      "Accept": "*/*",
      "Content-Type": "application/x-www-form-urlencoded",
      "access-token": token,
    });

    data = await jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
