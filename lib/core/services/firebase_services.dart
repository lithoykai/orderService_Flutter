import 'dart:convert';

import 'package:http/http.dart' as http;


class FirebaseServices {
  Future<void> addDataInFirebase(
      Map<String, dynamic> dataJson, String _url) async {
    final response = await http.post(
      Uri.parse('$_url.json'),
      body: jsonEncode(dataJson),
    );
  }
}
