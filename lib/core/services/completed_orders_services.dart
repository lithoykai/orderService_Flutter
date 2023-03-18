import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:orders_project/core/models/completed_order.dart';
import 'package:http/http.dart' as http;
import '../../data/dummy_data.dart';
import '../../utils/constants.dart';
import 'firebase_services.dart';

class CompletedOrderServices with ChangeNotifier {
  final List<CompletedOrder> _items = [];
  List<CompletedOrder> get items => [..._items];

// Get CompletedOrders from Firebase to _items;
  Future<void> fetchOrdersData() async {
    final response =
        await http.get(Uri.parse('${Constants.URL_ORDER_COMPLETED}.json'));

    if (response.body == 'null') return;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((orderId, orderData) {
        CompletedOrder _completedOrder =
            CompletedOrder.fromJson(orderData, orderId);

        _items.add(_completedOrder);
      });
    } else {
      throw Exception('Falha em carregar as ordens finalizadas.');
    }
    notifyListeners();
  }

// Salve CompletedOrderData to Firebase and _items;
// Currently, It's just save dummy_data to firebase
  Future<void> saveData() async {
    CompletedOrder _completedOrder = CompletedOrder(
      battery: DummyData.batteryData.toJson(),
      nobreak: DummyData.nobreakData.toJson(),
      place: DummyData.placeData.toJson(),
      id: 'id',
    );

    final response = await http.post(
      Uri.parse('${Constants.URL_ORDER_COMPLETED}.json'),
      body: jsonEncode(_completedOrder.toJson()),
    );
  }

  Future<void> addDataInFirebase(CompletedOrder completedOrder) async {
    Map<String, dynamic> orderJson = completedOrder.toJson();
    FirebaseServices().addDataInFirebase(
      orderJson,
      Constants.URL_ORDER_COMPLETED,
    );

    CompletedOrder jsonData =
        CompletedOrder.fromJson(orderJson, completedOrder.id);
    _items.add(jsonData);
    notifyListeners();
  }
}
