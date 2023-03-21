import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/core/services/firebase_services.dart';
import '../../utils/constants.dart';
import '../models/employee.dart';

class EmployeeServices with ChangeNotifier {
  final List<Employee> _items = [];
  List<Employee> get items => [..._items];
  int get itemCounts => _items.length;

  Future<void> addDataInFirebase(Employee employee) async {
    FirebaseServices().addDataInFirebase(
      employee.toJson(),
      Constants.URL_EMPLOYEES,
    );

    Employee jsonData = Employee.fromJson(employee.toJson(), employee.id);
    _items.add(jsonData);
    notifyListeners();
  }

  List<String> get employeesNames {
    return _items.map((e) => e.name).toList();
  }

  Future<void> fetchOrdersData() async {
    _items.clear();

    final response =
        await http.get(Uri.parse('${Constants.URL_EMPLOYEES}.json'));

    if (response.body == 'null') return;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((employeeID, employeeData) {
        Employee _employee = Employee.fromJson(
          employeeData as Map<String, dynamic>,
          employeeID,
        );
        _items.add(_employee);
      });
    } else {
      throw Exception('Falha em carregar as ordens finalizadas.');
    }
    print(_items);
    notifyListeners();
  }
}
