import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:orders_project/core/models/battery.dart';
import 'package:orders_project/core/models/battery_place.dart';
import 'package:orders_project/core/models/completed_order.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/core/models/nobreak.dart';
import '../../data/dummy_data.dart';
import '../../utils/constants.dart';
import 'firebase_services.dart';

class CompletedOrderServices with ChangeNotifier {
  CompletedOrderServices(this._token, this._items);
  final String _token;
  List<CompletedOrder> _items = [];
  List<CompletedOrder> get items => [..._items];
  int indexToSwitch = 0;

  int switchPageForm() {
    notifyListeners();
    return indexToSwitch += 1;
  }

// Get CompletedOrders from Firebase to _items;
  Future<void> fetchCompletedOrdersData() async {
    final response = await http
        .get(Uri.parse('${Constants.URL_ORDER_COMPLETED}.json?auth=$_token'));

    if (response.body == 'null') return;

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((orderId, orderData) {
        CompletedOrder _completedOrder = CompletedOrder(
          id: orderId,
          clientID: orderData['clientID'],
          employeeID: orderData['employeeID'],
          battery: Battery.fromJson(
            orderData['battery'],
          ),
          nobreak: Nobreak.fromJson(orderData['nobreak']),
          place: BatteryPlace.fromJson(
              orderData['place'], orderData['place']['id']),
        );

        _items.add(_completedOrder);
      });
    } else {
      throw Exception('Falha em carregar as ordens finalizadas.');
    }
    notifyListeners();
  }

// Salve CompletedOrderData to Firebase and _items;
// Currently, It's just save dummy_data to firebase
  // Future<void> saveData() async {
  //   final response = await http.post(
  //     Uri.parse('${Constants.URL_ORDER_COMPLETED}.json'),
  //     body: jsonEncode(_completedOrder.toJson()),
  //   );
  // }

  Future<void> addDataInFirebase(CompletedOrder completedOrder) async {
    Map<String, dynamic> orderJson = completedOrder.toJson();
    FirebaseServices()
        .addDataInFirebase(orderJson, Constants.URL_ORDER_COMPLETED, _token);

    CompletedOrder jsonData =
        CompletedOrder.fromJson(orderJson, completedOrder.id);
    _items.add(jsonData);
    notifyListeners();
  }
}
