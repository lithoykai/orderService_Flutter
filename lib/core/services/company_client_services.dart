import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
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
    FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

    try {
      final ref = databaseInstance.ref();
      final snapshotData = await ref.child('clients').get();
      if (snapshotData.exists) {
        Map data = snapshotData.value as Map;
        data.forEach((clientId, clientData) {
          CompanyClient _companyClient = CompanyClient.fromJson(
            clientData as Map,
            clientId,
          );
          _clients.add(_companyClient);
        });
      }
    } catch (error) {
      throw Exception('Falha em carregar os clients.');
    }
    notifyListeners();
  }
}
