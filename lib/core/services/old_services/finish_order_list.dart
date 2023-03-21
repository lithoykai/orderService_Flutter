import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../../../utils/constants.dart';
import '../../models/old_models/finish_order.dart';
import '../../models/old_models/orders.dart';

class FinishOrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<FinishOrder> _items = [];
  List<FinishOrder> get items => [..._items];
  List<FinishOrder> get listShow => [...items];

  FinishOrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  onChanged(String value) {
    List<FinishOrder> _lisTemp;
    if (value.isNotEmpty) {
      _lisTemp = _items
          .where(
            (e) => e.nameClient.toString().toLowerCase().contains(
                  value.toLowerCase(),
                ),
          )
          .toList();

      _items = _lisTemp;
    } else {
      loadFinishedOrder();
    }

    notifyListeners();
  }

  Future<void> loadFinishedOrder() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.URL_ORDER_FINISHED}.json'),
    );

    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      print(orderData);
      _items.add(
        FinishOrder(
          id: orderId,
          nameClient: orderData['nameClient'],
          description: orderData['description'],
          adressClient: orderData['adressClient'],
          loginPPOE: orderData['loginPPOE'],
          passwordPPOE: orderData['passwordPPOE'],
          priority: Pri.values.elementAt(orderData['priority']),
          type: Type.values.elementAt(orderData['type']),
          rede: orderData['rede'],
          ctoBox: orderData['ctoBox'],
          port: orderData['port'],
          popInternet: orderData['popInternet'],
          signalClient: orderData['signalClient'],
          signalStreet: orderData['signalStreet'],
          dateTime: orderData['dateTime'],
        ),
      );
    });
    _items = items.reversed.toList();
    notifyListeners();
  }

  int get itemsCount {
    return items.length;
  }

  Future<void> saveOrderFinished(Map<String, Object> data, Orders order) async {
    bool hasRede = data['rede'] != null;
    bool hasPort = data['port'] != null;
    bool hasPopInternet = data['popInternet'] != null;
    bool hasSignalClient = data['signalClient'] != null;
    bool hasSignalStreet = data['signalStreet'] != null;
    bool hasDescription = data['description'] != null;

    FinishOrder orderFinished = FinishOrder(
      id: order.id,
      nameClient: order.nameClient,
      adressClient: order.adressClient,
      loginPPOE: order.loginPPOE ?? 'Não informado.',
      passwordPPOE: order.passwordPPOE ?? 'Não informado.',
      priority: order.priority,
      type: order.type,
      dateTime: DateTime.now().toIso8601String(),
      ctoBox: data['ctoBox'] as int,
      rede: hasRede ? data['rede'] as int : 0,
      port: hasPort ? data['port'] as int : 0,
      popInternet:
          hasPopInternet ? data['popInternet'] as String : 'Não informado.',
      signalClient: hasSignalClient ? data['signalClient'] as double : 0.0,
      signalStreet: hasSignalStreet ? data['signalStreet'] as double : 0.0,
      description:
          hasDescription ? data['description'] as String : 'Não informado.',
    );
    print(orderFinished.rede);
    print(orderFinished.nameClient);
    print(data['rede']);
    addFinishOrder(orderFinished);
  }

  Future<void> addFinishOrder(FinishOrder orderFinished) async {
    final response = await http.post(
      Uri.parse('${Constants.URL_ORDER_FINISHED}.json'),
      body: jsonEncode(
        {
          "nameClient": orderFinished.nameClient,
          "description": orderFinished.description ?? '',
          "adressClient": orderFinished.adressClient,
          "loginPPOE": orderFinished.loginPPOE ?? '',
          "passwordPPOE": orderFinished.passwordPPOE ?? '',
          "priority": orderFinished.priority.index,
          "type": orderFinished.type.index,
          "rede": orderFinished.rede ?? 0,
          "ctoBox": orderFinished.ctoBox ?? 0,
          "port": orderFinished.port ?? 0,
          "popInternet": orderFinished.popInternet ?? '',
          "signalClient": orderFinished.signalClient ?? 0.0,
          "signalStreet": orderFinished.signalStreet ?? 0.0,
          "dateTime": orderFinished.dateTime,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(
      FinishOrder(
        id: orderFinished.id,
        nameClient: orderFinished.nameClient,
        description: orderFinished.description ?? '',
        adressClient: orderFinished.adressClient,
        loginPPOE: orderFinished.loginPPOE ?? '',
        passwordPPOE: orderFinished.passwordPPOE ?? '',
        priority: orderFinished.priority,
        type: orderFinished.type,
        rede: orderFinished.rede ?? 0,
        ctoBox: orderFinished.ctoBox ?? 0,
        port: orderFinished.port ?? 0,
        popInternet: orderFinished.popInternet ?? '',
        signalClient: orderFinished.signalClient ?? 0.0,
        signalStreet: orderFinished.signalStreet ?? 0.0,
        dateTime: orderFinished.dateTime,
      ),
    );

    notifyListeners();
  }
}
