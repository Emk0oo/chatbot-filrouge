import 'dart:convert';
import 'package:http/http.dart' as http;

class Univers {
  Future<List<dynamic>> getAllUnivers(String? token) async {
    var url = Uri.parse('https://mds.sprw.dev/universes');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load data univers');
    }
  }

  Future<void> createUnivers(String token, String name) async {
    var url = Uri.parse('https://mds.sprw.dev/universes');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create univers');
    }
  }
}
