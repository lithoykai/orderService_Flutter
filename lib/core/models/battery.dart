enum BatteryType { estacionaria, selada, litio }

class Battery {
  final String rightPlace;
  final BatteryType batteryType;
  final String rightPlaceImage;
  final String manufacture;
  final String capacity;
  final String model;
  final int bank;
  final int batteryForBank;
  final double chargerVoltage;
  final double chargerCurrent;
  final DateTime manufacturingDate;
  final bool hasBreaker;

  Battery({
    required this.rightPlace,
    required this.rightPlaceImage,
    required this.manufacture,
    required this.capacity,
    required this.model,
    required this.bank,
    required this.batteryForBank,
    required this.chargerVoltage,
    required this.chargerCurrent,
    required this.manufacturingDate,
    required this.hasBreaker,
    required this.batteryType,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      rightPlace: json['rightPlace'],
      rightPlaceImage: json['rightPlaceImage'],
      manufacture: json['manufacture'],
      capacity: json['capacity'],
      model: json['model'],
      bank: json['bank'],
      batteryForBank: json['batteryForBank'],
      chargerVoltage: json['chargerVoltage'],
      chargerCurrent: json['chargerCurrent'],
      manufacturingDate: json['manufacturingDate'],
      hasBreaker: json['hasBreaker'],
      batteryType: BatteryType.values.elementAt(json['batteryType']),
    );
  }

  Map<String, dynamic> toJson() => {
        'rightPlace': rightPlace,
        'rightPlaceImage': rightPlaceImage,
        'manufacture': manufacture,
        'capacity': capacity,
        'model': model,
        'bank': bank,
        'batteryForBank': batteryForBank,
        'chargerVoltage': chargerVoltage,
        'chargerCurrent': chargerCurrent,
        'manufacturingDate': manufacturingDate.toIso8601String(),
        'hasBreaker': hasBreaker,
        'batteryType': batteryType.index,
      };

  String? get batteryTypeText {
    switch (batteryType) {
      case BatteryType.estacionaria:
        return 'Estacionária';
      case BatteryType.litio:
        return 'Lítio';
      case BatteryType.selada:
        return 'Selada';

      default:
        'Estacionária';
    }
  }
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
//Enum - Disjuntor de baterias (enum yes or not)
//DateTime - Data de fabricação da bateria (datetime)





