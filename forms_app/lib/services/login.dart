import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class authLogin {
  String email;
  String password;
  Map? data;
  int? statusCode;

  authLogin({required this.email, required this.password});

  Future<void> userLogin() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/users/login');
    Map body = {
      "email": email,
      "password": password,
    };

    var response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body);
    data = jsonDecode(response.body);
    statusCode = response.statusCode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (statusCode == 200) {
      await prefs.setString("access-token", data!["token"]);
    }
  }
}
