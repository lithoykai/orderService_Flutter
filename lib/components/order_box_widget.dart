import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 110,
        child: Card(
          margin: const EdgeInsets.all(5.0),
          elevation: 2,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.clients
                      .firstWhere((element) => element.id == order.clientID)
                      .name
                      .toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Oswald',
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.clients
                        .firstWhere((element) => element.id == order.clientID)
                        .address
                        .toString(),
                    style: const TextStyle(fontFamily: 'Lora'),
                  ),
                  Text(
                      'Data estimada: ${DateFormat('d/MM').format(order.deadline)}'),
                ],
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ordem: #${order.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 2,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: () {
                    Provider.of<CompletedOrderServices>(context, listen: false)
                        .addOrderData(order);
                    Provider.of<CompletedOrderServices>(context, listen: false)
                        .indexToSwitch = 0;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
