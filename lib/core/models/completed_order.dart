import 'package:orders_project/core/models/battery.dart';
import 'package:orders_project/core/models/battery_place.dart';
import 'package:orders_project/core/models/nobreak.dart';

class CompletedOrder {
  String id;
  String employeeID;
  String clientID;
  Battery battery;
  BatteryPlace place;
  Nobreak nobreak;

  CompletedOrder({
    required this.id,
    required this.employeeID,
    required this.clientID,
    required this.battery,
    required this.nobreak,
    required this.place,
  });

  factory CompletedOrder.fromJson(Map<String, dynamic> json, String id) {
    return CompletedOrder(
        id: id,
        employeeID: json['employeeID'] ?? 'Não informado.',
        clientID: json['clientID'] ?? 'Não informado.',
        battery: Battery.fromJson(json['battery']),
        nobreak: Nobreak.fromJson(json['nobreak']),
        place: BatteryPlace.fromJson(json['place']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'battery': battery.toJson(),
        'nobreak': nobreak.toJson(),
        'place': place.toJson(),
        'clientID': clientID,
        'employeeID': employeeID,

      };
}
