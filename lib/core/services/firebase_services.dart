import 'dart:convert';

import 'package:http/http.dart' as http;

class FirebaseServices {
  Future<void> addDataInFirebase(
    Map<String, dynamic> dataJson,
    String _url,
    String _token,
  ) async {
    final response = await http.post(
      Uri.parse('$_url.json?auth=$_token'),
      body: jsonEncode(dataJson),
    );
  }

  Future<void> updateDataInFirebase({
    required int index,
    required String dataId,
    required List items,
    required String url,
    required Map<String, dynamic> jsonData,
  }) async {
    if (index >= 0) {
      await http.patch(Uri.parse('$url/$dataId.json'),
          body: jsonEncode(
            {jsonData},
          ));
    }
  }
}
