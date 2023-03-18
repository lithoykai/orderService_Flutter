import 'orders.dart';

class FinishOrder extends Orders {
  double? signalClient = 0.0;
  double? signalStreet = 0.0;
  int? rede = 0;
  int? ctoBox = 0;
  int? port = 0;
  String? popInternet = '';

  FinishOrder({
    required String id,
    required String nameClient,
    required String adressClient,
    required Pri priority,
    required Type type,
    required String description,
    required String loginPPOE,
    required String passwordPPOE,
    required this.signalClient,
    required this.signalStreet,
    required String dateTime,
    required this.rede,
    required this.ctoBox,
    required this.port,
    required this.popInternet,
  }) : super(
          // date: date,
          id: id,
          nameClient: nameClient,
          adressClient: adressClient,
          priority: priority,
          type: type,
          loginPPOE: loginPPOE,
          passwordPPOE: passwordPPOE,
          description: description,
          dateTime: dateTime,
        );
}
