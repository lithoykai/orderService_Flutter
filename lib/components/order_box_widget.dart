import 'package:flutter/material.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';

import '../core/models/order.dart';

class OrderBoxWidget extends StatelessWidget {
  final Order order;
  const OrderBoxWidget(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<CompanyClientServices>(context);
    return ListTile(
      title: Text(
          // order.client.name,
          // style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          'Nome do cliente'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.problem),
          Text(client.clients.map((e) {
            e.id == order.clientID;
          }).toString() // order.client.address,
              ),
        ],
      ),
      trailing: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
        onPressed: () {
          print(order.technicalID);
          Navigator.pushNamed(context, AppRoutes.COMPLETED_ORDER_PAGE);
        },
        icon: const Icon(
          Icons.forward,
          color: Colors.green,
        ),
        label: const Text(
          'Finalizar.',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
