import 'package:http/http.dart' as http;
import 'dart:convert';

class newEmergency {
  String location;
  String description;
  String token;
  int? statusCode;
  Map? data;

  newEmergency(
      {required this.location, required this.description, required this.token});

  Future<void> reportEmergency() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/emergencies/add');
    Map body = {
      "location": location,
      "description": description,
    };
    var response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded",
          "access-token": token,
        },
        body: body);

    statusCode = response.statusCode;

    data = jsonDecode(response.body);
  }
}
