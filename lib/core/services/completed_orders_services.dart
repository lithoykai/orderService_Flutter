import 'dart:convert';

import 'package:orders_project/core/models/battery.dart';
import 'package:orders_project/core/models/completed_order.dart';
import 'package:orders_project/core/models/nobreak.dart';
import 'package:orders_project/core/models/place.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';

class CompletedOrderServices {
  Future<void> saveData() async {
    //  CRUD = Create Read Update Delete
    //          post   get  put   delete
    Battery battery = Battery(
      rightPlace: 'rightPlace',
      rightPlaceImage: 'rightPlaceImage',
      manufacture: 'manufacture',
      capacity: 'capacity',
      model: 'model',
      bank: 1,
      batteryForBank: 1,
      chargerVoltage: 1.5,
      chargerCurrent: 1.5,
      manufacturingDate: DateTime.now(),
      hasBreaker: true,
      batteryType: BatteryType.litio,
    );

    Place place = Place(
      cleanPlace: true,
      reverseKey: true,
      inputFrame: false,
      outputFrame: false,
      hasMaterialsClose: true,
    );

    Nobreak nobreak = Nobreak(
      display: true,
      nobreakWasOpened: true,
      hasCommunicationBoard: false,
      inputCurrent: 'inputCurrent',
      outputCurrent: 'outputCurrent',
      outputVoltage: 'outputVoltage',
      inputVoltage: 'inputVoltage',
      frequencyEquip: 'frequencyEquip',
    );

    CompletedOrder _completedOrder = CompletedOrder(
      battery: battery.toJson(),
      nobreak: nobreak.toJson(),
      place: place.toJson(),
    );

    final response = await http.post(
      Uri.parse('${Constants.URL_ORDER_COMPLETED}.json'),
      body: jsonEncode(_completedOrder.toJson()),
    );
  }
}
