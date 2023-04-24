import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:orders_project/core/models/battery.dart';
import 'package:orders_project/core/models/battery_place.dart';
import 'package:orders_project/core/models/completed_order.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/core/models/nobreak.dart';
import 'package:orders_project/core/models/order.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import 'firebase_services.dart';
import 'dart:io';

class CompletedOrderServices with ChangeNotifier {
  CompletedOrderServices(this._token, this._items, this.userID);
  Order? orderData;
  Battery? battery;
  BatteryPlace? batteryPlace;
  Nobreak? nobreak;
  final String _token;
  final String userID;
  List<CompletedOrder> _items = [];
  List<CompletedOrder> get items => [..._items];
  int indexToSwitch = 0;
  bool returnToIndexPage = false;

  Future<void> saveBatteryFormData(
      Map<String, dynamic> _batteryForm, File? image) async {
    final imageName = '${orderData?.clientID}.jpg';
    final imageURL = await _uploadImage(image, imageName);
    _batteryForm['rightPlaceImage'] = imageURL ?? 'Imagem não encontrada';
    battery = Battery.fromJson(_batteryForm);
  }

  Future<void> addOrderData(Order order) async {
    orderData = order;
  }

  Future<void> saveBatteryPlaceFormData(
      Map<String, dynamic> _batteryPlaceForm) async {
    batteryPlace = BatteryPlace.fromJson(
      _batteryPlaceForm,
    );
  }

  Future<String?> _uploadImage(File? image, String imageName) async {
    if (image == null) return 'Não funcionou';

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('local_image').child(imageName);
    await imageRef.putFile(image).whenComplete(() => {});
    return await imageRef.getDownloadURL();
  }

  Future<void> saveNobreakFormData(Map<String, dynamic> _nobreakForm) async {
    if (battery == null && batteryPlace == null) {}
    nobreak = Nobreak.fromJson(_nobreakForm);
    await addDataInFirebase();
  }

  Future<CompletedOrder?> saveCompletedOrder() async {
    if (battery == null &&
        batteryPlace == null &&
        nobreak == null &&
        orderData == null) return null;
    CompletedOrder _completedOrder = CompletedOrder(
      id: UniqueKey().toString(),
      employeeID: orderData?.technicalID ?? UniqueKey().toString(),
      clientID: orderData?.clientID ?? UniqueKey().toString(),
      battery: battery!,
      nobreak: nobreak!,
      place: batteryPlace!,
    );
    return _completedOrder;
  }

  int? switchPageForm() {
    if (indexToSwitch == 2) return null;
    notifyListeners();
    return indexToSwitch += 1;
  }

// Get CompletedOrders from Firebase to _items;
  Future<void> fetchCompletedOrdersData() async {
    _items.clear();
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
          place: BatteryPlace.fromJson(orderData['place']),
        );

        _items.add(_completedOrder);
      });
    } else {
      throw Exception('Falha em carregar as ordens finalizadas.');
    }
    notifyListeners();
  }

  Future<void> addDataInFirebase() async {
    CompletedOrder? completedOrder = await saveCompletedOrder();
    Map<String, dynamic> orderJson = completedOrder!.toJson();
    FirebaseServices()
        .addDataInFirebase(orderJson, Constants.URL_ORDER_COMPLETED, _token);
    _items.add(completedOrder);

    battery = null;
    batteryPlace = null;
    nobreak = null;
    notifyListeners();
  }
}
