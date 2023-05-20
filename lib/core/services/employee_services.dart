import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/core/services/firebase_services.dart';
import '../../utils/constants.dart';
import '../models/employee.dart';

class EmployeeServices with ChangeNotifier {
  final String _token;
  final List<Employee> _items = [];
  List<Employee> get items => [..._items];
  int get itemCounts => _items.length;

  EmployeeServices(this._token);

  Future<void> addDataInFirebase(Employee employee) async {
    FirebaseServices().addDataInFirebase(
      employee.toJson(),
      'employees/',
      _token,
    );

    Employee jsonData =
        Employee.fromJson(employee.toJson(), employee.id, employee.userID);
    _items.add(jsonData);
    notifyListeners();
  }

  List<String> get employeesNames {
    return _items.map((e) => e.name).toList();
  }

  Future<void> fetchData() async {
    _items.clear();
    FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

    try {
      final ref = databaseInstance.ref();
      final snapshotData = await ref.child('employees').get();
      if (snapshotData.exists) {
        Map data = snapshotData.value as Map;
        data.forEach((employeeID, employeeData) {
          Employee _employee = Employee.fromJson(
            employeeData as Map,
            employeeID,
            employeeData['userID'],
          );
          _items.add(_employee);
        });
      }
    } catch (error) {
      print(error);
      throw Exception('Falha em carregar os dados dos funcionários.');
    }
    notifyListeners();
  }
}
