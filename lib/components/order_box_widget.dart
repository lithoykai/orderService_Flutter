import 'package:flutter/material.dart';
import 'package:orders_project/core/models/completed_order.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';

import '../core/models/order.dart';

class OrderBoxWidget extends StatelessWidget {
  final Order order;
  const OrderBoxWidget(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final company = Provider.of<CompanyClientServices>(context);
    return ListTile(
      title: Text(
        company.clients
            .firstWhere((element) => element.id == order.clientID)
            .name
            .toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.problem),
          Text(company.clients
                  .firstWhere((element) => element.id == order.clientID)
                  .address
                  .toString() // order.client.address,
              ),
        ],
      ),
      trailing: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
        onPressed: () {
          Provider.of<CompletedOrderServices>(context, listen: false)
              .addOrderData(order);
          Navigator.of(context).pushNamed(
            AppRoutes.COMPLETED_ORDER_PAGE,
            arguments: order,
          );
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
