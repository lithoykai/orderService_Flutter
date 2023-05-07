import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:provider/provider.dart';

class FirebaseServices with ChangeNotifier {
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

  Future<void> fetchAllData(BuildContext context) async {
    await Provider.of<CompanyClientServices>(context, listen: false)
        .fetchData();
    await Provider.of<EmployeeServices>(context, listen: false).fetchData();
    await Provider.of<OrderService>(context, listen: false).fetchOrdersData();

    notifyListeners();
  }
}
