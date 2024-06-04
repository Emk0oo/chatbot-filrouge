import 'dart:convert'; // Add this import
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Univers {
  Future<List<dynamic>> getAllUnivers(String? token) async {
    var url = Uri.parse('https://mds.sprw.dev/universes');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // Parse the JSON response into a list
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load data univers');
    }
  }
}
