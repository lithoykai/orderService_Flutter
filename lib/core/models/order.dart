import 'package:orders_project/core/models/company_client.dart';
import 'package:orders_project/core/models/employee.dart';

class Order {
  String id;
  String problem;
  CompanyClient client;
  Employee technical;

  Order({
    required this.id,
    required this.problem,
    required this.client,
    required this.technical,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      client: json['client'],
      problem: json['problem'],
      technical: json['technical'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'problem': problem,
        'client': client.toJson(),
        'technical': technical.toJson(),
      };
}
