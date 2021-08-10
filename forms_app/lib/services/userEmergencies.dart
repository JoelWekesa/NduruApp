import 'dart:convert';
import 'package:http/http.dart' as http;

class UserEmergencies {
  String token;
  Map? data;
  int? statusCode;

  UserEmergencies({required this.token});

  Future<void> retrieveEmergencies() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/emergencies/my/emergencies');
    var response = await http.get(
      url,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded",
        "access-token": token,
      },
    );

    data = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
