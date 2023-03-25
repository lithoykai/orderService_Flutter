import 'package:orders_project/core/models/company_client.dart';
import 'package:orders_project/core/models/employee.dart';

class Order {
  String id;
  String problem;
  String clientID;
  String technicalID;

  Order({
    required this.id,
    required this.problem,
    required this.clientID,
    required this.technicalID,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      clientID: json['clientID'],
      problem: json['problem'],
      technicalID: json['technicalID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'problem': problem,
        'clientID': clientID,
        'technicalID': technicalID,
      };
}
