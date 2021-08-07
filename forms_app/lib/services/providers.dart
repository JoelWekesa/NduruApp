import 'package:http/http.dart' as http;
import 'dart:convert';

class getProviders {
  Map? providers;
  int? statusCode;

  Future<void> allProviders() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/providers/all');
    var response = await http.get(url);
    providers = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
