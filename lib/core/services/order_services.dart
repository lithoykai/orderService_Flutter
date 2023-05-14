import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:orders_project/core/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/utils/constants.dart';
import 'package:orders_project/utils/db_util.dart';

import 'firebase_services.dart';

class OrderService with ChangeNotifier {
  // static final List<Order> _newOrders = [];

  final String _token;
  final String _userId;
  List<Order> _items = [];
  List<Order> get items => [..._items];
  int get itemsCount => _items.length;

  OrderService(
    this._token,
    this._userId,
    this._items,
  );

  // Get Orders from Firebase to _items;
  Future<void> fetchOrdersData() async {
    _items.clear();

    final dbOrdersList = await DbUtil.getData('orders');
    List databaseListTest;

    databaseListTest = dbOrdersList
        .map(
          (item) => Order(
              id: item['id'],
              title: item['title'],
              firebaseID: item['firebaseID'],
              problem: item['problem'],
              creationDate: DateTime.parse(item['creationDate']),
              deadline: DateTime.parse(item['deadline']),
              clientID: item['clientID'],
              technicalID: item['technicalID']),
        )
        .toList();

    final response = await http.get(
      Uri.parse('${Constants.URL_ORDER}/$_userId.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((orderId, orderData) {
        Order _order = Order(
          id: orderData['id'],
          title: orderData['title'],
          firebaseID: orderId,
          problem: orderData['problem'],
          clientID: orderData['clientID'],
          technicalID: orderData['technicalID'],
          creationDate: DateTime.parse(orderData['creationDate']),
          deadline: DateTime.parse(orderData['deadline']),
        );
        _items.add(_order);
      });
    } else {
      throw Exception('Falha em carregar as ordens finalizadas.');
    }

    _items = items.reversed.toList();

    notifyListeners();
  }

  Future<void> updateData(Order order) async {
    int index = _items.indexWhere((p) => p.id == order.id);
    await FirebaseServices().updateDataInFirebase(
      index: index,
      dataId: order.id,
      items: _items,
      url: Constants.URL_ORDER,
      jsonData: order.toJson(),
    );

    _items[index] = order;
    notifyListeners();
  }

  Future<void> removeOrder(Order order) async {
    int index = _items.indexWhere((e) => e.id == order.id);
    if (index >= 0) {
      final order = _items[index];
      _items.remove(order);
      final response = await http.delete(
        Uri.parse(
            '${Constants.URL_ORDER}/$_userId/${order.firebaseID}.json?auth=$_token'),
      );

      notifyListeners();
    }
  }

  Future<void> saveData(Map<String, dynamic> formData) async {
    // When adding something new via formData, it has no id.
    // So, if it doesn't have an id, it's something new, but if it does, it's something old.

    List ids = _items.map((e) => e.id).toList();
    ids.sort();
    bool hasId = formData['firebaseID'] != null;

    Order newOrder = Order(
      firebaseID:
          hasId ? formData['firebaseID'] : Random().nextDouble().toString(),
      id: Random().nextDouble().toString(),
      problem: formData['problem'] as String,
      title: formData['title'] as String,
      clientID: formData['clientID'] as String,
      technicalID: formData['technicalID'] as String,
      creationDate: formData['creationDate'] as DateTime,
      deadline: formData['deadline'] as DateTime,
    );

    if (hasId) {
      updateData(newOrder);
    } else {
      addData(newOrder);
    }
  }

  Future<void> addData(Order order) async {
    Map<String, dynamic> orderJson = order.toJson();
    FirebaseServices().addDataInFirebase(
        orderJson, '${Constants.URL_ORDER}/${order.technicalID}', _token);

    _items.add(order);
    notifyListeners();
  }
}
