import 'package:http/http.dart' as http;
import 'dart:convert';

class providerServices {
  String id;
  Map? data;
  int? statusCode;

  providerServices({required this.id});

  Future<void> getServices() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/services/all/$id');
    var response = await http.get(url);
    data = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
