import 'dart:convert';
import 'package:http/http.dart' as http;

class UserPasswordReset {
  String email;
  String code;
  String password;
  Map? data;
  int? statusCode;

  UserPasswordReset(
      {required this.email, required this.code, required this.password});

  Future<void> resetPass() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/users/resetpassword');
    Map body = {
      "email": email,
      "code": code,
      "password": password,
    };

    var response = await http.put(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body);

    data = jsonDecode(response.body);
    statusCode = response.statusCode;
    print(statusCode);
    print(data);
  }
}
