import 'package:flutter/material.dart';
import 'package:orders_project/utils/app_routers.dart';

import '../core/models/order.dart';

class OrderBoxWidget extends StatelessWidget {
  final Order order;
  const OrderBoxWidget(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        order.client.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.problem),
          Text(
            order.client.address,
          )
        ],
      ),
      trailing: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
        onPressed: () {
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
