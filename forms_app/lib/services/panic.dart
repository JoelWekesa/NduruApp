import 'dart:convert';
import 'package:http/http.dart' as http;

class PanicEmergency {
  String location;
  String device;
  Map? data;
  int? statusCode;

  PanicEmergency({required this.location, required this.device});

  Future<void> addPanicEmergency() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/panic/add');
    Map body = {
      "location": location,
      "device": device,
    };

    var response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body);

    statusCode = response.statusCode;

    data = jsonDecode(response.body);
  }
}
