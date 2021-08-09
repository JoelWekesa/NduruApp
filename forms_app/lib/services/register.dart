import 'dart:convert';
import 'package:http/http.dart' as http;

class userRegistration {
  String first_name;
  String last_name;
  String email;
  String phone;
  String password;
  String? national_id;
  String? student_id;
  String? attached_to;
  int? statusCode;
  Map? data;

  userRegistration({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone,
    required this.password,
    this.national_id,
    this.student_id,
    this.attached_to,
  });

  Future<void> registerUser() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/users/register');
    var body = {
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "phone": phone,
      "national_id": national_id,
      "student_id": student_id,
      "attached_to": attached_to,
      "password": password,
    };

    var response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body);

    statusCode = response.statusCode;
    data = jsonDecode(response.body);
    print(data);
  }
}
