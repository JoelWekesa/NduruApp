import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestReset {
  String email;
  Map? data;
  int? statusCode;

  RequestReset({required this.email});

  Future<void> requestCode() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/users/resetpassword');
    Map body = {
      "email": email,
    };

    var response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body);

    data = jsonDecode(response.body);
    statusCode = response.statusCode;
    print(response.body);
  }
}
