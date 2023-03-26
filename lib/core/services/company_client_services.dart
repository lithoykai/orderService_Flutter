import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orders_project/core/models/company_client.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class CompanyClientServices with ChangeNotifier {
  final String _token;
  final List<CompanyClient> _clients = [];
  List<CompanyClient> get clients => [..._clients];
  int get itemsCount => _clients.length;

  CompanyClientServices(this._token);

  //Add the CompanyClient in Firebase and _clients list
  Future<void> addData(Map<String, dynamic> companyClient) async {
    CompanyClient companyClientJson =
        CompanyClient.fromJson(companyClient, UniqueKey().toString());
    final response = await http.post(
      Uri.parse('${Constants.URL_CLIENTS}.json?auth=$_token'),
      body: jsonEncode(companyClientJson),
    );

    final id = jsonDecode(response.body)['name'];

    CompanyClient jsonData = CompanyClient.fromJson(companyClient, id);
    _clients.add(jsonData);
    notifyListeners();
  }

  List<String> get clientNamesList {
    return _clients.map((e) => e.name).toList();
  }

  // Get CompanyClients from Firebase to _clients;
  Future<void> fetchData() async {
    _clients.clear();

    final response =
        await http.get(Uri.parse('${Constants.URL_CLIENTS}.json?auth=$_token'));

    if (response.body == 'null') return;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((clientId, clientData) {
        CompanyClient _companyClient = CompanyClient.fromJson(
          clientData as Map<String, dynamic>,
          clientId,
        );
        _clients.add(_companyClient);
      });
    } else {
      throw Exception('Falha em carregar os clients.');
    }
    notifyListeners();
  }
}
