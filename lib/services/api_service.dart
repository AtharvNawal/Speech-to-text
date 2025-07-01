import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://192.168.1.84:8000/extract'; // Change IP if needed
  static const String baseUrl = 'https://speech-to-text-backend-igpr.onrender.com/extract'; // Change IP if needed


  static Future<Map<String, dynamic>> extractEntities(String text) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': text}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to extract entities');
    }
  }
}
