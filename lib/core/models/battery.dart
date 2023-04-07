import 'dart:io';

enum BatteryType { estacionaria, selada, litio }

class Battery {
  final String id;
  final String rightPlace;
  final BatteryType whatType;
  final String rightPlaceImage;
  final String manufacture;
  final String capacity;
  final String model;
  final int bank;
  final int batteryForBank;
  final Charger charger;
  final DateTime manufacturingDate;
  bool hasBreaker = false;

  Battery({
    required this.id,
    required this.rightPlace,
    required this.rightPlaceImage,
    required this.manufacture,
    required this.capacity,
    required this.model,
    required this.bank,
    required this.batteryForBank,
    required this.charger,
    required this.manufacturingDate,
    required this.hasBreaker,
    required this.whatType,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      id: json['id'],
      rightPlace: json['rightPlace'],
      rightPlaceImage: json['rightPlaceImage'],
      manufacture: json['manufacture'],
      capacity: json['capacity'],
      model: json['model'],
      bank: json['bank'],
      batteryForBank: json['batteryForBank'],
      charger: Charger.fromJson(json['charger']),
      manufacturingDate: DateTime.parse(json['manufacturingDate']),
      whatType: json['whatType'],
      hasBreaker: json['hasBreaker'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'rightPlace': rightPlace,
        'rightPlaceImage': rightPlaceImage,
        'whatType': whatType.index,
        'manufacture': manufacture,
        'capacity': capacity,
        'model': model,
        'bank': bank,
        'batteryForBank': batteryForBank,
        'charger': charger.toJson(),
        'manufacturingDate': manufacturingDate.toIso8601String(),
        'hasBreaker': hasBreaker,
      };
}

class Charger {
  final double voltage;
  final double current;

  Charger({
    required this.voltage,
    required this.current,
  });

  factory Charger.fromJson(Map<dynamic, dynamic> json) {
    return Charger(
      voltage: json['voltage'],
      current: json['current'],
    );
  }

  Map<String, dynamic> toJson() => {
        'voltage': voltage,
        'current': current,
      };
}


//-------Baterias
//Enum - Tipo de bateria = estacionária, selada ou litio.
//String - Local adequado observação. <= Foto
//File - path - Local adequado media.
//String - Fabricante das baterias
//String - Capacidade das baterias
//String - Modelo
//int - Quantidade de bancos de baterias
//int - Quantidade de baterias por banco
//Double - tensão do carregador de baterias
//Double - corrente do carregador
//bool - Disjuntor de baterias
//DateTime - Data de fabricação da bateria (datetime)





