import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orders_project/core/models/company_client.dart';
import 'package:orders_project/core/models/employee.dart';
import 'package:orders_project/core/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/utils/constants.dart';

import 'firebase_services.dart';

class OrderService with ChangeNotifier {
  // static final List<Order> _newOrders = [];

  final String _token;
  final String _userId;
  final List<Order> _items = [];
  List<Order> get items => [..._items];
  int get itemsCount => _items.length;

  OrderService([
    this._token = '',
    this._userId = '',
  ]);

  // Get Orders from Firebase to _items;
  Future<void> fetchOrdersData() async {
    _items.clear();

    final response = await http.get(Uri.parse('${Constants.URL_ORDER}.json'));

    if (response.body == 'null') return;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((orderId, orderData) {
        Order _order = Order(
          id: orderData['id'],
          problem: orderData['problem'],
          client: CompanyClient.fromJson(
              orderData['client'], orderData['client']['id']),
          technical: Employee.fromJson(
              orderData['technical'], orderData['technical']['id']),
        );
        _items.add(_order);
      });
    } else {
      throw Exception('Falha em carregar as ordens finalizadas.');
    }
    notifyListeners();
  }

  Future<void> saveData(Map<String, dynamic> formData) async {
    Order newOrder = Order(
      id: UniqueKey().toString(),
      problem: formData['problem'] as String,
      client: formData['companyNames'] as CompanyClient,
      technical: formData['employee'] as Employee,
    );

    addDataInFirebase(newOrder);
  }

  Future<void> addDataInFirebase(Order order) async {
    Map<String, dynamic> orderJson = order.toJson();
    FirebaseServices().addDataInFirebase(
      orderJson,
      Constants.URL_ORDER,
    );

    Order jsonData = Order(
        id: order.id,
        problem: order.problem,
        client: order.client,
        technical: order.technical);
    _items.add(jsonData);
    notifyListeners();
  }
}
