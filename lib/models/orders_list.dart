import 'dart:math';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:darq/darq.dart';
import 'package:flutter/cupertino.dart';
import 'package:orders_project/models/orders.dart';

import '../utils/constants.dart';

class OrderList with ChangeNotifier {
  List<Orders> _items = [];
  List<Orders> get items => [..._items];

  Future<void> loadOrder() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.URL_ORDERS}.json?'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(
        Orders(
          id: productId,
          nameClient: productData['nameClient'],
          description: productData['description'],
          adressClient: productData['adressClient'],
          loginPPOE: productData['loginPPOE'],
          passwordPPOE: productData['passwordPPOE'],
          priority: Pri.values.elementAt(productData['priority']),
          type: Type.values.elementAt(productData['type']),
          dateTime: productData['dateTime'],
        ),
      );
    });
    _items = _items
        .orderBy((element) => element.priorityNumber)
        .thenBy((element) => element)
        .toList();
    notifyListeners();
  }

  int get itemsCount {
    return items.length;
  }

  Future<void> saveOrder(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    bool hasLogin = data['loginPPOE'] != null;
    bool hasPassword = data['passwordPPOE'] != null;

    final order = Orders(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      nameClient: data['nameClient'] as String,
      adressClient: data['adressClient'] as String,
      loginPPOE: hasLogin ? data['loginPPOE'] as String : '',
      passwordPPOE: hasPassword ? data['passwordPPOE'] as String : '',
      priority: data['priority'] as Pri,
      type: data['type'] as Type,
      description: data['description'] as String,
      dateTime: DateTime.now().toIso8601String(),
    );
    if (hasId) {
      return updateOrder(order);
    } else {
      return addOrder(order);
    }
  }

  Future<void> updateOrder(Orders order) async {
    int index = _items.indexWhere((p) => p.id == order.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${Constants.URL_ORDERS}/${order.id}.json',
        ),
        body: jsonEncode(
          {
            "nameClient": order.nameClient,
            "description": order.description ?? '',
            "adressClient": order.adressClient,
            "loginPPOE": order.loginPPOE ?? '',
            "passwordPPOE": order.passwordPPOE ?? '',
            "priority": order.priority.index,
            "type": order.type.index,
            "dateTime": order.dateTime,
          },
        ),
      );

      _items[index] = order;
      notifyListeners();
    }
  }

  Future<void> addOrder(Orders order) async {
    final response = await http.post(
      Uri.parse('${Constants.URL_ORDERS}.json'),
      body: jsonEncode(
        {
          "nameClient": order.nameClient,
          "description": order.description ?? '',
          "adressClient": order.adressClient,
          "loginPPOE": order.loginPPOE ?? '',
          "passwordPPOE": order.passwordPPOE ?? '',
          "priority": order.priority.index,
          "type": order.type.index,
          "dateTime": order.dateTime,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(Orders(
      id: order.id,
      nameClient: order.nameClient,
      description: order.description ?? '',
      adressClient: order.adressClient,
      loginPPOE: order.loginPPOE ?? '',
      passwordPPOE: order.passwordPPOE ?? '',
      priority: order.priority,
      type: order.type,
      dateTime: order.dateTime,
    ));
    // _items
    //     .orderBy((element) => element.priorityText)
    //     .thenBy((element) => element)
    //     .toList();
    notifyListeners();
  }

  Future<void> deleteOrder(Orders order) async {
    int index = _items.indexWhere((p) => p.id == order.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
          '${Constants.URL_ORDERS}/${order.id}.json',
        ),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        loadOrder();
        notifyListeners();
      }
    }
  }
}
