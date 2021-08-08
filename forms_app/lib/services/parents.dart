import 'dart:convert';
import 'package:http/http.dart' as http;

class Parents {
  Map? parents;
  int? statusCode;

  Future<void> getParents() async {
    var url = Uri.parse('http://10.0.2.2:5000/api/parents/all');
    var response = await http.get(
      url,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    parents = jsonDecode(response.body);
    statusCode = response.statusCode;

    
  }
}
