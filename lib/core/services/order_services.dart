import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:orders_project/core/models/order.dart';

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

  Future<void> fetchOrdersData() async {
    _items.clear();
    FirebaseDatabase databaseInstance = FirebaseDatabase.instance;

    try {
      final ref = databaseInstance.ref();
      final snapshotData = await ref.child('order/$_userId').get();
      if (snapshotData.exists) {
        Map data = snapshotData.value as Map;
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
      }
    } catch (error) {
      throw Exception('Falha em carregar as ordens.');
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
      url: 'order/$_userId',
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
      DatabaseReference ref =
          FirebaseDatabase.instance.ref(("order/$_userId/${order.firebaseID}"));
      ref.remove();

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
    FirebaseServices()
        .addDataInFirebase(orderJson, 'order/${order.technicalID}/', _token);

    _items.add(order);
    notifyListeners();
  }
}
