import 'dart:convert';
import 'package:http/http.dart' as http;

class activateAccount {
  String email;
  String code;
  Map? data;
  int? statusCode;

  activateAccount({required this.email, required this.code});

  Future<void> accountActivation() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/users/activate');
    var body = {
      "email": email,
      "code": code,
    };

    var response = await http.put(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body);

    data = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
