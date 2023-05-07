import 'package:flutter/material.dart';
import 'package:orders_project/core/models/battery.dart';
import 'package:orders_project/core/models/battery_place.dart';
import 'package:orders_project/core/models/nobreak.dart';

class CompletedOrder with ChangeNotifier {
  String id;
  String title;
  DateTime finishDate;
  String employeeID;
  String clientID;
  Battery battery;
  BatteryPlace place;
  Nobreak nobreak;

  CompletedOrder({
    required this.id,
    required this.title,
    required this.finishDate,
    required this.employeeID,
    required this.clientID,
    required this.battery,
    required this.nobreak,
    required this.place,
  });

  factory CompletedOrder.fromJson(Map<String, dynamic> json, String id) {
    return CompletedOrder(
        id: id,
        title: json['title'],
        finishDate: DateTime.parse(json['finishDate']),
        employeeID: json['employeeID'] ?? 'Não informado.',
        clientID: json['clientID'] ?? 'Não informado.',
        battery: Battery.fromJson(json['battery']),
        nobreak: Nobreak.fromJson(json['nobreak']),
        place: BatteryPlace.fromJson(json['place']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'finishDate': finishDate.toIso8601String(),
        'battery': battery.toJson(),
        'nobreak': nobreak.toJson(),
        'place': place.toJson(),
        'clientID': clientID,
        'employeeID': employeeID,
      };
}
