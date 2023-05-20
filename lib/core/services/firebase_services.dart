import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
    FirebaseDatabase databasInstance = FirebaseDatabase.instance;
    final firebaseRef = databasInstance.ref(_url);
    DatabaseReference newPushData = firebaseRef.push();
    newPushData.set(dataJson);
  }

  Future<void> updateDataInFirebase({
    required int index,
    required String dataId,
    required List items,
    required String url,
    required Map<String, dynamic> jsonData,
  }) async {
    if (index >= 0) {
      DatabaseReference ref = FirebaseDatabase.instance.ref(('$url/$dataId'));
      ref.update(jsonData);
    }
  }

  Future<void> fetchAllData(BuildContext context) async {
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    await Provider.of<CompanyClientServices>(context, listen: false)
        .fetchData();
    await Provider.of<EmployeeServices>(context, listen: false).fetchData();
    await Provider.of<OrderService>(context, listen: false).fetchOrdersData();

    notifyListeners();
  }
}
